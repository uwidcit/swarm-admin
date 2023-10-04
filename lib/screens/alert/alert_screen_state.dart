part of 'alert_screen_bloc.dart';

@immutable
abstract class AlertScreenState {}

class AlertScreenInitial extends AlertScreenState {}

class AlertScreenLoadingState extends AlertScreenState {}

class AlertScreenLoadErrorState extends AlertScreenState {
  final String message;
  AlertScreenLoadErrorState(this.message);
}

class AlertScreenLoadedState extends AlertScreenState {
  final List<Alert> alerts;
  AlertScreenLoadedState(this.alerts);
}

class AlertScreenCreateSuccessState extends AlertScreenState {
  final Alert alert;
  AlertScreenCreateSuccessState(this.alert);
}

class AlertScreenResolveSuccessState extends AlertScreenLoadedState {
  final String removedId;
  AlertScreenResolveSuccessState(super.alerts, this.removedId);
}

class AlertScreenFalsifySuccessState extends AlertScreenLoadedState {
  final String removedId;
  AlertScreenFalsifySuccessState(super.alerts, this.removedId);
}
