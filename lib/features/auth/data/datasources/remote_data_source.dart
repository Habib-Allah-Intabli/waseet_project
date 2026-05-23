import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:waseet_project/core/error/exceptions.dart';
import 'package:waseet_project/features/auth/data/models/user_model.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> register({required UserModel user});
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity?> getUserById(String uId);
  Future<void> logout();
  Future<void> updateUser({required UserModel user});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseMessaging messaging;

  static const String _collection = 'users';
  static const Duration _timeout = Duration(seconds: 15);

  AuthRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.messaging,
  });

  @override
  Future<UserEntity> register({required UserModel user}) async {
    try {
      // 1. Create user in Firebase Auth
      final credential = await auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          )
          .timeout(_timeout);

      if (credential.user == null) {
        throw const ServerException('فشل إنشاء الحساب، يرجى المحاولة لاحقاً');
      }

      // 2. Get FCM Token (Only for supported platforms: Mobile and Web)
      String? fcmToken;
      try {
        if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
          fcmToken = await messaging.getToken().timeout(
            const Duration(seconds: 5),
          );
        }
      } catch (e) {
        debugPrint('FCM Token skipped or error: $e');
      }

      // 3. Prepare user model with the new UID and FCM token
      final updatedModel = UserModel(
        uId: credential.user!.uid,
        fullName: user.fullName,
        email: user.email,
        phone: user.phone,
        password: user.password,
        fcmToken: fcmToken,
      );

      // 4. Save profile info to Firestore
      await firestore
          .collection(_collection)
          .doc(updatedModel.uId)
          .set(updatedModel.toMap())
          .timeout(_timeout);

      return updatedModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e));
    } on FirebaseException catch (e) {
      throw ServerException(_mapFirebaseError(e));
    } catch (e) {
      throw ServerException('حدث خطأ غير متوقع: $e');
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Sign in with Firebase Auth
      final credential = await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(_timeout);

      if (credential.user == null) {
        throw const ServerException('فشل تسجيل الدخول');
      }

      // 2. Get User profile from Firestore
      final doc = await firestore
          .collection(_collection)
          .doc(credential.user!.uid)
          .get()
          .timeout(_timeout);

      if (!doc.exists || doc.data() == null) {
        throw const ServerException('بيانات المستخدم غير موجودة في قاعدة البيانات');
      }

      final userModel = UserModel.fromMap(doc.data()!);

      // 3. Update FCM Token if changed
      try {
        String? currentToken = await messaging.getToken().timeout(
          const Duration(seconds: 5),
        );
        if (currentToken != null && currentToken != userModel.fcmToken) {
          await firestore.collection(_collection).doc(userModel.uId).update({
            'fcm_token': currentToken,
          });
        }
      } catch (e) {
        debugPrint('FCM Token update error: $e');
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapAuthError(e));
    } on FirebaseException catch (e) {
      throw ServerException(_mapFirebaseError(e));
    } catch (e) {
      throw ServerException('حدث خطأ: $e');
    }
  }

  @override
  Future<UserEntity?> getUserById(String uId) async {
    try {
      final doc = await firestore
          .collection(_collection)
          .doc(uId)
          .get()
          .timeout(_timeout);

      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException(_mapFirebaseError(e));
    } catch (e) {
      throw const ServerException('فشل جلب بيانات المستخدم');
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<void> updateUser({required UserModel user}) async {
    try {
      await firestore
          .collection(_collection)
          .doc(user.uId)
          .update(user.toMap())
          .timeout(_timeout);
    } on FirebaseException catch (e) {
      throw ServerException(_mapFirebaseError(e));
    } catch (e) {
      throw ServerException('فشل تحديث بيانات المستخدم: $e');
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مسجل بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'network-request-failed':
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'خطأ في المصادقة: ${e.message ?? e.code}';
    }
  }

  String _mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        return 'الخدمة غير متوفرة حالياً';
      case 'permission-denied':
        return 'ليس لديك صلاحية للوصول';
      default:
        return 'حدث خطأ في قاعدة البيانات: ${e.message ?? e.code}';
    }
  }
}
