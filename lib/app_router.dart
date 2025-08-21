import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/logs_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/meal_form_view.dart';
import 'screens/products_screen.dart';
import 'screens/product_form_view.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/logs',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.history), label: 'Logs'),
              NavigationDestination(icon: Icon(Icons.restaurant), label: 'Meals'),
              NavigationDestination(icon: Icon(Icons.shopping_bag), label: 'Products'),
              NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
              NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/logs', builder: (context, state) => const LogsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/meals',
            builder: (context, state) => const MealsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const MealFormView(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return MealFormView(mealId: id);
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const ProductFormView(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return ProductFormView(productId: id);
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ]),
      ],
    ),
  ],
);
