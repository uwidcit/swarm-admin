part of 'alert_screen_bloc.dart';

@immutable
abstract class AlertScreenEvent {}

class AlertScreenLoadEvent extends AlertScreenEvent {}

class AlertResolveEvent extends AlertScreenEvent {
  final String alertId;
  AlertResolveEvent(this.alertId);
}

class AlertFalsifyEvent extends AlertScreenEvent {
  final String alertId;
  AlertFalsifyEvent(this.alertId);
}
