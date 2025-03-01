import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomNav;

  const AppScaffold({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.leading,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: actions,
        leading: leading,
      ),
      body: child,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.code),
                  label: 'Üret',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Hesabım',
                ),
              ],
              selectedIndex: _getSelectedIndex(context),
              onDestinationSelected: (index) {
                if (index == 0) {
                  context.go('/generate');
                } else {
                  context.go('/account');
                }
              },
            )
          : null,
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).fullPath ?? '/';
    if (location.startsWith('/generate')) return 0;
    if (location.startsWith('/account')) return 1;
    return 0;
  }
}
