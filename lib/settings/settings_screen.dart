import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';

/// Root settings screen offering navigation to specific configuration areas.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(themeMode.name),
            onTap: () async {
              final mode = await showDialog<ThemeMode>(
                context: context,
                builder: (context) => _ThemeDialog(current: themeMode),
              );
              if (mode != null) {
                ref.read(themeModeProvider.notifier).state = mode;
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Custom Units'),
            subtitle: const Text('Create or edit measurement units'),
            onTap: () => context.push('/settings/units'),
          ),
          ListTile(
            title: const Text('Meal Types'),
            subtitle: const Text('Breakfast, Lunch …'),
            onTap: () => context.push('/settings/meal-types'),
          ),
          const Divider(),
          _ExperimentalTile(
            title: 'QR Code Scanning',
            route: '/settings/experimental/qr',
          ),
          _ExperimentalTile(
            title: 'Data Export / Import',
            route: '/settings/experimental/export',
          ),
          if (kDebugMode) ...[
            const Divider(),
            ListTile(
              title: const Text('Create sample data'),
              onTap: () => context.push('/settings/debug/sample-data'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThemeDialog extends StatelessWidget {
  const _ThemeDialog({required this.current});
  final ThemeMode current;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select theme'),
      children: ThemeMode.values
          .map((m) => RadioListTile<ThemeMode>(
                title: Text(m.name),
                value: m,
                groupValue: current,
                onChanged: (val) => Navigator.pop(context, val),
              ))
          .toList(),
    );
  }
}

class _ExperimentalTile extends ConsumerStatefulWidget {
  const _ExperimentalTile({required this.title, required this.route});
  final String title;
  final String route;

  @override
  ConsumerState<_ExperimentalTile> createState() => _ExperimentalTileState();
}

class _ExperimentalTileState extends ConsumerState<_ExperimentalTile> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      value: enabled,
      onChanged: (v) {
        setState(() => enabled = v);
        if (v) context.push(widget.route);
      },
    );
  }
}
