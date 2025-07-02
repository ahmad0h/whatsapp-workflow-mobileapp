import 'package:go_router/go_router.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/history_view.dart';

class GoRouterConfig {
  static const String homeView = '/';
  static const String historyView = '/historyView';
}

final GoRouterConfig routerConfig = GoRouterConfig();

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: GoRouterConfig.homeView,
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: GoRouterConfig.historyView,
      builder: (context, state) => const HistoryView(),
    ),
  ],
);
