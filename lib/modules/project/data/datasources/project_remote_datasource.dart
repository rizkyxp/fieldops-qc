import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_service.dart';
import '../models/create_project_request_model.dart';
import '../models/project_response_model.dart';

class ProjectRemoteDataSource {
  final Dio _dio;

  ProjectRemoteDataSource({Dio? dio}) : _dio = dio ?? DioService().client;

  Future<List<ProjectResponseModel>> getProjects() async {
    final response = await _dio.get(ApiEndpoints.getProjects);
    // Assuming response.data['data'] is a List
    if (response.data['data'] != null) {
      return (response.data['data'] as List)
          .map((e) => ProjectResponseModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<ProjectResponseModel> createProject(
    CreateProjectRequestModel projectData,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.createProject,
      data: projectData.toJson(),
    );
    return ProjectResponseModel.fromJson(response.data['data']);
  }

  Future<ProjectResponseModel> getProjectDetail(int id) async {
    final response = await _dio.get(
      ApiEndpoints.getProjectDetail.replaceAll('{id}', id.toString()),
    );
    return ProjectResponseModel.fromJson(response.data['data']);
  }

  Future<void> addProjectMember(int projectId, int userId) async {
    await _dio.post(
      ApiEndpoints.addProjectMember.replaceAll('{id}', projectId.toString()),
      data: {'user_id': userId},
    );
  }
}
