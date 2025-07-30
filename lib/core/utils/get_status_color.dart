import 'package:flutter/material.dart';
import 'package:whatsapp_workflow_mobileapp/core/constants/app_colors.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return AppColors.primary; // Blue for new orders
    case 'in_progress':
      return AppColors.statusPreparing; // Yellow for in progress
    case 'arrived':
      return AppColors.statusArrived; // Green for arrived
    case 'completed':
      return AppColors.statusCompleted; // Green for completed
    case 'is_finished':
      return Color(0xFFDDB78A); // Orange for is_finished
    case 'cancelled':
    case 'rejected':
      return AppColors.statusRejected; // Red for cancelled/rejected
    default:
      return AppColors.textSecondary; // Gray for unknown status
  }
}
