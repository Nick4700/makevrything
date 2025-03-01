import 'package:go_router/go_router.dart';
import '../features/generate/screens/generate_screen.dart';
import '../features/account/screens/account_screen.dart';
import '../features/templates/screens/templates_screen.dart';
import '../features/apps/screens/apps_screen.dart';
import '../features/apps/screens/app_viewer_screen.dart';
import '../features/auth/screens/login_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/generate',
        builder: (context, state) => const GenerateScreen(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/templates',
        builder: (context, state) => const TemplatesScreen(),
      ),
      GoRoute(
        path: '/apps',
        builder: (context, state) => const AppsScreen(),
      ),
      GoRoute(
        path: '/apps/:id',
        builder: (context, state) => AppViewerScreen(
          appId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
