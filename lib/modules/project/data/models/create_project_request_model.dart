import 'dart:convert';

class CreateProjectRequestModel {
  final String? description;
  final String? endDate;
  final String? name;
  final String? startDate;

  CreateProjectRequestModel({
    this.description,
    this.endDate,
    this.name,
    this.startDate,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "description": description,
    "end_date": endDate,
    "name": name,
    "start_date": startDate,
  };
}
