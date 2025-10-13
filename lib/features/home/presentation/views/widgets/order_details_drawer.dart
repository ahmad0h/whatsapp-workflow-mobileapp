import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_ui/flutter_neumorphic_ui.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:whatsapp_workflow_mobileapp/core/api/api_constants.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/format_time.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_color_from_string.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_tracking_widget.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/reject_order_drawer.dart';

class OrderDetailsDrawer extends StatefulWidget {
  final OrderCardModel order;
  final Function(OrderCardModel)? onOrderUpdated;
  final VoidCallback? onRejectPressed;

  const OrderDetailsDrawer({
    super.key,
    required this.order,
    this.onOrderUpdated,
    this.onRejectPressed,
  });

  @override
  State<OrderDetailsDrawer> createState() => _OrderDetailsDrawerState();
}

class _OrderDetailsDrawerState extends State<OrderDetailsDrawer> {
  bool _isOrderAccepted = false;

  // Parse ISO 8601 timestamp string to DateTime
  DateTime? _parseTimestamp(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return null;
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  // Get the most recent status from logs if available
  String _getCurrentStatus() {
    final order = widget.order.orderData;
    if (order.logs == null || order.logs!.isEmpty) {
      return order.status?.toLowerCase() ?? '';
    }

    // Create a copy of logs to avoid modifying the original list
    final logs = List<OrderLog>.from(order.logs!);

    if (logs.isEmpty) {
      return order.status?.toLowerCase() ?? '';
    }

    // Sort logs by timestamp in descending order to get the most recent first
    logs.sort((a, b) {
      final aTime = _parseTimestamp(a.logTimestamp) ?? DateTime(0);
      final bTime = _parseTimestamp(b.logTimestamp) ?? DateTime(0);
      return bTime.compareTo(aTime);
    });

    // Return the most recent log's status if available, otherwise fall back to order status
    final mostRecentStatus = logs.first.orderStatus?.toLowerCase();
    return mostRecentStatus ?? order.status?.toLowerCase() ?? '';
  }

  @override
  void initState() {
    super.initState();
    // Get the current status from logs
    final currentStatus = _getCurrentStatus();

    // If order status is 'in_progress', 'in progress', 'arrived', or 'completed', mark as accepted
    _isOrderAccepted =
        currentStatus == 'in_progress' ||
        currentStatus == 'in progress' ||
        currentStatus == 'arrived' ||
        currentStatus == 'completed';
  }

  // Colors
  static const _backgroundColor = AppColors.background;
  static const _primaryColor = AppColors.primary;
  static const _dividerColor = AppColors.borderLight;

  // Get status color based on status string
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.primary;
      case 'in_progress':
        return AppColors.statusPreparing;
      case 'arrived':
        return AppColors.statusArrived;
      case 'completed':
        return AppColors.statusCompleted;
      case 'cancelled':
      case 'rejected':
        return AppColors.statusRejected;
      default:
        return AppColors.textSecondary;
    }
  }

  // Dimensions
  static const _cardHeight = 80.0;
  static const _cardBorderRadius = 3.17;
  static const _sectionSpacing = 25.0;
  static const _buttonBorderRadius = 25.0;

  // Text Styles
  static final TextStyle _buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _backgroundColor,
  );

  void _showRejectOrderDrawer() {
    if (widget.onRejectPressed != null) {
      widget.onRejectPressed!();
    } else {
      // Fallback to the old dialog implementation if onRejectPressed is not provided
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height,
                child: RejectOrderDrawer(
                  orderNumber: widget.order.orderNumber,
                  orderId: widget.order.orderData.id ?? '',
                  onOrderRejected: () {
                    // Refresh the orders list after rejection
                    final homeBloc = context.read<HomeBloc>();
                    homeBloc.add(const HomeEvent.getOrdersData());

                    // Notify parent widget if callback is provided
                    if (widget.onOrderUpdated != null) {
                      // Create updated order model with rejected status
                      final rejectedOrder = OrderCardModel(
                        orderNumber: widget.order.orderNumber,
                        customerName: widget.order.customerName,
                        time: widget.order.time,
                        status: 'Rejected',
                        statusColor: AppColors.statusRejected,
                        carBrand: widget.order.carBrand,
                        carColor: widget.order.carColor,
                        plateNumber: widget.order.plateNumber,
                        carDetails: widget.order.carDetails,
                        orderData: widget.order.orderData,
                        orderType: widget.order.orderType,
                        customerAddress: widget.order.customerAddress,
                      );
                      widget.onOrderUpdated!(rejectedOrder);
                    }
                  },
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: child,
          );
        },
      );
    }
  }

  Future<void> _handleCompleteOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.order.orderData.id ?? '';

    try {
      // Update the order status to completed
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'completed'));

      // Wait for the status update to complete
      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Then refresh the orders list to get the latest data
      homeBloc.add(const HomeEvent.getOrdersData());
      await homeBloc.stream
          .where((state) => state.getOrdersListStatus != ResponseStatus.loading)
          .first;

      homeBloc.add(const HomeEvent.getOrderStats());
      await homeBloc.stream
          .where((state) => state.getOrderStatsStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Find the updated order in the state
      final updatedOrder = homeBloc.state.ordersList?.firstWhere(
        (order) => order.id == orderId,
        orElse: () => widget.order.orderData,
      );

      // Update the local order data with the latest from the server
      if (updatedOrder != null) {
        final updatedCardModel = OrderCardModel(
          orderNumber: updatedOrder.orderNumber ?? widget.order.orderNumber,
          customerName:
              updatedOrder.customer?.fullName ?? widget.order.customerName,
          time: updatedOrder.orderDate != null
              ? formatTime(updatedOrder.orderDate!)
              : widget.order.time,
          status: 'Completed',
          statusColor: _getStatusColor('completed'),
          carBrand: updatedOrder.vehicle?.brand ?? widget.order.carBrand,
          carColor: updatedOrder.vehicle?.color?.toLowerCase() ?? 'grey',
          plateNumber:
              updatedOrder.vehicle?.plateNumber ?? widget.order.plateNumber,
          carDetails:
              '${updatedOrder.vehicle?.brand ?? ''} ${updatedOrder.vehicle?.model ?? ''} (${updatedOrder.vehicle?.color ?? 'N/A'})',
          orderData: updatedOrder,
          orderType: updatedOrder.type ?? '',
          customerAddress: updatedOrder.customerAddress ?? '',
        );

        // Update the widget's order reference
        if (mounted) {
          setState(() {
            widget.order.status = 'Completed';
            // Notify parent widget about the update
            if (widget.onOrderUpdated != null) {
              widget.onOrderUpdated!(updatedCardModel);
            }
          });
        }
      }

      if (!mounted) return;

      // Show success message
      log('Order marked as completed successfully');

      // Close the drawer after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          GoRouter.of(context).pop();
        }
      });
    } catch (e) {
      log('Failed to update order status to completed: $e');
    }
  }

  Future<void> _handleFinishOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.order.orderData.id ?? '';

    try {
      // Send the status update to the server
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'is_finished'));

      // Wait for the status update to complete
      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Refresh the orders list to get the latest data
      homeBloc.add(const HomeEvent.getOrdersData());
      await homeBloc.stream
          .where((state) => state.getOrdersListStatus != ResponseStatus.loading)
          .first;

      homeBloc.add(const HomeEvent.getOrderStats());
      await homeBloc.stream
          .where((state) => state.getOrderStatsStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Find the updated order in the state
      final updatedOrder = homeBloc.state.ordersList?.firstWhere(
        (order) => order.id == orderId,
        orElse: () => widget.order.orderData,
      );

      // Create an updated order card model with the new status
      if (updatedOrder != null) {
        final updatedCardModel = OrderCardModel(
          orderNumber: updatedOrder.orderNumber ?? widget.order.orderNumber,
          customerName:
              updatedOrder.customer?.fullName ?? widget.order.customerName,
          time: updatedOrder.orderDate != null
              ? formatTime(updatedOrder.orderDate!)
              : widget.order.time,
          status: 'Finished',
          statusColor: _getStatusColor('is_finished'),
          carBrand: updatedOrder.vehicle?.brand ?? widget.order.carBrand,
          carColor: updatedOrder.vehicle?.color?.toLowerCase() ?? 'grey',
          plateNumber:
              updatedOrder.vehicle?.plateNumber ?? widget.order.plateNumber,
          carDetails:
              '${updatedOrder.vehicle?.brand ?? ''} ${updatedOrder.vehicle?.model ?? ''} (${updatedOrder.vehicle?.color ?? 'N/A'})',
          orderData: updatedOrder,
          orderType: updatedOrder.type ?? '',
          customerAddress: updatedOrder.customerAddress ?? '',
        );

        // Notify parent widget about the update
        if (mounted && widget.onOrderUpdated != null) {
          widget.onOrderUpdated!(updatedCardModel);
        }
      }

      // Show success message
      log('Order marked as finished successfully');

      // Close the drawer
      if (mounted) {
        GoRouter.of(context).pop();
      }
    } catch (e) {
      log('Failed to update order status to finished: $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Text('Failed to finish order: $e')));
      // }
    }
  }

  Future<void> _handleAcceptOrder() async {
    if (!mounted) return;

    final homeBloc = context.read<HomeBloc>();
    final orderId = widget.order.orderData.id ?? '';

    setState(() {
      _isOrderAccepted = true;
      widget.order.status = 'In Progress';
    });

    try {
      // First update the order status
      homeBloc.add(HomeEvent.updateOrderStatus(orderId, 'in_progress'));

      // Wait for the status update to complete
      await homeBloc.stream
          .where((state) => state.updateOrderStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Then refresh the orders list to get the latest data including updatedAt
      homeBloc.add(const HomeEvent.getOrdersData());
      await homeBloc.stream
          .where((state) => state.getOrdersListStatus != ResponseStatus.loading)
          .first;

      homeBloc.add(const HomeEvent.getOrderStats());
      await homeBloc.stream
          .where((state) => state.getOrderStatsStatus != ResponseStatus.loading)
          .first;

      if (!mounted) return;

      // Find the updated order in the state
      final updatedOrder = homeBloc.state.ordersList?.firstWhere(
        (order) => order.id == orderId,
        orElse: () =>
            widget.order.orderData, // Fallback to current order if not found
      );

      // Update the local order data with the latest from the server
      if (updatedOrder != null) {
        // Create a new OrderCardModel with updated values
        final status = updatedOrder.status ?? 'in_progress';
        final statusText = status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (s) => s.isNotEmpty
                  ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
                  : '',
            )
            .join(' ');

        final updatedCardModel = OrderCardModel(
          orderNumber: updatedOrder.orderNumber ?? widget.order.orderNumber,
          customerName:
              updatedOrder.customer?.fullName ?? widget.order.customerName,
          time: updatedOrder.orderDate != null
              ? formatTime(updatedOrder.orderDate!)
              : widget.order.time,
          status: statusText,
          statusColor: _getStatusColor(status),
          carBrand: updatedOrder.vehicle?.brand ?? widget.order.carBrand,
          carColor: updatedOrder.vehicle?.color?.toLowerCase() ?? 'grey',
          plateNumber:
              updatedOrder.vehicle?.plateNumber ?? widget.order.plateNumber,
          carDetails:
              '${updatedOrder.vehicle?.brand ?? ''} ${updatedOrder.vehicle?.model ?? ''} (${updatedOrder.vehicle?.color ?? 'N/A'})',
          orderData: updatedOrder,
          orderType: updatedOrder.type ?? '',
          customerAddress: updatedOrder.customerAddress ?? '',
        );

        // Update the widget's order reference
        if (mounted) {
          setState(() {
            _isOrderAccepted = true;
            // Update the order reference to trigger UI refresh
            widget.order.status = updatedCardModel.status;
            // Notify parent widget about the update
            if (widget.onOrderUpdated != null) {
              widget.onOrderUpdated!(updatedCardModel);
            }
          });
          GoRouter.of(context).pop();
        }
      }

      if (!mounted) return;

      // Show success message
      log('Order updated successfully');

      // Notify parent widget to refresh if needed
      if (widget.onOrderUpdated != null) {
        widget.onOrderUpdated!(widget.order);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isOrderAccepted = false;
        widget.order.status = 'Pending';
      });

      log('Failed to update order status: $e');
    }
  }

  // Convert color name to Color object
  Color _getColorFromName(String colorName) {
    // Convert to lowercase for case-insensitive comparison
    final name = colorName.toLowerCase().trim();

    // Map of common color names to their Color values
    final colorMap = {
      'red': Colors.red,
      'green': Colors.green,
      'blue': Colors.blue,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'black': Colors.black,
      'white': Colors.white,
      'teal': Colors.teal,
      'cyan': Colors.cyan,
      'indigo': Colors.indigo,
      'amber': Colors.amber,
      'silver': Colors.grey,
    };

    // Try to find the color in the map, default to green if not found
    return colorMap[name] ?? AppColors.success;
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    bool isCarColor = false,
  }) {
    // Get the car color if this is the car color card
    final borderColor = _getColorFromName(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: _cardHeight,
      decoration: BoxDecoration(
        color: Color(0xFFF2F5F9),
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        border: isCarColor
            ? Border(right: BorderSide(color: borderColor, width: 25))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF3E4069),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3E4069),
                ),
              ),
            ],
          ),
          OrderTypeBadge(model: widget.order, color: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = _getCurrentStatus().toLowerCase();
    final isRejected =
        currentStatus == 'rejected' || currentStatus == 'cancelled';

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: _backgroundColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: _getBottomPadding(currentStatus, isRejected),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildOrderHeader(),
                  const SizedBox(height: 20),
                  _buildInfoCard(title: 'Order Time', value: widget.order.time),
                  if (widget.order.orderType == "curbside") ...[
                    ...buildCurbsideInfo(),
                  ],
                  const SizedBox(height: 25),
                  _buildDivider(),
                  const SizedBox(height: 25),
                  _buildOrderDetailsSection(),
                  const SizedBox(height: _sectionSpacing),
                  _buildTotalAmount(),
                  const SizedBox(height: _sectionSpacing),
                  _buildDivider(),
                  const SizedBox(height: _sectionSpacing),
                  if (_isOrderAccepted && !isRejected) ...[
                    const SizedBox(height: 20),
                    OrderTrackingTimeline(
                      logs: widget.order.orderData.logs,
                      currentStatus: widget.order.status.toLowerCase(),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // Buttons positioned at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 26,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAcceptButton(context),
                    if (!_isOrderAccepted &&
                        !isRejected &&
                        currentStatus != 'is_finished') ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            depth: 50,
                            surfaceIntensity: 50,
                            lightSource: LightSource(0, 0),
                            oppositeShadowLightSource: false,
                            color: const Color.fromARGB(255, 240, 238, 238),
                            border: NeumorphicBorder(
                              color: Colors.black.withValues(alpha: 0.07),
                            ),
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(50),
                            ),
                          ),
                          child: SlideAction(
                            text: 'Reject Order',
                            textColor: AppColors.error,
                            sliderButtonIcon: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.error,
                              size: 15,
                            ),
                            submittedIcon: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.check,
                                color: AppColors.success,
                                size: 15,
                              ),
                            ),
                            elevation: 0.0,
                            onSubmit: () {
                              _showRejectOrderDrawer();
                              return null;
                            },
                            sliderButtonYOffset: -8,
                            innerColor: const Color(0xFFFFFFFF),
                            outerColor: Colors.transparent,
                            borderRadius: 50,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate bottom padding based on button visibility
  double _getBottomPadding(String currentStatus, bool isRejected) {
    if (!_isOrderAccepted && !isRejected && currentStatus != 'is_finished') {
      // Accept button + Reject button + padding
      return 180;
    } else if (_isOrderAccepted ||
        isRejected ||
        currentStatus == 'is_finished') {
      // Just the accept/status button(s) + padding
      final isArrived = currentStatus == 'arrived';
      final showFinishButton =
          currentStatus == 'in_progress' ||
          currentStatus == 'in progress' ||
          currentStatus == 'is_finished' ||
          currentStatus == 'completed' ||
          currentStatus == 'arrived';

      if (isArrived) {
        // All three buttons visible
        return 220;
      } else if (showFinishButton) {
        // Two buttons visible
        return 160;
      } else {
        // One button visible
        return 100;
      }
    }
    return 100;
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),

      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                size: 24,
                color: Color(0xFF3E4069),
                weight: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    // final currentStatus = _getCurrentStatus().toLowerCase();
    // final isRejected =
    //     currentStatus == 'rejected' || currentStatus == 'cancelled';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (_isOrderAccepted || isRejected)
        //   Container(
        //     width: double.infinity,
        //     alignment: Alignment.center,
        //     height: 48,
        //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: isRejected
        //           ? AppColors
        //                 .error // Red for Rejected/Cancelled
        //           : widget.order.status == 'In Progress'
        //           ? const Color(0xFFEEB128).withValues(
        //               alpha: 0.1,
        //             ) // Yellow for In Progress
        //           : const Color(
        //               0xFF27AE60,
        //             ).withValues(alpha: 0.1), // Green for other statuses
        //       borderRadius: BorderRadius.circular(25),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           isRejected ? 'Rejected' : _getStatusDisplayText(),
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w700,
        //             color: widget.order.statusColor,
        //           ),
        //         ),
        //         if (widget.order.status != 'Arrived' &&
        //             widget.order.status != 'Completed' &&
        //             !isRejected)
        //           Image.asset(
        //             'assets/icons/spinner.png',
        //             width: 24,
        //             height: 24,
        //           ),
        //       ],
        //     ),
        //   ),
        // const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${widget.order.orderNumber}',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3E4069),
                  ),
                ),
                Text(
                  widget.order.customerName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E4069),
                  ),
                ),
              ],
            ),
            OrderCard(model: widget.order).statusBadge(),
          ],
        ),
      ],
    );
  }

  // Widget _buildOrderInfoGrid() {
  //   return Column(
  //     children: [
  //       // First row
  //       SizedBox(
  //         height: _cardHeight,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Expanded(
  //               child: _buildInfoCard(
  //                 title: 'Order Time',
  //                 value: widget.order.time,
  //               ),
  //             ),
  //             const SizedBox(width: _elementSpacing),
  //             Expanded(
  //               child: _buildInfoCard(
  //                 title: 'Plate No.',
  //                 value: widget.order.plateNumber,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: _elementSpacing),
  //       // Second row
  //       SizedBox(
  //         height: _cardHeight,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Expanded(
  //               child: _buildInfoCard(
  //                 title: 'Car Details',
  //                 value: widget.order.carDetails.split('(')[0],
  //               ),
  //             ),
  //             const SizedBox(width: _elementSpacing),
  //             Expanded(
  //               child: _buildInfoCard(
  //                 title: 'Car Color',
  //                 value:
  //                     widget.order.orderData.vehicle?.color?.isNotEmpty == true
  //                     ? widget.order.orderData.vehicle!.color!
  //                     : 'N/A',
  //                 isCarColor: true,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildNewInfoCard() {
  //   return Row(
  //     children: [
  //       Column(
  //         children: [
  //           // First row
  //           SizedBox(
  //             height: _cardHeight,
  //             child: _buildInfoCard(
  //               title: 'Order Time',
  //               value: widget.order.time,
  //             ),
  //           ),
  //           const SizedBox(height: _elementSpacing),
  //           // Second row
  //           SizedBox(
  //             height: _cardHeight,
  //             child: _buildInfoCard(
  //               title: widget.order.orderType == 'branch'
  //                   ? 'Branch'
  //                   : 'Address',
  //               value: widget.order.orderType == 'branch'
  //                   ? 'Picked up from this branch.'
  //                   : widget.order.customerAddress,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildOrderDetailsSection() {
    final orderDetails = widget.order.orderData.orderDetails ?? [];

    if (orderDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF3E4069),
          ),
        ),
        const SizedBox(height: _sectionSpacing),
        ...orderDetails.expand<Widget>((detail) {
            final price = double.tryParse(detail.productPrice ?? '0') ?? 0;
            final quantity = detail.productQuantity ?? 0;
            final total = price * quantity;

            return [
              _buildOrderItem(
                detail.productName ?? 'Unknown Item',
                quantity,
                total,
              ),
              _buildDivider(),
              const SizedBox(height: 16),
            ];
          }).toList()
          ..removeLast()
          ..removeLast(),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 0.7, width: double.infinity, color: _dividerColor);
  }

  // Helper method to get the correct status text for display
  // String _getStatusDisplayText() {
  //   // First try to get status from logs
  //   final currentStatus = _getCurrentStatus().toLowerCase();

  //   if (currentStatus.contains('new') || currentStatus == 'active') {
  //     return 'New Order';
  //   } else if (currentStatus.contains('progress') ||
  //       currentStatus == 'in_progress') {
  //     return 'In Progress';
  //   } else if (currentStatus.contains('is_finished') ||
  //       currentStatus == 'is_finished') {
  //     return 'Finished';
  //   } else if (currentStatus == 'arrived') {
  //     return 'Arrived';
  //   } else if (currentStatus == 'completed') {
  //     return 'Completed';
  //   }

  //   // Fallback to order status if no match found in logs
  //   final orderStatus = widget.order.status.toLowerCase();
  //   if (orderStatus.contains('new') || orderStatus == 'active') {
  //     return 'New Order';
  //   } else if (orderStatus.contains('progress') ||
  //       orderStatus == 'in_progress') {
  //     return 'In Progress';
  //   } else if (orderStatus.contains('is_finished') ||
  //       orderStatus == 'is_finished') {
  //     return 'Finished';
  //   } else if (orderStatus == 'arrived') {
  //     return 'Arrived';
  //   } else if (orderStatus == 'completed') {
  //     return 'Completed';
  //   }

  //   // Default to the raw status if no match is found
  //   return widget.order.status;
  // }

  List<Widget> buildCurbsideInfo() {
    final double fixedHeight = 35;

    return [
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: fixedHeight,
          child: Row(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CachedNetworkImage(
                imageUrl: widget.order.orderData.vehicle?.image != null
                    ? ApiConstants.getCarLogoUrl(
                        widget.order.orderData.vehicle!.image!,
                      )
                    : '',
                width: 60,
                height: fixedHeight,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: Colors.red),
              ),
              // Plate number
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      widget.order.orderData.vehicle?.plateNumber ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E4069),
                      ),
                    ),
                  ),
                ),
              ),

              // Car details
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _getCarDetailsText(
                        widget.order.orderData.vehicle?.type ?? '',
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E4069),
                      ),
                    ),
                  ),
                ),
              ),

              // Color indicator
              Container(
                width: 60,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: getColorFromString(
                    widget.order.orderData.vehicle?.color ?? '',
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  String _getCarDetailsText(String carDetails) {
    final maxLength = 10;
    final cleanText = carDetails.split('(')[0].trim();

    if (cleanText.length > maxLength) {
      return '${cleanText.substring(0, maxLength)}...';
    }
    return cleanText;
  }

  Widget _buildTotalAmount() {
    final vatAmount = widget.order.orderData.vatAmount ?? '0';
    final netAmount = widget.order.orderData.netAmount ?? '0';
    final deliveryFee = 22;
    final subtotal = widget.order.orderType == 'delivery'
        ? double.parse(netAmount) - double.parse(vatAmount) - deliveryFee
        : double.parse(netAmount) - double.parse(vatAmount);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: Color(0xFFF2F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3E4069),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/riyal.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtotal.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3E4069),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (double.parse(widget.order.orderData.vatAmount ?? '0') > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VAT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3E4069),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/riyal.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.order.orderData.vatAmount ?? '0',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF3E4069),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.order.orderType == 'delivery')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Fee',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3E4069),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/riyal.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deliveryFee.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF3E4069),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
          const Divider(height: 24, thickness: 2, color: _dividerColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3E4069),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/riyal.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.order.orderData.netAmount ?? '0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E4069),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    final currentStatus = _getCurrentStatus().toLowerCase();
    final isArrived = currentStatus == 'arrived';
    final isCompleted = currentStatus == 'completed';
    final isRejected =
        currentStatus == 'rejected' || currentStatus == 'cancelled';

    // Safely get the finished log if it exists
    final logs = widget.order.orderData.logs ?? [];
    OrderLog? finishedLog;
    String? finishedTime;

    try {
      finishedLog = logs.firstWhere(
        (log) => log.orderStatus?.toLowerCase() == 'is_finished',
      );
      finishedTime = finishedLog.logTimestamp;
    } catch (e) {
      // No finished log found, which is fine
    }

    if (isRejected) {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: null, // Disable the button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonBorderRadius),
            ),
            elevation: 0,
          ),
          child: Text(
            'Order Rejected',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (_isOrderAccepted ||
        currentStatus == 'preparing' ||
        currentStatus == 'in progress' ||
        currentStatus == 'in_progress' ||
        isArrived ||
        currentStatus == 'is_finished' ||
        isCompleted) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF2F5F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_buttonBorderRadius),
                ),
                elevation: 0,
              ),
              child: Text(
                _getAcceptanceStatusText().split('-').join('\n'),
                style: TextStyle(fontSize: 20, color: Color(0xFF3E4069)),
              ),
            ),
          ),
          if (currentStatus == 'in_progress' ||
              currentStatus == 'in progress' ||
              currentStatus == 'is_finished' ||
              currentStatus == 'completed' ||
              currentStatus == 'arrived') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed:
                    (currentStatus == 'is_finished' ||
                        currentStatus == 'completed' ||
                        currentStatus == 'arrived')
                    ? null
                    : _handleFinishOrder,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  backgroundColor:
                      (currentStatus == 'is_finished' ||
                          currentStatus == 'completed' ||
                          currentStatus == 'arrived')
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  currentStatus == 'is_finished' ||
                          currentStatus == 'completed' ||
                          currentStatus == 'arrived'
                      ? 'Order Marked as Finished${finishedTime != null ? ' at ${formatTime(finishedTime)}' : ''}'
                      : 'Order is ready?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        currentStatus == 'is_finished' ||
                            currentStatus == 'completed' ||
                            currentStatus == 'arrived'
                        ? Colors.black54
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
          if (isArrived) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleCompleteOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statusCompleted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_buttonBorderRadius),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Mark as Completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleAcceptOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonBorderRadius),
          ),
          elevation: 0,
        ),
        child: Text('Accept', style: _buttonTextStyle),
      ),
    );
  }

  String _formatTimeOnly(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : dateTime.hour == 0
          ? 12
          : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';

      return '${hour.toString().padLeft(2, '0')}:$minute $period';
    } catch (e) {
      return '--:-- --';
    }
  }

  String _getAcceptanceStatusText() {
    final logs = widget.order.orderData.logs;
    if (logs == null || logs.isEmpty) {
      return 'Accepted at (${_formatTimeOnly(DateTime.now().toIso8601String())})';
    }

    // Find the in_progress log
    final inProgressLog = logs.firstWhere(
      (log) => log.orderStatus?.toLowerCase() == 'in_progress',
      orElse: () => logs.first,
    );

    return 'Accepted at (${_formatTimeOnly(inProgressLog.logTimestamp ?? DateTime.now().toIso8601String())})';
  }

  Widget _buildOrderItem(String itemName, int quantity, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            itemName,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF3E4069),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '$quantity x',
          style: TextStyle(fontSize: 18, color: Color(0xFF3E4069)),
        ),
        const SizedBox(width: 8),
        Text(
          '${price.toStringAsFixed(2)} SAR',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF3E4069),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
