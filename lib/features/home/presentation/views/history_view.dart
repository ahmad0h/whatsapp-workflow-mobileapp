import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/mapping.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/option_drawer.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_details_drawer.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedTab = 'Today';
  OrderCardModel? _selectedOrder;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    _loadOrdersForSelectedTab();
    context.read<HomeBloc>().add(HomeEvent.getBranchData());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // Responsive helper methods
  double _getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  bool _isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  bool _isLargeTablet(BuildContext context) => _getScreenWidth(context) > 1000;

  double _getHorizontalPadding(BuildContext context) {
    final width = _getScreenWidth(context);
    if (width > 1200) return 80.0;
    if (width > 900) return 60.0;
    return 40.0;
  }

  double _getChildAspectRatio(BuildContext context) {
    if (_isLandscape(context)) {
      return _isLargeTablet(context) ? 8 / 3 : 8 / 3.5;
    } else {
      return 8 / 4.6;
    }
  }

  double _getSearchWidth(BuildContext context) {
    final width = _getScreenWidth(context);
    if (_isLandscape(context)) {
      return width * 0.25;
    }
    return width * 0.35;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        selectedTab = 'Custom';
      });
      _loadOrdersForSelectedTab();
    }
  }

  void _loadOrdersForSelectedTab() {
    if (selectedTab == 'Today') {
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    context.read<HomeBloc>().add(
      HomeEvent.getOrdersDataByBranchIdAndDate(dateStr),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _getHorizontalPadding(context);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _selectedOrder != null
          ? OrderDetailsDrawer(order: _selectedOrder!)
          : OptionDrawer(),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.getOrdersListStatus == ResponseStatus.failure) {
            log(state.getOrdersListFailures?.message ?? '');
          }
        },
        builder: (context, state) {
          bool isDateMatch(String? dateString, DateTime targetDate) {
            if (dateString == null) return false;
            try {
              final date = DateTime.parse(dateString);
              final dateOnly = DateTime(date.year, date.month, date.day);
              final targetDateOnly = DateTime(
                targetDate.year,
                targetDate.month,
                targetDate.day,
              );
              return dateOnly.isAtSameMomentAs(targetDateOnly);
            } catch (e) {
              log('Error parsing date: $e');
              return false;
            }
          }

          var orders =
              state.ordersList?.map(mapOrderToCardModel).toList().where((e) {
                // Check if order matches the selected date
                bool matchesDate = isDateMatch(
                  e.orderData.orderDate,
                  _selectedDate!,
                );

                // If date doesn't match, check logs for any matching date
                if (!matchesDate &&
                    e.orderData.logs != null &&
                    e.orderData.logs!.isNotEmpty) {
                  for (var log in e.orderData.logs!) {
                    if (log.logTimestamp != null &&
                        isDateMatch(log.logTimestamp, _selectedDate!)) {
                      matchesDate = true;
                      break;
                    }
                  }
                }

                // Only include completed or rejected orders that match the date
                if (matchesDate) {
                  final status = e.status.trim().toLowerCase();
                  return status == 'completed' ||
                      status == 'rejected' ||
                      status == 'cancelled';
                }
                return false;
              }).toList() ??
              [];

          return CustomScrollView(
            slivers: [
              _buildResponsiveAppBar(context, horizontalPadding),
              _buildOrdersHeader(context, horizontalPadding),
              // Show loading indicator or orders grid based on loading state
              if (state.getOrdersListStatus == ResponseStatus.loading)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300, // Adjust height as needed
                    child: Center(
                      child: Lottie.asset('assets/loading.json', width: 150),
                    ),
                  ),
                )
              else
                _buildOrdersGrid(context, orders, horizontalPadding),
              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponsiveAppBar(
    BuildContext context,
    double horizontalPadding,
  ) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: false,
      pinned: true,
      toolbarHeight: kToolbarHeight,
      expandedHeight: _isLandscape(context) ? 70 : 80,
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
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image.asset(
                    'assets/ryze-logo.png',
                    height: _isLandscape(context) ? 30 : 35,
                  ),
                ),
                Flexible(flex: 2, child: _buildBranchInfo(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchInfo(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.getBranchesDataStatus == ResponseStatus.success) {}
        if (state.getBranchesDataStatus == ResponseStatus.failure) {}
      },
      builder: (context, state) {
        var branchData = state.getBranchesData;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/company-logo.png',
              height: _isLandscape(context) ? 25 : 30,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    branchData?.business?.businessName ?? '',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: _isLandscape(context) ? 11 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    branchData?.branchName ?? '',
                    style: TextStyle(
                      color: AppColors.backgroundLight,
                      fontSize: _isLandscape(context) ? 9 : 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Container(
              height: _isLandscape(context) ? 25 : 33,
              color: Colors.white,
              width: 1,
            ),
            SizedBox(width: 16),
            IconButton(
              icon: Icon(
                Icons.menu,
                color: AppColors.background,
                size: _isLandscape(context) ? 28 : 32,
              ),
              onPressed: () {
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
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersHeader(BuildContext context, double horizontalPadding) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: _isLandscape(context) ? 30 : 40,
        ),
        child: _isLandscape(context)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: _isLargeTablet(context) ? 28 : 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildSearchField(context),
                      _buildTab('Today'),
                      _buildTab('Custom'),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: _isLargeTablet(context) ? 36 : 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  _buildSearchField(context),
                  _buildTab('Today'),
                  _buildTab('Custom'),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: _isLandscape(context) ? 45 : 50,
      width: _getSearchWidth(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.15),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: _isLandscape(context) ? 10 : 12,
            horizontal: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Icon(
              Icons.search,
              color: AppColors.textHint,
              size: _isLandscape(context) ? 20 : 24,
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: _isLandscape(context) ? 35 : 40,
            minHeight: _isLandscape(context) ? 20 : 24,
          ),
          hintText: 'Search by Order Number',
          hintStyle: TextStyle(
            color: Color(0xFF9A9E99),
            fontSize: _isLandscape(context) ? 14 : 16,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          fontSize: _isLandscape(context) ? 14 : 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildOrdersGrid(
    BuildContext context,
    List<OrderCardModel> orders,
    double horizontalPadding,
  ) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: _isLandscape(context) ? 24 : 32,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, index) => _buildOrderCard(orders[index], context),
          childCount: orders.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: _isLargeTablet(context) ? 32 : 24,
          mainAxisSpacing: _isLargeTablet(context) ? 32 : 24,
          childAspectRatio: _getChildAspectRatio(context),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderCardModel model, BuildContext context) {
    final isSmallCard = _isLandscape(context) && !_isLargeTablet(context);

    return GestureDetector(
      onTap: () => _showOrderDetails(model),
      child: Container(
        padding: EdgeInsets.all(isSmallCard ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.66),
          border: Border(
            left: BorderSide(
              color: model.statusColor,
              width: isSmallCard ? 10 : 12,
            ),
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
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "#${model.orderNumber}",
                      style: TextStyle(
                        fontSize: isSmallCard ? 20 : 25.33,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallCard ? 8 : 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: model.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          model.status,
                          style: TextStyle(
                            color: model.statusColor,
                            fontSize: isSmallCard ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (model.status == "Completed") ...[
                          SizedBox(width: 4),
                          Icon(
                            Icons.check_circle_outline,
                            size: isSmallCard ? 12 : 14,
                            color: model.statusColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                model.time,
                style: TextStyle(
                  fontSize: isSmallCard ? 9 : 11.08,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                model.customerName,
                style: TextStyle(
                  fontSize: isSmallCard ? 18 : 24,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: isSmallCard ? 12 : 16),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFF2F2F2),
              ),
              SizedBox(height: isSmallCard ? 12 : 16),
              if (model.orderType == 'curbside')
                _buildCurbsideInfo(model, isSmallCard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurbsideInfo(OrderCardModel model, bool isSmallCard) {
    return Row(
      children: [
        Image.asset('assets/icons/car-logo.png', height: isSmallCard ? 16 : 20),
        SizedBox(width: isSmallCard ? 6 : 8),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallCard ? 6 : 8,
              vertical: isSmallCard ? 4 : 6.3,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF2F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              model.plateNumber,
              style: TextStyle(
                fontSize: isSmallCard ? 9 : 11.08,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(width: isSmallCard ? 4 : 8),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallCard ? 6 : 10,
              vertical: isSmallCard ? 4 : 6.3,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF2F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              model.carDetails.split('(')[0],
              style: TextStyle(
                fontSize: isSmallCard ? 9 : 11.08,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(width: isSmallCard ? 4 : 8),
        Container(
          width: isSmallCard ? 24 : 29,
          height: isSmallCard ? 24 : 29,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(3.17),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text) {
    bool isSelected = selectedTab == text;
    final isSmallTab = _isLandscape(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
        if (text == 'Custom') {
          _selectDate(context);
        } else {
          _loadOrdersForSelectedTab();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: isSmallTab ? 45 : 50,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallTab ? 12 : 15,
          vertical: 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.5),
          color: isSelected ? Colors.white : Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.black.withValues(alpha: 0.15)
                  : Colors.transparent,
              blurRadius: isSelected ? 2.5 : 0,
              offset: isSelected ? Offset(1, 3) : Offset.zero,
            ),
          ],
        ),
        margin: EdgeInsets.only(left: isSmallTab ? 12 : 16),
        child: text == 'Custom'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSelected
                        ? DateFormat('MMM d').format(_selectedDate!)
                        : 'Custom',
                    style: TextStyle(
                      fontSize: isSmallTab ? 14 : 17.5,
                      color: isSelected ? Colors.black : Color(0xFF09090B),
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 6),
                    Icon(
                      Icons.calendar_today,
                      size: isSmallTab ? 14 : 16,
                      color: Colors.black,
                    ),
                  ],
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: isSmallTab ? 14 : 17.5,
                  color: isSelected ? Colors.black : Color(0xFF09090B),
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
}
