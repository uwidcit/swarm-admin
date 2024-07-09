abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginLoadedState {}
