import 'package:go_router/go_router.dart';
import '../features/logs/ui/logs_screen.dart';
import '../features/meals/ui/meals_screen.dart';
import '../features/products/ui/product_list_screen.dart';
import '../features/products/ui/add_product_form.dart';
import '../features/statistics/ui/statistics_screen.dart';
import '../features/settings/ui/settings_screen.dart';
import '../widgets/app_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/logs',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logs',
              builder: (context, state) => const LogsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => const MealsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductListScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddProductForm(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
