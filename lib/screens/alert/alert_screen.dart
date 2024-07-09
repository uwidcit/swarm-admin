import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:swarnet_admin_client/models/alert.dart';
import 'package:swarnet_admin_client/screens/alert/alert_screen_bloc.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);
  static String routeName = '/alerts';

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen>
    with AutomaticKeepAliveClientMixin {
  final AlertScreenBloc _bloc = AlertScreenBloc()..add(AlertScreenLoadEvent());
  final PopupController _popupController = PopupController();
  final _createAlertFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: BlocConsumer<AlertScreenBloc, AlertScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is AlertScreenResolveSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Alert resolved successfully!"),
              ),
            );
          }
          if (state is AlertScreenFalsifySuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Alert marked as false!"),
              ),
            );
          }
        },
        builder: (context, state) {
          return FlutterMap(
            options: MapOptions(
              center: const LatLng(10.536, -61.311951),
              zoom: 10.0,
              minZoom: 9.0,
              maxZoom: 18.0,
              onTap: (_, __) => _popupController
                  .hideAllPopups(), // Hide popup when the map is tapped.
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                    spiderfyCircleRadius: 80,
                    spiderfySpiralDistanceMultiplier: 2,
                    circleSpiralSwitchover: 12,
                    maxClusterRadius: 120,
                    rotate: true,
                    size: const Size(40, 40),
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    fitBoundsOptions: const FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                      maxZoom: 15,
                    ),
                    markers: _bloc.alerts
                        .map((e) => Marker(
                            width: 30,
                            height: 30,
                            point: LatLng(
                                e.location!.latitude, e.location!.longitude),
                            builder: (context) {
                              return const Icon(Icons.location_on);
                            }))
                        .toList(),
                    polygonOptions: const PolygonOptions(
                      borderColor: Colors.blueAccent,
                      color: Colors.black12,
                      borderStrokeWidth: 3,
                    ),
                    onMarkerTap: (Marker? m) {
                      if (m != null) {
                        showPostDetails([m], _bloc.alerts);
                      }
                    },
                    builder: (BuildContext context, List<Marker> markers) {
                      return FloatingActionButton(
                        child: Text(markers.length.toString()),
                        onPressed: () {
                          showPostDetails(markers, _bloc.alerts);
                        },
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Alert getAlertByPoint(LatLng point, List<Alert> emergencies) {
    return emergencies.firstWhere((element) =>
        element.location!.latitude == point.latitude &&
        element.location!.longitude == point.longitude);
  }

  void showPostDetails(List<Marker> markers, List<Alert> emergencies) {
    List<Alert> matchingAlerts =
        markers.map((e) => getAlertByPoint(e.point, emergencies)).toList();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        builder: (BuildContext context) {
          return BlocConsumer<AlertScreenBloc, AlertScreenState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is AlertScreenResolveSuccessState) {
                matchingAlerts
                    .removeWhere((element) => element.id == state.removedId);
              }
              if (state is AlertScreenFalsifySuccessState) {
                matchingAlerts
                    .removeWhere((element) => element.id == state.removedId);
              }
            },
            builder: (context, state) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${matchingAlerts.length} alerts in this area",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: matchingAlerts.length,
                        itemBuilder: (context, index) {
                          Alert alert = matchingAlerts[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              radius: 40,
                            ),
                            title: Row(
                              children: [
                                Text(alert.user.name),
                              ],
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(alert.text)),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _bloc.add(AlertResolveEvent(alert.id));
                                      },
                                      icon: const Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _bloc.add(AlertFalsifyEvent(alert.id));
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
