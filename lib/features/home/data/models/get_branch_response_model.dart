class GetBranchResponseModel {
  String? branchId;
  Business? business;
  String? branchName;
  String? branchCity;
  String? branchMapLocation;
  String? branchStatus;
  String? orderingStatus;
  String? deviceToken;
  int? expectedOrderDurationTime;

  GetBranchResponseModel({
    this.branchId,
    this.business,
    this.branchName,
    this.branchCity,
    this.branchMapLocation,
    this.branchStatus,
    this.orderingStatus,
    this.deviceToken,
    this.expectedOrderDurationTime,
  });

  GetBranchResponseModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    business = json['business'] != null
        ? Business.fromJson(json['business'])
        : null;
    branchName = json['branch_name'];
    branchCity = json['branch_city'];
    branchMapLocation = json['branch_map_location'];
    branchStatus = json['branch_status'];
    orderingStatus = json['ordering_status'];
    deviceToken = json['device_token'];
    expectedOrderDurationTime = json['expected_order_duration_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    if (business != null) {
      data['business'] = business!.toJson();
    }
    data['branch_name'] = branchName;
    data['branch_city'] = branchCity;
    data['branch_map_location'] = branchMapLocation;
    data['branch_status'] = branchStatus;
    data['ordering_status'] = orderingStatus;
    data['device_token'] = deviceToken;
    data['expected_order_duration_time'] = expectedOrderDurationTime;
    return data;
  }
  
  GetBranchResponseModel copyWith({
    String? branchId,
    Business? business,
    String? branchName,
    String? branchCity,
    String? branchMapLocation,
    String? branchStatus,
    String? orderingStatus,
    String? deviceToken,
    int? expectedOrderDurationTime,
  }) {
    return GetBranchResponseModel(
      branchId: branchId ?? this.branchId,
      business: business ?? this.business,
      branchName: branchName ?? this.branchName,
      branchCity: branchCity ?? this.branchCity,
      branchMapLocation: branchMapLocation ?? this.branchMapLocation,
      branchStatus: branchStatus ?? this.branchStatus,
      orderingStatus: orderingStatus ?? this.orderingStatus,
      deviceToken: deviceToken ?? this.deviceToken,
      expectedOrderDurationTime: expectedOrderDurationTime ?? this.expectedOrderDurationTime,
    );
  }
}

class Business {
  String? businessId;
  String? businessName;
  String? businessType;
  String? businessTags;
  String? businessStatus;
  String? businessIban;
  String? businessCr;
  String? businessVatNumber;
  String? businessContactPersonName;
  String? businessContactPersonMobile;
  String? businessContactPersonEmail;
  Owner? owner;

  Business({
    this.businessId,
    this.businessName,
    this.businessType,
    this.businessTags,
    this.businessStatus,
    this.businessIban,
    this.businessCr,
    this.businessVatNumber,
    this.businessContactPersonName,
    this.businessContactPersonMobile,
    this.businessContactPersonEmail,
    this.owner,
  });

  Business.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    businessName = json['business_name'];
    businessType = json['business_type'];
    businessTags = json['business_tags'];
    businessStatus = json['business_status'];
    businessIban = json['business_iban'];
    businessCr = json['business_cr'];
    businessVatNumber = json['business_vat_number'];
    businessContactPersonName = json['business_contact_person_name'];
    businessContactPersonMobile = json['business_contact_person_mobile'];
    businessContactPersonEmail = json['business_contact_person_email'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = businessId;
    data['business_name'] = businessName;
    data['business_type'] = businessType;
    data['business_tags'] = businessTags;
    data['business_status'] = businessStatus;
    data['business_iban'] = businessIban;
    data['business_cr'] = businessCr;
    data['business_vat_number'] = businessVatNumber;
    data['business_contact_person_name'] = businessContactPersonName;
    data['business_contact_person_mobile'] = businessContactPersonMobile;
    data['business_contact_person_email'] = businessContactPersonEmail;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }
}

class Owner {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Owner({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['role'] = role;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
