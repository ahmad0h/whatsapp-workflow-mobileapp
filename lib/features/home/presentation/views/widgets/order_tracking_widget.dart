import 'package:flutter/material.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/format_time.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final List<OrderLog>? logs;
  final String currentStatus;

  const OrderTrackingTimeline({
    super.key,
    required this.logs,
    this.currentStatus = '',
  });

  String _getStatusTitle(String status) {
    final normalizedStatus = status.toLowerCase();

    switch (normalizedStatus) {
      case 'new order':
      case 'active':
        return 'New Order';
      case 'in_progress':
      case 'in progress':
        return 'In Progress';
      case 'arrived':
        return 'Arrived';
      case 'completed':
        return 'Completed';
      default:
        // Handle any other status formats
        return status
            .split('_')
            .map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '')
            .join(' ')
            .trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (logs == null || logs!.isEmpty) {
      return const SizedBox.shrink();
    }

    final filteredLogs =
        logs!.where((log) {
          final status = log.orderStatus?.toLowerCase() ?? '';
          return status != 'active' && status != 'new order';
        }).toList()..sort(
          (a, b) => (a.logTimestamp ?? '').compareTo(b.logTimestamp ?? ''),
        );

    if (filteredLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25),
        ...List.generate(filteredLogs.length, (index) {
          final log = filteredLogs[index];
          return TimelineItem(
            title: _getStatusTitle(log.orderStatus ?? ''),
            time: log.logTimestamp != null
                ? formatTime(
                    log.logTimestamp!,
                  ).split(' - ')[0] // Get just the time part from formatTime
                : '--:--',
            isCompleted: true,
            isFirst: index == 0,
            isLast: index == filteredLogs.length - 1,
            isCompletedStatus: log.orderStatus?.toLowerCase() == 'completed',
          );
        }),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final bool isCompletedStatus;

  const TimelineItem({
    super.key,
    required this.title,
    required this.time,
    this.isCompleted = false,
    this.isFirst = false,
    this.isLast = false,
    this.isCompletedStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? (isCompletedStatus
                            ? AppColors.statusArrived
                            : AppColors.primary)
                      : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: AppColors.background,
                        size: 16,
                      )
                    : null,
              ),
              // Vertical line (except for last item)
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isLast ? AppColors.statusArrived : AppColors.primary)
                        : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
