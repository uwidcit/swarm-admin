import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swarnet_admin_client/screens/dashboard/view.dart';
import 'package:swarnet_admin_client/widgets/nav_rail_logo.dart';

class SwarnetNavigationRail extends StatefulWidget {
  const SwarnetNavigationRail({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  static final List<Map<String, dynamic>> sitemap = [
    {
      "index": 0,
      "path": "/dashboard",
      "icon": Icons.dashboard_outlined,
      "label": "Dashboard",
      "widget": DashboardPage(),
    },
    {
      "index": 1,
      "path": "/posts",
      "icon": Icons.feed_outlined,
      "label": "Posts",
      "widget": DashboardPage(),
    },
    {
      "index": 2,
      "path": "/alerts",
      "icon": Icons.warning_amber_outlined,
      "label": "Alerts",
      "widget": DashboardPage(),
    },
    {
      "index": 3,
      "path": "/topics",
      "icon": Icons.topic_outlined,
      "label": "Topics",
      "widget": DashboardPage(),
    },
    {
      "index": 4,
      "path": "/broadcast",
      "icon": Icons.broadcast_on_home_outlined,
      "label": "Broadcasts",
      "widget": DashboardPage(),
    },
    {
      "index": 5,
      "path": "/reports",
      "icon": Icons.area_chart_outlined,
      "label": "Reports and Analytics",
      "widget": DashboardPage(),
    },
    {
      "index": 6,
      "path": "/users",
      "icon": Icons.person_outline_outlined,
      "label": "Users",
      "widget": DashboardPage(),
    },
    {
      "index": 6,
      "path": "/centers",
      "icon": Icons.health_and_safety_outlined,
      "label": "Disaster Relief Centres",
      "widget": DashboardPage(),
    },
    {
      "index": 7,
      "path": "/logout",
      "icon": Icons.logout_outlined,
      "label": "Logout",
      "widget": null,
    },
  ];

  @override
  State<SwarnetNavigationRail> createState() => _SwarnetNavigationRail();
}

class _SwarnetNavigationRail extends State<SwarnetNavigationRail> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: const NavigationRailLogo(),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: Icon(isExpanded
                  ? Icons.keyboard_double_arrow_left
                  : Icons.keyboard_double_arrow_right),
            ),
          ),
        ),
      ),
      extended: isExpanded,
      labelType: NavigationRailLabelType.none,
      selectedIndex: widget.selectedIndex,
      selectedLabelTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      onDestinationSelected: (index) async {
        if (index < SwarnetNavigationRail.sitemap.length - 1) {
          Map<String, dynamic> navMap = SwarnetNavigationRail.sitemap
              .firstWhere((element) => element['index'] == index);
          context.go(navMap['path']);
        } else {
          final shouldExit = await exitConfirmDialog(context);
          if (shouldExit != null && shouldExit == true) {
            debugPrint("LOGOUT");
          }
        }
      },
      useIndicator: true,
      destinations: SwarnetNavigationRail.sitemap
          .map((Map<String, dynamic> e) => NavigationRailDestination(
                icon: Icon(e['icon'] as IconData?),
                label: Text(e['label'], textAlign: TextAlign.center),
              ))
          .toList(),
    );
  }

  Future<bool?> exitConfirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit website builder?'),
        content:
            const Text('Are you sure you want to exit the website builder?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No, stay'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            child: const Text('Yes, Exit'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}
