import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/home_view.dart';
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
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
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
        selectedTab = 'Custom'; // Set the selected tab to Custom
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

    // Force a rebuild to update the UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (state.getOrdersListStatus == ResponseStatus.loading) {
            return Center(
              child: Lottie.asset('assets/loading.json', width: 150),
            );
          }

          bool isDateMatch(String? dateString, DateTime targetDate) {
            if (dateString == null) return false;
            try {
              // Parse the date string and create a DateTime object with just the date part
              final date = DateTime.parse(dateString);
              final dateOnly = DateTime(date.year, date.month, date.day);
              final targetDateOnly = DateTime(
                targetDate.year,
                targetDate.month,
                targetDate.day,
              );

              // Compare just the date parts
              return dateOnly.isAtSameMomentAs(targetDateOnly);
            } catch (e) {
              log('Error parsing date: $e');
              return false;
            }
          }

          // Show all orders that match the selected date
          var orders =
              state.ordersList?.map(mapOrderToCardModel).toList().where((e) {
                // First check the order date
                if (isDateMatch(e.orderData.orderDate, _selectedDate!)) {
                  return true;
                }

                // If no date match, check logs for any timestamp
                if (e.orderData.logs != null && e.orderData.logs!.isNotEmpty) {
                  // Check all logs for a matching timestamp
                  for (var log in e.orderData.logs!) {
                    if (log.logTimestamp != null &&
                        isDateMatch(log.logTimestamp, _selectedDate!)) {
                      return true;
                    }
                  }
                }

                return false;
              }).toList() ??
              [];

          return CustomScrollView(
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
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                color: AppColors.background,
                                width: 1,
                              ),
                              SizedBox(width: 24),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  if (_selectedOrder == null) {
                                    _scaffoldKey.currentState?.openEndDrawer();
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
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Icon(
                                Icons.search,
                                color: AppColors.textHint,
                                size: 24,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                              minHeight: 24,
                            ),
                            hintText: 'Search by Order Number',
                            hintStyle: TextStyle(
                              color: Color(0xFF9A9E99),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      _buildTab('Today'),
                      _buildTab('Custom'),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.only(left: 48, right: 48, top: 32),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((_, index) {
                    return _buildOrderCard(orders[index]);
                  }, childCount: orders.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio:
                        MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 8 / 5
                        : 8 / 3,
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
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

                        if (model.status == "Completed")
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
                style: TextStyle(fontSize: 11.08, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                model.customerName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFF2F2F2),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  // Car logo
                  Center(child: Image.asset('assets/icons/car-logo.png')),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6.3),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F5F9),
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
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6.3,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F5F9),
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
                  SizedBox(width: 8),
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: Colors.green,
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

  Widget _buildTab(String text) {
    bool isSelected = selectedTab == text;
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
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
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
        margin: EdgeInsets.only(left: 16),
        child: text == 'Custom'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSelected
                        ? DateFormat('MMM d').format(_selectedDate!)
                        : 'Custom',
                    style: TextStyle(
                      fontSize: 17.5,
                      color: isSelected ? Colors.black : Color(0xFF09090B),
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 8),
                    Icon(Icons.calendar_today, size: 16, color: Colors.black),
                  ],
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 17.5,
                  color: isSelected ? Colors.black : Color(0xFF09090B),
                ),
              ),
      ),
    );
  }

  void _showOrderDetails(OrderCardModel model) {
    // Close any open drawers first
    if (_scaffoldKey.currentState!.isEndDrawerOpen) {
      Navigator.of(context).pop();
    }

    setState(() {
      _selectedOrder = model;
    });

    // Small delay to ensure drawer is properly closed before opening the new one
    Future.delayed(Duration(milliseconds: 100), () {
      _scaffoldKey.currentState?.openEndDrawer();
    });
  }
}
