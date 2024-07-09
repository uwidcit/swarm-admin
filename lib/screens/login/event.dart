abstract class LoginEvent {}

class InitEvent extends LoginEvent {}

class LoginScreenFormSubmitEvent extends LoginEvent {
  final String username;
  final String password;
  LoginScreenFormSubmitEvent(this.username, this.password);
}
