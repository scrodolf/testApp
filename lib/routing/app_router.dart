import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../features/logs/ui/logs_screen.dart';
import '../features/meals/ui/meals_screen.dart';
import '../features/products/ui/products_screen.dart';
import '../features/statistics/ui/statistics_screen.dart';
import '../features/settings/ui/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/logs',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/logs',
          name: 'logs',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LogsScreen()),
        ),
        GoRoute(
          path: '/meals',
          name: 'meals',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MealsScreen()),
        ),
        GoRoute(
          path: '/products',
          name: 'products',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProductsScreen()),
        ),
        GoRoute(
          path: '/statistics',
          name: 'statistics',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: StatisticsScreen()),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
  ],
);
