import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:swarnet_admin_client/services/api.dart';
import 'package:swarnet_admin_client/services/shared_preferences_manager.dart';

import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Api api = Api();
  final SharedPreferencesManager manager = SharedPreferencesManager();

  LoginBloc() : super(LoginLoadingState()) {
    on<InitEvent>(_init);
    on<LoginScreenFormSubmitEvent>(_login);
  }

  void _init(InitEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    Response resp = await api.getUserProfile();
    if (resp.statusCode == 200) {
      emit(LoginSuccessState());
    } else {
      emit(LoginLoadedState());
    }
  }

  void _login(
      LoginScreenFormSubmitEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    Response resp = await api.login(event.username, event.password);
    if (resp.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
      String accessToken = decodedResponse['access_token'];
      await manager.saveAccessToken(accessToken);
      emit(LoginSuccessState());
    } else {
      emit(LoginFailureState());
    }
  }
}
