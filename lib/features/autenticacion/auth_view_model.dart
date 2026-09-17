import '../../core/base_view_model.dart';
import '../../repositories/auth_repository.dart';

class AuthViewModel extends BaseViewModel {
  final AuthRepository repository;
  AuthViewModel(this.repository);
  Future<bool> login(String username, String password) =>
      run(() => repository.login(username, password));
  Future<bool> restore() => run(repository.restore);
  Future<bool> logout() => run(repository.logout);
}
