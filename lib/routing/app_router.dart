import 'package:go_router/go_router.dart';
import '../features/logs/ui/logs_screen.dart';
import '../features/meals/ui/meals_screen.dart';
import '../features/products/ui/product_list_screen.dart';
import '../features/products/ui/add_product_form.dart';
import '../features/statistics/ui/statistics_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/custom_units_screen.dart';
import '../features/settings/meal_types_screen.dart';
import '../features/settings/experimental/qr_scanner_screen.dart';
import '../features/settings/experimental/export_import_screen.dart';
import '../features/settings/debug_sample_data_screen.dart';
=======
=======
import '../settings/settings_screen.dart';
import '../settings/custom_units_screen.dart';
import '../settings/meal_types_screen.dart';
import '../settings/experimental/qr_scanner_screen.dart';
import '../settings/experimental/export_import_screen.dart';
import '../settings/debug_sample_data_screen.dart';
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
              routes: [
                GoRoute(
                  path: 'units',
                  builder: (context, state) => const CustomUnitsScreen(),
                ),
                GoRoute(
                  path: 'meal-types',
                  builder: (context, state) => const MealTypesScreen(),
                ),
                GoRoute(
                  path: 'experimental/qr',
                  builder: (context, state) =>
                      const QrScannerPlaceholderScreen(),
                ),
                GoRoute(
                  path: 'experimental/export',
                  builder: (context, state) =>
                      const ExportImportPlaceholderScreen(),
                ),
                GoRoute(
                  path: 'debug/sample-data',
                  builder: (context, state) =>
                      const DebugSampleDataScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
