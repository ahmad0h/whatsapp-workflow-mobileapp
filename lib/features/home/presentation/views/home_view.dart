import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_appbar.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_footer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_order_section.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_stats_section.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_status_toggle.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/home_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/notification_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/home_widgets/responsive_util.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_details_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/option_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/reject_order_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';
import 'package:whatsapp_workflow_mobileapp/core/widgets/connectivity_wrapper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;
  bool _isInitialized = false;
  bool hasInternetConnection = true;
  String selectedTab = 'All Orders';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OrderCardModel? _selectedOrder;
  bool _showRejectDrawer = false;

  @override
  void initState() {
    super.initState();
    NotificationUtils.setupNotificationListener(
      context,
      _audioPlayer,
      _isInitialized,
      (message) => _handleNotificationReceived(message),
      (isInitialized) => _isInitialized = isInitialized,
    ).then((subscription) {
      _messageStreamSubscription = subscription;
    });

    // Check if we have a valid token before making API calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenManager = TokenManager();
      if (tokenManager.accessToken != null &&
          tokenManager.accessToken!.isNotEmpty) {
        context.read<HomeBloc>().add(const HomeEvent.getOrdersData());
        context.read<HomeBloc>().add(const HomeEvent.getOrderStats());
        context.read<HomeBloc>().add(const HomeEvent.getBranchData());
      }
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleNotificationReceived(RemoteMessage message) {
    final title = message.notification?.title?.toLowerCase() ?? '';
    final dataTitle = message.data['title']?.toString().toLowerCase() ?? '';

    // Refresh orders for relevant notifications
    if (title.contains('new order') ||
        title.contains('customer arrived') ||
        title.contains('arrived') ||
        title.contains('payment') ||
        title.contains('manager approved') ||
        title.contains('approved') ||
        dataTitle.contains('payment') ||
        dataTitle.contains('manager approved') ||
        dataTitle.contains('approved') ||
        title.contains('in-progress') ||
        title.contains('in progress') ||
        dataTitle.contains('in-progress') ||
        dataTitle.contains('in progress')) {
      log('Refreshing orders list due to notification...');

      if (mounted) {
        context.read<HomeBloc>().add(const HomeEvent.getOrdersData());
      }
    }
  }

  void _showOrderDetails(OrderCardModel model) {
    if (_scaffoldKey.currentState!.isEndDrawerOpen) {
      Navigator.of(context).pop();
    }

    setState(() {
      _selectedOrder = model;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }

  void _handleOrderUpdated(OrderCardModel updatedOrder) {
    final homeBloc = context.read<HomeBloc>();

    // Update the selected order to reflect the changes immediately
    if (_selectedOrder != null &&
        _selectedOrder!.orderData.id == updatedOrder.orderData.id) {
      setState(() {
        _selectedOrder = updatedOrder;
      });
    }

    // Refresh the orders list to get the latest data from the server
    homeBloc.add(const HomeEvent.getOrdersData());

    // Close the sidebar/drawer after order update
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop(); // Close the drawer
    }

    // Reset the selected order and showRejectDrawer state
    setState(() {
      _selectedOrder = null;
      _showRejectDrawer = false;
    });
  }

  void _handleMenuPressed() {
    if (_selectedOrder == null) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedOrder = null;
      });

      Future.delayed(Duration(milliseconds: 100), () {
        _scaffoldKey.currentState?.openEndDrawer();
      });
    }
  }

  void _handleRejectPressed() {
    setState(() {
      _showRejectDrawer = true;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _handleOrderRejected() {
    // Close the drawer first
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    // Then update the state
    setState(() {
      _showRejectDrawer = false;
      _selectedOrder = null;
    });

    // Refresh orders list
    context.read<HomeBloc>().add(const HomeEvent.getOrdersData());
  }

  void _handleDrawerChanged(bool isOpen) {
    if (!isOpen) {
      setState(() {
        if (!_showRejectDrawer) {
          _selectedOrder = null;
        }
        _showRejectDrawer = false;
      });
    }
  }

  void _handleTabChanged(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);
    final headerFontSize = ResponsiveUtils.getHeaderFontSize(context);
    // final screenWidth = MediaQuery.of(context).size.width;
    // final orientation = MediaQuery.of(context).orientation;

    return ConnectivityWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: _showRejectDrawer && _selectedOrder != null
            ? RejectOrderDrawer(
                orderNumber: _selectedOrder!.orderNumber,
                orderId: _selectedOrder!.orderData.id ?? '',
                order: _selectedOrder,
                onOrderUpdated: (updatedOrder) {
                  // Update the selected order with the rejected status
                  setState(() {
                    _selectedOrder = updatedOrder;
                  });
                  // Let the drawer close itself after the update
                },
                onOrderRejected: _handleOrderRejected,
              )
            : _selectedOrder != null
            ? OrderDetailsDrawer(
                order: _selectedOrder!,
                onOrderUpdated: _handleOrderUpdated,
                onRejectPressed: _handleRejectPressed,
              )
            : const OptionDrawer(),
        onEndDrawerChanged: _handleDrawerChanged,
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.getOrdersListStatus == ResponseStatus.failure) {}
          },
          builder: (context, state) {
            final isLoading =
                state.getOrdersListStatus == ResponseStatus.loading;
            List<OrderCardModel> orders = [];

            if (!isLoading && state.ordersList != null) {
              orders = HomeUtils.processOrders(state.ordersList!);
            }

            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Responsive AppBar
                      HomeAppBar(onMenuPressed: _handleMenuPressed),

                      // Status toggles section
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            top: 32,
                          ),
                          child: Column(
                            children: [
                              BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, state) {
                                  final isEnabled =
                                      state.getBranchesData?.orderingStatus
                                          ?.toLowerCase() !=
                                      'disabled';
                                  final isLoading =
                                      state.updateBranchOrderingStatusStatus ==
                                      ResponseStatus.loading;
                                  return HomeStatusToggle(
                                    isEnabled: isEnabled,
                                    isLoading: isLoading,
                                    onChanged: (value) {
                                      log(
                                        'value: ${state.getBranchesData?.branchId}',
                                      );
                                      context.read<HomeBloc>().add(
                                        HomeEvent.updateBranchOrderingStatus(
                                          state.getBranchesData?.branchId ?? '',
                                          value ? 'enabled' : 'disabled',
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Stats cards section
                      HomeStatsSection(horizontalPadding: horizontalPadding),

                      // Orders section
                      HomeOrdersSection(
                        horizontalPadding: horizontalPadding,
                        headerFontSize: headerFontSize,
                        selectedTab: selectedTab,
                        orders: orders,
                        isLoading: isLoading,
                        onTabChanged: _handleTabChanged,
                        onOrderTap: _showOrderDetails,
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 50)),
                    ],
                  ),
                ),
                // Footer
                HomeFooter(horizontalPadding: horizontalPadding),
              ],
            );
          },
        ),
      ),
    );
  }
}
