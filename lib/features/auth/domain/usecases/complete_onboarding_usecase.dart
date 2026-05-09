import 'package:waseet_project/features/auth/domain/repositories/auth_repository.dart';

class CompleteOnboardingUseCase {
  final AuthRepository repository;
  CompleteOnboardingUseCase(this.repository);

  Future<void> call() {
    return repository.completeOnboarding();
  }
}
