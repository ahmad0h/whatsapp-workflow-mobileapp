import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/formant_status.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/format_time.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_current_status.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_status_color.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_details_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/option_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/reject_order_drawer.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  StreamSubscription<RemoteMessage>? _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeEvent.started());
    _setupNotificationListener();
  }

  @override
  void dispose() {
    _messageStreamSubscription?.cancel();
    super.dispose();
  }

  void _setupNotificationListener() {
    _messageStreamSubscription = FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Notification received: ${message.notification?.title}');
      debugPrint('Notification data: ${message.data}');

      if (message.notification?.title?.toLowerCase().contains('new order') ==
              true ||
          message.notification?.title?.toLowerCase().contains(
                'customer arrived',
              ) ==
              true ||
          message.notification?.title?.toLowerCase().contains('payment') ==
              true ||
          message.data['title']?.toLowerCase().contains('payment') == true) {
        debugPrint(
          'Refreshing orders list due to order/payment notification...',
        );

        if (mounted) {
          context.read<HomeBloc>().add(const HomeEvent.getOrdersData());
        }
      }
    });
  }

  bool isAcceptingOrders = true;
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

  // Function to get status color based on status string

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.backgroundLight,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.getOrdersListStatus == ResponseStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.getOrdersListFailures?.message ?? 'An error occurred',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.getOrdersListStatus == ResponseStatus.loading;
          final orders = !isLoading
              ? state.ordersList?.map(mapOrderToCardModel).toList() ?? []
              : [];
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      leading: const SizedBox.shrink(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: false,
                      pinned: true,
                      toolbarHeight: kToolbarHeight,
                      expandedHeight: 80,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/ryze-logo.png'),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/company-logo.png'),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Olive Garden',
                                          style: TextStyle(
                                            color: AppColors.background,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        Text(
                                          'Nasr Road Branch',
                                          style: TextStyle(
                                            color: AppColors.backgroundLight,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 24),
                                    Container(
                                      height: 33,
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    SizedBox(width: 24),
                                    IconButton(
                                      icon: Icon(
                                        Icons.menu,
                                        color: AppColors.background,
                                        size: 32,
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Status toggles section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 48, right: 48, top: 40),
                        child: Column(
                          children: [
                            _buildStatusToggle(
                              'OPEN',
                              'You are currently accepting all orders',
                              isAcceptingOrders,
                              AppColors.primary,
                              (value) =>
                                  setState(() => isAcceptingOrders = value),
                            ),
                            SizedBox(height: 12),
                            _buildStatusToggle(
                              '',
                              'Internet connection lost',
                              hasInternetConnection,
                              AppColors.warning.withValues(alpha: 0.1),
                              (value) =>
                                  setState(() => hasInternetConnection = value),
                              imagePath: 'assets/icons/wifi-off.png',
                            ),
                            SizedBox(height: 12),
                            _buildStatusToggle(
                              'Closed',
                              'You are currently not accepting any orders.',
                              !isAcceptingOrders,
                              AppColors.error,
                              null,
                              isInactive: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Stats cards section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 48, right: 48, top: 40),
                        child: Row(
                          children: [
                            _buildStatCard(
                              'Arrived Customers',
                              '5',
                              AppColors.statusArrived,
                              'assets/icons/car.svg',
                            ),
                            SizedBox(width: 12),
                            _buildStatCard(
                              'New Orders',
                              '324',
                              AppColors.primary,
                              'assets/icons/user.svg',
                            ),
                            SizedBox(width: 12),
                            _buildStatCard(
                              'Preparing',
                              '45',
                              AppColors.statusPreparing,
                              'assets/icons/pot.svg',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Orders header section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left: 48, right: 48, top: 40),

                        child: Row(
                          children: [
                            Text(
                              'Orders',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            _buildTab(
                              'All Orders',
                              isSelected: selectedTab == 'All Orders',
                              onTap: () =>
                                  setState(() => selectedTab = 'All Orders'),
                            ),
                            _buildTab(
                              'New Orders',
                              isSelected: selectedTab == 'New Orders',
                              onTap: () =>
                                  setState(() => selectedTab = 'New Orders'),
                            ),

                            _buildTab(
                              'In Progress',
                              isSelected: selectedTab == 'In Progress',
                              onTap: () =>
                                  setState(() => selectedTab = 'In Progress'),
                            ),
                            _buildTab(
                              'Arrived',
                              isSelected: selectedTab == 'Arrived',
                              onTap: () =>
                                  setState(() => selectedTab = 'Arrived'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: EdgeInsets.only(left: 48, right: 48, top: 32),
                      sliver: isLoading
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: CircularProgressIndicator(),
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
                                  orders as List<OrderCardModel>,
                                  selectedTab,
                                ).length,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 24,
                                    childAspectRatio:
                                        MediaQuery.of(context).orientation ==
                                            Orientation.portrait
                                        ? 8 / 4.3
                                        : 8 / 2.6,
                                  ),
                            ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 50)),
                  ],
                ),
              ),
              // Footer
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered By ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Image.asset('assets/footer-logo.png'),
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
  }) {
    return Container(
      padding: EdgeInsets.all(12.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE4E4E7)),
      ),
      child: Row(
        children: [
          if (label.isNotEmpty)
            Container(
              width: 67,
              height: 49,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (imagePath != null)
            Container(
              width: 67,
              height: 49,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF343330),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: GestureDetector(
              onTap: isInactive ? null : () => onChanged?.call(!value),
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
    );
  }

  Widget _buildStatCard(String title, String count, Color color, String icon) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
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
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(icon),
                  ],
                ),
                SizedBox(height: 18),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
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
              width: 59,
              height: 49,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
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
        margin: EdgeInsets.only(left: 16),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17.5,
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
    return GestureDetector(
      onTap: () => _showOrderDetails(model),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.66),
          border: Border(left: BorderSide(color: model.statusColor, width: 12)),
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
              Row(
                children: [
                  Text(
                    "#${model.orderNumber}",
                    style: TextStyle(
                      fontSize: 25.33,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: model.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          model.status,
                          style: TextStyle(
                            color: model.statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (model.status == "Preparing")
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              size: 14,
                              color: model.statusColor,
                            ),
                          )
                        else if (model.status == "Arrived")
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: model.statusColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                model.time,
                style: TextStyle(
                  fontSize: 11.08,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                model.customerName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.borderLight,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // Car logo
                  Center(child: Image.asset('assets/icons/car-logo.png')),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6.3),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      model.plateNumber,
                      style: TextStyle(
                        fontSize: 11.08,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6.3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      model.carDetails.split('(')[0],
                      style: TextStyle(
                        fontSize: 11.08,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 29,
                    height: 29,
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
          ),
        ),
      ),
    );
  }
}

OrderCardModel mapOrderToCardModel(OrderModel order) {
  final carColor = order.vehicle?.color?.toLowerCase() ?? 'grey';
  final time = order.orderDate != null ? formatTime(order.orderDate!) : '--:--';

  // Get the most up-to-date status from logs if available
  final currentStatus = getCurrentStatus(order);
  final formattedStatus = formatStatus(currentStatus);
  final statusColor = getStatusColor(currentStatus);

  final customerName = order.customer?.fullName ?? 'Unknown';
  final carBrand = order.vehicle?.brand ?? 'Unknown';
  final plateNumber = order.vehicle?.plateNumber ?? '--';
  final carDetails =
      '${order.vehicle?.brand ?? ''} ${order.vehicle?.model ?? ''} (${order.vehicle?.color ?? 'N/A'})';

  return OrderCardModel(
    orderNumber: order.orderNumber ?? '--',
    customerName: customerName,
    time: time,
    status: formattedStatus,
    statusColor: statusColor,
    carBrand: carBrand,
    plateNumber: plateNumber,
    carDetails: carDetails,
    carColor: carColor,
    orderData: order,
  );
}
