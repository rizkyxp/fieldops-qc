import 'dart:convert';

class CreateProjectRequestModel {
  final String? description;
  final String? endDate;
  final String? name;
  final String? startDate;
  final List<int>? teamMembers;

  CreateProjectRequestModel({
    this.description,
    this.endDate,
    this.name,
    this.startDate,
    this.teamMembers,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "description": description,
    "end_date": endDate,
    "name": name,
    "start_date": startDate,
    "team_members": teamMembers,
  };
}
