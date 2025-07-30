import 'package:go_router/go_router.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/auth_view.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/initial_route_wrapper.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/history_view.dart';

class GoRouterConfig {
  static const String homeView = '/homeView';
  static const String authView = '/auth';
  static const String historyView = '/historyView';
}

final GoRouterConfig routerConfig = GoRouterConfig();

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Initial route that checks authentication status
    GoRoute(
      path: '/',
      builder: (context, state) => const InitialRouteWrapper(),
    ),
    // Main app routes
    GoRoute(
      path: GoRouterConfig.homeView,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: GoRouterConfig.historyView,
      builder: (context, state) => const HistoryView(),
    ),
    GoRoute(
      path: GoRouterConfig.authView,
      builder: (context, state) => const AuthView(),
    ),
  ],
);
