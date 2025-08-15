import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  static final List<_Destination> _destinations = [
    _Destination('/logs', Icons.list_alt, 'Logs'),
    _Destination('/meals', Icons.restaurant, 'Meals'),
    _Destination('/products', Icons.shopping_bag, 'Products'),
    _Destination('/statistics', Icons.bar_chart, 'Statistics'),
    _Destination('/settings', Icons.settings, 'Settings'),
  ];

  int _locationToIndex(String location) {
    return _destinations.indexWhere((d) => location.startsWith(d.route));
  }

  void _onItemTapped(BuildContext context, int index) {
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouter.of(context).location;
    final int currentIndex = _locationToIndex(location);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food App'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.route, this.icon, this.label);
  final String route;
  final IconData icon;
  final String label;
}
