class DeviceModel {
  String id;
  String name;
  String field_id;

  DeviceModel(
      this.id,
      this.name,
      this.field_id,
      );

  factory DeviceModel.fromJson(dynamic json) {
    return DeviceModel(
        json['_id'] ?? '',
        json['name'] ?? '',
        json['field_id'] ?? '',
    );
  }
}
