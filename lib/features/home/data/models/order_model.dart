class OrderModel {
  String? id;
  String? orderNumber;
  String? customerId;
  Customer? customer;
  String? vehicleId;
  Vehicle? vehicle;
  String? branchId;
  String? status;
  String? netAmount;
  String? vatAmount;
  String? paymentStatus;
  String? orderDate;
  String? updatedAt;
  List<OrderDetails>? orderDetails;

  OrderModel({
    this.id,
    this.orderNumber,
    this.customerId,
    this.customer,
    this.vehicleId,
    this.vehicle,
    this.branchId,
    this.status,
    this.netAmount,
    this.vatAmount,
    this.paymentStatus,
    this.orderDate,
    this.updatedAt,
    this.orderDetails,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    vehicleId = json['vehicle_id'];
    vehicle = json['vehicle'] != null
        ? Vehicle.fromJson(json['vehicle'])
        : null;
    branchId = json['branch_id'];
    status = json['status'];
    netAmount = json['net_amount'];
    vatAmount = json['vat_amount'];
    paymentStatus = json['payment_status'];
    orderDate = json['order_date'];
    updatedAt = json['updated_at'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['customer_id'] = customerId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['vehicle_id'] = vehicleId;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    data['branch_id'] = branchId;
    data['status'] = status;
    data['net_amount'] = netAmount;
    data['vat_amount'] = vatAmount;
    data['payment_status'] = paymentStatus;
    data['order_date'] = orderDate;
    data['updated_at'] = updatedAt;
    if (orderDetails != null) {
      data['orderDetails'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? fullName;
  String? email;
  String? phone;
  String? gender;
  String? dob;

  Customer({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['dob'] = dob;
    return data;
  }
}

class Vehicle {
  String? id;
  String? brand;
  String? model;
  String? plateNumber;
  String? color;
  String? type;
  String? createdAt;
  String? userId;

  Vehicle({
    this.id,
    this.brand,
    this.model,
    this.plateNumber,
    this.color,
    this.type,
    this.createdAt,
    this.userId,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    model = json['model'];
    plateNumber = json['plate_number'];
    color = json['color'];
    type = json['type'];
    createdAt = json['created_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['plate_number'] = plateNumber;
    data['color'] = color;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['user_id'] = userId;
    return data;
  }
}

class OrderDetails {
  String? id;
  String? orderId;
  String? productName;
  int? productQuantity;
  String? productPrice;
  String? total;

  OrderDetails({
    this.id,
    this.orderId,
    this.productName,
    this.productQuantity,
    this.productPrice,
    this.total,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productName = json['product_name'];
    productQuantity = json['product_quantity'];
    productPrice = json['product_price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_name'] = productName;
    data['product_quantity'] = productQuantity;
    data['product_price'] = productPrice;
    data['total'] = total;
    return data;
  }
}
