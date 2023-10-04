import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swarnet_admin_client/screens/login/view.dart';
import 'package:swarnet_admin_client/theme/theme.dart';
import 'widgets/swarnet_navigation_rail.dart';

void main() {
  runApp(const SwarnetAdminFrontendApp());
}

class SwarnetAdminFrontendApp extends StatefulWidget {
  const SwarnetAdminFrontendApp({super.key});

  @override
  State<SwarnetAdminFrontendApp> createState() =>
      _SwarnetAdminFrontendAppState();
}

class _SwarnetAdminFrontendAppState extends State<SwarnetAdminFrontendApp> {
  // Set up the router for the app

  final _router = GoRouter(
    initialLocation: "/dashboard",
    routes: [
      GoRoute(
        path: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final siteMapPage = SwarnetNavigationRail.sitemap
              .firstWhere((element) => element['path'] == state.fullPath);
          final int siteMapIndex = siteMapPage['index'] ?? 0;
          return Scaffold(
            body: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SwarnetNavigationRail(
                  selectedIndex: siteMapIndex,
                ),
                const VerticalDivider(
                  width: 2,
                ),
                Expanded(child: child),
              ],
            ),
          );
        },
        routes: SwarnetNavigationRail.sitemap
            .map(
              (Map<String, dynamic> e) => GoRoute(
                path: e['path'],
                builder: (context, state) => e['widget'],
              ),
            )
            .toList(),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final swarnetTheme = SwarnetTheme(context);
    return MaterialApp.router(
      title: 'Swarnet',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: swarnetTheme.toThemeData(),
    );
  }
}
