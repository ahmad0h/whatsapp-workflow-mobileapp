import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/enums/response_status_enum.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/bloc/home_bloc.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';

class RejectOrderDrawer extends StatefulWidget {
  final String orderNumber;
  final String orderId;
  final OrderCardModel? order;
  final Function(OrderCardModel)? onOrderUpdated;
  final VoidCallback? onOrderRejected;

  const RejectOrderDrawer({
    super.key,
    required this.orderNumber,
    required this.orderId,
    this.order,
    this.onOrderUpdated,
    this.onOrderRejected,
  });

  @override
  State<RejectOrderDrawer> createState() => _RejectOrderDrawerState();
}

class _RejectOrderDrawerState extends State<RejectOrderDrawer> {
  String? selectedReason;
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  final List<String> rejectionReasons = [
    'reject.branchClosed'.tr(),
    'reject.wrongAddress'.tr(),
    'reject.customerCancelled'.tr(),
    'reject.paymentIssue'.tr(),
    'reject.maintenancePeriod'.tr(),
    'reject.other'.tr(),
  ];

  // Colors matching OrderDetailsDrawer
  static const _backgroundColor = AppColors.background;
  static const _textColor = AppColors.textPrimary;
  static const _secondaryTextColor = AppColors.textSecondary;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleRejectOrder() async {
    if (selectedReason == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('reject.pleaseSelectReason'.tr()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }
      return;
    }

    // Combine selected reason and written note
    String finalReason = selectedReason!;
    String writtenNote = _reasonController.text.trim();

    // If 'Other' is selected, use the custom note if provided
    if (selectedReason == 'reject.other'.tr()) {
      if (writtenNote.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('reject.pleaseProvideReason'.tr()),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );
        }
        return;
      }
      finalReason = writtenNote;
    } else if (writtenNote.isNotEmpty) {
      // For other reasons, append the note if provided
      finalReason = '${selectedReason!} - $writtenNote';
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final homeBloc = context.read<HomeBloc>();

      // Dispatch the reject order event
      homeBloc.add(
        HomeEvent.rejectOrder(orderId: widget.orderId, reason: finalReason),
      );

      // Wait for the reject order to complete
      await homeBloc.stream
          .where((state) => state.rejectOrderStatus != ResponseStatus.loading)
          .firstWhere(
            (state) =>
                state.rejectOrderStatus == ResponseStatus.success ||
                state.rejectOrderStatus == ResponseStatus.failure,
          );

      if (!mounted) return;

      // Check the final state
      final currentState = homeBloc.state;

      if (currentState.rejectOrderStatus == ResponseStatus.success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('reject.orderRejectedSuccessfully'.tr()),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );

          // Create the updated order model
          final rejectedOrder = widget.order?.copyWith(
            status: 'Rejected',
            statusColor: AppColors.statusRejected,
          );

          // Notify parent widget about the update
          if (widget.onOrderUpdated != null && rejectedOrder != null) {
            widget.onOrderUpdated!(rejectedOrder);
          }

          // Close the drawer
          if (mounted) {
            // First refresh the orders list
            homeBloc.add(const HomeEvent.getOrdersData());

            // Then close the drawer
            if (widget.onOrderRejected != null) {
              widget.onOrderRejected!();
            } else if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                currentState.rejectOrderFailures?.message ??
                    'reject.failedToReject'.tr(),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('reject.errorOccurred'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: _backgroundColor,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: 100, // Add bottom padding for button space
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 16),
                    _buildOrderHeader(),
                    SizedBox(height: 32),
                    _buildRejectionReasonSection(),
                    SizedBox(height: 24),
                    _buildCustomReasonSection(),
                  ],
                ),
              ),
            ),
            // Send button positioned at the bottom
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
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 45,
                  top: 24,
                ),
                child: _buildSendButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _secondaryTextColor.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: _textColor,
            ),
          ),
        ),
        // Text(
        //   'reject.rejectOrderTitle'.tr(),
        //   style: TextStyle(
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold,
        //     color: _textColor,
        //   ),
        // ),
        SizedBox(width: 40), // For balance
      ],
    );
  }

  Widget _buildOrderHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#${widget.orderNumber}',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),

        Text(
          'reject.rejectOrder'.tr(),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildRejectionReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reject.rejectionReason'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedReason,
              hint: Text(
                'reject.selectReason'.tr(),
                style: TextStyle(color: _secondaryTextColor, fontSize: 16),
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: _secondaryTextColor),
              items: rejectionReasons.map((String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(
                    reason,
                    style: TextStyle(fontSize: 16, color: _textColor),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedReason = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reject.reason'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: TextField(
            controller: _reasonController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: 'reject.writeTheReason'.tr(),
              hintStyle: TextStyle(color: _secondaryTextColor, fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(fontSize: 16, color: _textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRejectOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: Lottie.asset('assets/loading.json', width: 24),
              )
            : Text(
                'reject.send'.tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
