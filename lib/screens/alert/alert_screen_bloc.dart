import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:swarnet_admin_client/models/alert.dart';
import 'package:swarnet_admin_client/services/api.dart';

part 'alert_screen_event.dart';
part 'alert_screen_state.dart';

class AlertScreenBloc extends Bloc<AlertScreenEvent, AlertScreenState> {
  final Api api = Api();

  List<Alert> alerts = [];
  AlertScreenBloc() : super(AlertScreenInitial()) {
    on<AlertScreenEvent>((event, emit) async {
      if (event is AlertScreenLoadEvent) {
        emit(AlertScreenLoadingState());
        // Fetch alerts from API
        alerts = await api.getAlerts();
        emit(AlertScreenLoadedState(alerts));
      }
      if (event is AlertResolveEvent) {
        bool alertResolved = await api.setAlertResolved(event.alertId);
        if (alertResolved) {
          alerts.removeWhere((element) => element.id == event.alertId);
          emit(AlertScreenResolveSuccessState(alerts, event.alertId));
        } else {
          emit(AlertScreenLoadedState(alerts));
        }
      }
      if (event is AlertFalsifyEvent) {
        bool alertFalsified = await api.setAlertFalse(event.alertId);
        if (alertFalsified) {
          alerts.removeWhere((element) => element.id == event.alertId);
          emit(AlertScreenFalsifySuccessState(alerts, event.alertId));
        } else {
          emit(AlertScreenLoadedState(alerts));
        }
      }
    });
  }
}
