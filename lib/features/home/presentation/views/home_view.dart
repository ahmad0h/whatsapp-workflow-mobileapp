import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/mapping.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_details_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/option_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/reject_order_drawer.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp_workflow_mobileapp/core/services/token_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();

    // Check if we have a valid token before making API calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenManager = TokenManager();
      if (tokenManager.accessToken != null &&
          tokenManager.accessToken!.isNotEmpty) {
        context.read<HomeBloc>().add(HomeEvent.started());
        context.read<HomeBloc>().add(const HomeEvent.getOrderStats());
        context.read<HomeBloc>().add(HomeEvent.getBranchData());
      }
    });
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundFile) async {
    try {
      if (!_isInitialized) {
        await _audioPlayer.setReleaseMode(ReleaseMode.release);
        _isInitialized = true;
      }
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _setupNotificationListener() {
    _messageStreamSubscription = FirebaseMessaging.onMessage.listen((
      message,
    ) async {
      debugPrint('Notification received: ${message.notification?.title}');
      debugPrint('Notification data: ${message.data}');

      final title = message.notification?.title?.toLowerCase() ?? '';
      final dataTitle = message.data['title']?.toString().toLowerCase() ?? '';

      // Play sound based on notification type
      if (title.contains('new order') || dataTitle.contains('new order')) {
        await _playSound('received.mp3');
      } else if (title.contains('arrived') || dataTitle.contains('arrived')) {
        await _playSound('arrived.mp3');
      }

      // Refresh orders for relevant notifications
      if (title.contains('new order') ||
          title.contains('customer arrived') ||
          title.contains('arrived') ||
          title.contains('payment') ||
          dataTitle.contains('payment')) {
        debugPrint('Refreshing orders list due to notification...');

        if (mounted) {
          context.read<HomeBloc>().add(const HomeEvent.getOrdersData());
        }
      }
    });
  }

  bool hasInternetConnection = true;
  String selectedTab = 'All Orders';

  // Filter orders based on selected tab
  List<OrderCardModel> _filterOrders(List<OrderCardModel> orders, String tab) {
    if (tab == 'All Orders') return orders;

    return orders.where((order) {
      // Normalize the status by trimming and converting to lowercase
      final status = order.status.trim().toLowerCase();

      // Map the tab names to their corresponding status values
      switch (tab) {
        case 'New Orders':
          return status == 'active' || status == 'new order';
        case 'In Progress':
          return status == 'in_progress' || status == 'in progress';
        case 'Arrived':
          return status == 'arrived';
        case 'Completed':
          return status == 'completed';
        default:
          return false; // Don't show any orders for unknown tabs
      }
    }).toList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OrderCardModel? _selectedOrder;
  bool _showRejectDrawer = false;

  // Helper method to get responsive padding
  double _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 80;
    } else if (screenWidth > 900) {
      return 60;
    } else {
      return 48;
    }
  }

  // Helper method to get responsive font sizes
  double _getHeaderFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 36;
    } else if (screenWidth > 900) {
      return 34;
    } else {
      return 32;
    }
  }

  double _getOrderNumberFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 35;
    } else if (screenWidth > 900) {
      return 33;
    } else {
      return 31;
    }
  }

  // Helper method to get responsive aspect ratio
  double _getGridAspectRatio(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;

    if (orientation == Orientation.landscape) {
      if (screenWidth > 1200) {
        return 8 / 3.3;
      } else {
        return 8 / 3.8;
      }
    } else {
      if (screenWidth > 900) {
        return 8 / 4.0;
      } else {
        return 8 / 4.3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _getHorizontalPadding(context);
    final headerFontSize = _getHeaderFontSize(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
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
              onOrderRejected: () {
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
              },
            )
          : _selectedOrder != null
          ? OrderDetailsDrawer(
              order: _selectedOrder!,
              onOrderUpdated: _handleOrderUpdated,
              onRejectPressed: () {
                setState(() {
                  _showRejectDrawer = true;
                });
                _scaffoldKey.currentState?.openEndDrawer();
              },
            )
          : const OptionDrawer(),
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) {
          setState(() {
            if (!_showRejectDrawer) {
              _selectedOrder = null;
            }
            _showRejectDrawer = false;
          });
        }
      },

      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.getOrdersListStatus == ResponseStatus.failure) {}
        },
        builder: (context, state) {
          final isLoading = state.getOrdersListStatus == ResponseStatus.loading;
          List<OrderCardModel> orders = [];

          if (!isLoading && state.ordersList != null) {
            // Map to OrderCardModel and sort by orderDate in descending order (newest first)
            orders = state.ordersList!.map(mapOrderToCardModel).toList()
              ..sort(
                (a, b) => (b.orderData.orderDate ?? '').compareTo(
                  a.orderData.orderDate ?? '',
                ),
              );
          }

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Responsive AppBar
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leading: const SizedBox.shrink(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: false,
                      pinned: true,
                      toolbarHeight: kToolbarHeight,
                      expandedHeight: orientation == Orientation.landscape
                          ? 70
                          : 80,
                      actions: [SizedBox.shrink()],
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Responsive logo sizing
                                Image.asset(
                                  'assets/ryze-logo.png',
                                  height: screenWidth > 1200 ? 50 : 40,
                                ),
                                BlocConsumer<HomeBloc, HomeState>(
                                  listener: (context, state) {
                                    if (state.getBranchesDataStatus ==
                                        ResponseStatus.success) {}

                                    if (state.getBranchesDataStatus ==
                                        ResponseStatus.failure) {}
                                  },
                                  builder: (context, state) {
                                    var branchData = state.getBranchesData;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/company-logo.png',
                                          height: screenWidth > 1200 ? 45 : 35,
                                        ),
                                        SizedBox(
                                          width: screenWidth > 900 ? 12 : 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              branchData
                                                      ?.business
                                                      ?.businessName ??
                                                  '',
                                              style: TextStyle(
                                                color: AppColors.background,
                                                fontSize: screenWidth > 1200
                                                    ? 14
                                                    : 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              branchData?.branchName ?? '',
                                              style: TextStyle(
                                                color:
                                                    AppColors.backgroundLight,
                                                fontSize: screenWidth > 1200
                                                    ? 12
                                                    : 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: screenWidth > 900 ? 32 : 24,
                                        ),
                                        Container(
                                          height: screenWidth > 1200 ? 40 : 33,
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        SizedBox(
                                          width: screenWidth > 900 ? 32 : 24,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.menu,
                                            color: AppColors.background,
                                            size: screenWidth > 1200 ? 36 : 32,
                                          ),
                                          onPressed: () {
                                            if (_selectedOrder == null) {
                                              _scaffoldKey.currentState
                                                  ?.openEndDrawer();
                                            } else {
                                              setState(() {
                                                _selectedOrder = null;
                                              });

                                              Future.delayed(
                                                Duration(milliseconds: 100),
                                                () {
                                                  _scaffoldKey.currentState
                                                      ?.openEndDrawer();
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Status toggles section with responsive padding
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
                                return _buildStatusToggle(
                                  isEnabled ? 'OPEN' : 'CLOSED',
                                  isEnabled
                                      ? 'You are currently accepting all orders'
                                      : 'You are not accepting orders',
                                  isEnabled,
                                  isEnabled
                                      ? AppColors.primary
                                      : AppColors.error,
                                  (value) {
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
                                  isLoading: isLoading,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Responsive Stats cards section
                    BlocConsumer<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state.getOrderStatsStatus ==
                            ResponseStatus.failure) {}
                      },
                      builder: (context, state) {
                        if (state.getOrderStatsStatus ==
                            ResponseStatus.loading) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Lottie.asset(
                                'assets/loading.json',
                                width: screenWidth > 1200 ? 180 : 150,
                              ),
                            ),
                          );
                        }
                        var stats = state.orderStats;
                        return SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.only(
                              left: horizontalPadding,
                              right: horizontalPadding,
                              top: 32,
                            ),
                            child:
                                orientation == Orientation.landscape &&
                                    screenWidth > 1200
                                ? Row(
                                    children: [
                                      _buildStatCard(
                                        'Arrived Customers',
                                        stats?.arrivedCustomers.toString() ??
                                            '0',
                                        AppColors.statusArrived,
                                        'assets/icons/car.svg',
                                      ),
                                      SizedBox(width: 16),
                                      _buildStatCard(
                                        'New Orders',
                                        stats?.newOrders.toString() ?? '0',
                                        AppColors.primary,
                                        'assets/icons/user.svg',
                                      ),
                                      SizedBox(width: 16),
                                      _buildStatCard(
                                        'Preparing',
                                        stats?.preparingOrders.toString() ??
                                            '0',
                                        AppColors.statusPreparing,
                                        'assets/icons/pot.svg',
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      _buildStatCard(
                                        'Arrived Customers',
                                        stats?.arrivedCustomers.toString() ??
                                            '0',
                                        AppColors.statusArrived,
                                        'assets/icons/car.svg',
                                      ),
                                      SizedBox(width: 12),
                                      _buildStatCard(
                                        'New Orders',
                                        stats?.newOrders.toString() ?? '0',
                                        AppColors.primary,
                                        'assets/icons/user.svg',
                                      ),
                                      SizedBox(width: 12),
                                      _buildStatCard(
                                        'Preparing',
                                        stats?.preparingOrders.toString() ??
                                            '0',
                                        AppColors.statusPreparing,
                                        'assets/icons/pot.svg',
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),

                    // Responsive Orders header section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: 32,
                        ),
                        child: Flex(
                          direction:
                              orientation == Orientation.landscape &&
                                  screenWidth > 1000
                              ? Axis.horizontal
                              : Axis.vertical,
                          crossAxisAlignment:
                              orientation == Orientation.landscape &&
                                  screenWidth > 1000
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Orders',
                              style: TextStyle(
                                fontSize: headerFontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (orientation == Orientation.landscape &&
                                screenWidth > 1000)
                              Spacer()
                            else
                              SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildTab(
                                  'All Orders',
                                  isSelected: selectedTab == 'All Orders',
                                  onTap: () => setState(
                                    () => selectedTab = 'All Orders',
                                  ),
                                ),
                                _buildTab(
                                  'New Orders',
                                  isSelected: selectedTab == 'New Orders',
                                  onTap: () => setState(
                                    () => selectedTab = 'New Orders',
                                  ),
                                ),
                                _buildTab(
                                  'In Progress',
                                  isSelected: selectedTab == 'In Progress',
                                  onTap: () => setState(
                                    () => selectedTab = 'In Progress',
                                  ),
                                ),
                                _buildTab(
                                  'Arrived',
                                  isSelected: selectedTab == 'Arrived',
                                  onTap: () =>
                                      setState(() => selectedTab = 'Arrived'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Responsive grid with dynamic cross axis count
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: 32,
                      ),
                      sliver: isLoading
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Lottie.asset(
                                    'assets/loading.json',
                                    width: screenWidth > 1200 ? 180 : 150,
                                  ),
                                ),
                              ),
                            )
                          : SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (_, index) {
                                  final filteredOrders = _filterOrders(
                                    orders,
                                    selectedTab,
                                  );
                                  return _buildOrderCard(filteredOrders[index]);
                                },
                                childCount: _filterOrders(
                                  orders,
                                  selectedTab,
                                ).length,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: screenWidth > 900
                                        ? 32
                                        : 24,
                                    mainAxisSpacing: screenWidth > 900
                                        ? 32
                                        : 24,
                                    childAspectRatio: _getGridAspectRatio(
                                      context,
                                    ),
                                  ),
                            ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 50)),
                  ],
                ),
              ),
              // Responsive Footer
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: horizontalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered By ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth > 1200 ? 14 : 12,
                      ),
                    ),
                    Image.asset(
                      'assets/footer-logo.png',
                      height: screenWidth > 1200 ? 20 : 16,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusToggle(
    String label,
    String description,
    bool value,
    Color color,
    Function(bool)? onChanged, {
    String? imagePath,
    bool isInactive = false,
    bool isLoading = false,
  }) {
    final isEnabled = onChanged != null && !isLoading && !isInactive;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth > 1200 ? 16 : 12.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE4E4E7)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(1, 3),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          if (label.isNotEmpty)
            Container(
              width: screenWidth > 1200 ? 80 : 67,
              height: screenWidth > 1200 ? 60 : 49,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: screenWidth > 1200 ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (imagePath != null)
            Container(
              width: screenWidth > 1200 ? 80 : 67,
              height: screenWidth > 1200 ? 60 : 49,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          SizedBox(width: screenWidth > 1200 ? 20 : 16),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: screenWidth > 1200 ? 18 : 16,
                color: Color(0xFF343330),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: screenWidth > 1200 ? 1.4 : 1.2,
                child: GestureDetector(
                  onTap: isEnabled ? () => onChanged.call(!value) : null,
                  child: Container(
                    width: 52,
                    height: 32,
                    decoration: BoxDecoration(
                      color: value
                          ? AppColors.success
                          : AppColors.textHint.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          left: value ? 22 : 2,
                          top: 2,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.06,
                                  ),
                                  offset: Offset(0, 3),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.15,
                                  ),
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, String icon) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth > 1200 ? 20 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  offset: Offset(1, 3),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth > 1200 ? 18 : 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      icon,
                      width: screenWidth > 1200 ? 28 : 24,
                      height: screenWidth > 1200 ? 28 : 24,
                    ),
                  ],
                ),
                SizedBox(height: screenWidth > 1200 ? 22 : 18),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: screenWidth > 1200 ? 38 : 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: screenWidth > 1200 ? 70 : 59,
              height: screenWidth > 1200 ? 58 : 49,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String text, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? 18 : 15,
          vertical: screenWidth > 1200 ? 10 : 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          color: isSelected ? AppColors.background : Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.textPrimary.withValues(alpha: 0.06)
                  : Colors.transparent,
              blurRadius: isSelected ? 2.5 : 0,
              offset: isSelected ? Offset(1, 3) : Offset.zero,
            ),
          ],
        ),
        margin: EdgeInsets.only(left: screenWidth > 900 ? 16 : 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth > 1200 ? 19 : 17.5,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
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

  // Handle order updates from the details drawer
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

    // Trigger a UI rebuild to ensure the order list is refreshed
    setState(() {
      // This will cause the BlocConsumer to rebuild with the latest state
    });
  }

  Widget _buildOrderCard(OrderCardModel model) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    // Responsive font sizes and spacing
    final orderNumberFontSize = screenWidth > 1200 ? 28.0 : 25.33;
    final customerNameFontSize = screenWidth > 1200 ? 26.0 : 24.0;
    final timeFontSize = screenWidth > 1200 ? 12.0 : 11.08;
    final statusFontSize = screenWidth > 1200 ? 13.0 : 12.0;
    final orderTypeFontSize = screenWidth > 1200 ? 13.0 : 12.0;
    final cardPadding = screenWidth > 1200 ? 20.0 : 16.0;
    final borderWidth = screenWidth > 1200 ? 14.0 : 12.0;

    return GestureDetector(
      onTap: () => _showOrderDetails(model),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.66),
          border: Border(
            left: BorderSide(color: model.statusColor, width: borderWidth),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textHint.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order number and status row
              Row(
                children: [
                  // Order number and type
                  Expanded(
                    child: Wrap(
                      spacing: screenWidth > 1200 ? 10 : 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "#${model.orderNumber}",
                          style: TextStyle(
                            fontSize: orderNumberFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth > 1200 ? 10 : 8,
                            vertical: screenWidth > 1200 ? 5 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            model.orderType.capitalize(),
                            style: TextStyle(
                              fontSize: orderTypeFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 1200 ? 12 : 10,
                      vertical: screenWidth > 1200 ? 5 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: model.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: screenWidth > 1200 ? 10 : 8,
                      children: [
                        Text(
                          model.status == "Is Finished"
                              ? "Finished"
                              : model.orderType == "Delivery" &&
                                    model.status == "arrived"
                              ? "Delivered"
                              : model.status,
                          style: TextStyle(
                            color: model.statusColor,
                            fontSize: statusFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (model.status == "Preparing")
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: screenWidth > 1200 ? 16 : 14,
                            color: model.statusColor,
                          )
                        else if (model.status == "Arrived")
                          Icon(
                            Icons.check_circle_outline,
                            size: screenWidth > 1200 ? 16 : 14,
                            color: model.statusColor,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenWidth > 1200 ? 6 : 4),

              // Time
              Text(
                model.time,
                style: TextStyle(
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: screenWidth > 1200 ? 6 : 4),

              // Customer name
              Text(
                model.customerName,
                style: TextStyle(
                  fontSize: customerNameFontSize,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: orientation == Orientation.landscape ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: screenWidth > 1200 ? 10 : 8),

              // Divider
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.borderLight,
              ),

              SizedBox(height: screenWidth > 1200 ? 18 : 16),

              if (model.orderType == "branch") ...[
                Row(
                  spacing: 12,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/brunch.svg',
                      colorFilter: ColorFilter.mode(
                        Colors.grey[600]!,
                        BlendMode.srcIn,
                      ),
                      height: _getOrderNumberFontSize(context),
                    ),
                    Text(
                      "Picked from this branch",
                      style: TextStyle(
                        fontSize: orderTypeFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],

              if (model.orderType == "delivery") ...[
                Row(
                  spacing: 12,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      colorFilter: ColorFilter.mode(
                        Colors.grey[600]!,
                        BlendMode.srcIn,
                      ),
                      height: _getOrderNumberFontSize(context),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address:",
                          style: TextStyle(
                            fontSize: orderTypeFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${model.orderData.customerAddress}",
                          style: TextStyle(
                            fontSize: orderTypeFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],

              // Car details for curbside orders
              if (model.orderType == 'curbside') ...[
                Wrap(
                  spacing: screenWidth > 1200 ? 8 : 5,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Car logo
                    Image.asset(
                      'assets/icons/car-logo.png',
                      height: screenWidth > 1200 ? 20 : 16,
                    ),

                    // Plate number
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 1200 ? 10 : 8,
                        vertical: screenWidth > 1200 ? 8 : 6.3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        model.plateNumber,
                        style: TextStyle(
                          fontSize: timeFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Car details
                    if (model.carDetails.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth > 1200 ? 12 : 10,
                          vertical: screenWidth > 1200 ? 8 : 6.3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          model.carDetails.split('(')[0],
                          style: TextStyle(
                            fontSize: timeFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Car color
                    Container(
                      width: screenWidth > 1200 ? 32 : 29,
                      height: screenWidth > 1200 ? 32 : 29,
                      decoration: BoxDecoration(
                        color: getColorFromString(model.carColor),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(3.17),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
