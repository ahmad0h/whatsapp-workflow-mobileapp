import 'package:whatsapp_workflow_mobileapp/core/utils/formant_status.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/format_time.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_current_status.dart';
import 'package:whatsapp_workflow_mobileapp/core/utils/get_status_color.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/data/models/order_model.dart';
import 'package:whatsapp_workflow_mobileapp/features/home/presentation/views/widgets/order_card_model.dart';

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
    orderType: order.type ?? '',
    customerAddress: order.customerAddress ?? '',
  );
}
