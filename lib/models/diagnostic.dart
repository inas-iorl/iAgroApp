class DiagnosticModel {
  String id;
  DateTime? moment;
  DateTime? measure_time;
  DateTime? actual_measure_time;
  String field_id;
  String field_part;
  String device_id;
  String result_image;
  String result_raw;
  String result;

  DiagnosticModel(
      this.id,
      this.moment,
      this.measure_time,
      this.actual_measure_time,
      this.field_id,
      this.field_part,
      this.device_id,
      this.result_image,
      this.result_raw,
      this.result,
      );

  int? measureIn(){
    return measure_time?.difference(DateTime.now()).inHours;
  }

  String measureInStr(){
      int? hours = measure_time?.difference(DateTime.now()).inHours;
      if (hours! < 1){
        return "${measure_time?.difference(DateTime.now()).inMinutes} минут";
      }
    return "$hours часов";
  }

  factory DiagnosticModel.fromJson(Map json) {
    return DiagnosticModel(
      json['_id'] ?? '',
      DateTime.parse(json['moment']),
      DateTime.parse(json['measure_time']),
      json.containsKey('actual_measure_time') ? DateTime.parse(json['actual_measure_time']) : null,
      json['field_id'] ?? '',
      json['field_part'] ?? '',
      json['device_id'] ?? '',
      json['result_image'] ?? '',
      (json['result_raw'] ?? '').toString(),
      (json['result'] ?? '').toString(),
    );
  }
}