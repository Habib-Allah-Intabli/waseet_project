class AppValidator {
  // Regex for Email validation
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // Regex for Phone validation (Syrian format example: 09xx xxx xxx or 9xx xxx xxx)
  static final RegExp _phoneRegExp = RegExp(
    r'^(09|9)[3-9][0-9]{7}$',
  );

  // Regex for Name validation (Arabic or English, minimum 2 characters)
  static final RegExp _nameRegExp = RegExp(
    r'^[\u0600-\u06FFa-zA-Z\s]{2,}$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    // Remove spaces if any
    final cleanValue = value.replaceAll(' ', '');
    if (!_phoneRegExp.hasMatch(cleanValue)) {
      return 'رقم الهاتف غير صالح (يجب أن يبدأ بـ 09 أو 9)';
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    if (!_nameRegExp.hasMatch(value)) {
      return '$fieldName غير صالح';
    }
    return null;
  }
}
