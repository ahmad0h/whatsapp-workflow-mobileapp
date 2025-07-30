class DeviceInitReponseModel {
  String? deviceId;
  String? verificationCode;
  String? expiresIn;

  DeviceInitReponseModel({
    this.deviceId,
    this.verificationCode,
    this.expiresIn,
  });

  DeviceInitReponseModel.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    verificationCode = json['verificationCode'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['verificationCode'] = verificationCode;
    data['expiresIn'] = expiresIn;
    return data;
  }
}
