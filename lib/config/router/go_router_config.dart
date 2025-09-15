import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
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

Widget _buildFadeTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Initial route that checks authentication status
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const InitialRouteWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildFadeTransition(context, animation, secondaryAnimation, child);
        },
      ),
    ),
    // Main app routes
    GoRoute(
      path: GoRouterConfig.homeView,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildFadeTransition(context, animation, secondaryAnimation, child);
        },
      ),
    ),
    GoRoute(
      path: GoRouterConfig.historyView,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HistoryView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildFadeTransition(context, animation, secondaryAnimation, child);
        },
      ),
    ),
    GoRoute(
      path: GoRouterConfig.authView,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AuthView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildFadeTransition(context, animation, secondaryAnimation, child);
        },
      ),
    ),
  ],
);
