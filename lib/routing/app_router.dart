import 'package:go_router/go_router.dart';
import '../features/logs/ui/logs_screen.dart';
import '../features/logs/ui/log_meal_form.dart';
import '../features/meals/ui/meals_list_screen.dart';
import '../features/meals/ui/create_meal_form.dart';
import '../features/meals/ui/meal_details_screen.dart';
import '../features/products/ui/product_list_screen.dart';
import '../features/products/ui/add_product_form.dart';
import '../features/products/ui/product_details_screen.dart';
import '../features/products/ui/edit_product_form.dart';

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
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const LogMealForm(),
                ),
                GoRoute(
                  path: ':id/edit',
                  builder: (context, state) => LogMealForm(
                      logId: int.parse(state.pathParameters['id']!)),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => const MealsListScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (context, state) => const CreateMealForm(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => MealDetailsScreen(
                      mealId: int.parse(state.pathParameters['id']!)),
                ),
              ],
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
                GoRoute(
                  path: ':id',
                  builder: (context, state) => ProductDetailsScreen(
                    productId: int.parse(state.pathParameters['id']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) => EditProductForm(
                        productId: int.parse(state.pathParameters['id']!),
                      ),
                    ),
                  ],
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
