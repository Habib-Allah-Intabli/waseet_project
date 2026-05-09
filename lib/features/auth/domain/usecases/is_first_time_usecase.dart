import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';

class IsFirstTimeUseCase {
  final AuthRepository repository;
  IsFirstTimeUseCase(this.repository);

  bool call() {
    return repository.isFirstTimeOpen();
  }
}
