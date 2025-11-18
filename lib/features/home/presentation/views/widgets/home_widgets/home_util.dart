import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/mapping.dart';

class HomeUtils {
  /// Filter orders based on selected tab
  static List<OrderCardModel> filterOrders(
    List<OrderCardModel> orders,
    String tab,
  ) {
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

  /// Process orders list - map, filter and sort
  static List<OrderCardModel> processOrders(List ordersList) {
    return ordersList
        .map((order) => mapOrderToCardModel(order))
        .cast<OrderCardModel>()
        .where((order) {
          // Filter out completed, rejected, cancelled and refunded orders
          final status = order.status.trim().toLowerCase();
          final paymentStatus =
              order.orderData.paymentStatus?.toLowerCase() ?? '';
          return status != 'completed' &&
              status != 'is_finished' &&
              status != 'rejected' &&
              status != 'cancelled' &&
              paymentStatus != 'refunded';
        })
        .toList()
      ..sort((a, b) {
        // First sort by date (newest first)
        final dateCompare = (b.orderData.orderDate ?? '').compareTo(
          a.orderData.orderDate ?? '',
        );
        if (dateCompare != 0) return dateCompare;

        // If dates are equal, sort by status
        final statusA = a.status.trim().toLowerCase();
        final statusB = b.status.trim().toLowerCase();

        // New orders first
        if (statusA == 'active' || statusA == 'new order') {
          return -1;
        }
        if (statusB == 'active' || statusB == 'new order') return 1;

        // Then in progress orders
        if (statusA == 'in_progress' || statusA == 'in progress') {
          return -1;
        }
        if (statusB == 'in_progress' || statusB == 'in progress') {
          return 1;
        }

        // Finally, other statuses (excluding completed)
        return statusA.compareTo(statusB);
      });
  }
}
