import '../datasources/project_remote_datasource.dart';
import '../models/create_project_request_model.dart';
import '../models/project_response_model.dart';

class ProjectRepository {
  final ProjectRemoteDataSource _dataSource;

  ProjectRepository({ProjectRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? ProjectRemoteDataSource();

  Future<List<ProjectResponseModel>> getProjects() async {
    try {
      return await _dataSource.getProjects();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProjectResponseModel> createProject(
    CreateProjectRequestModel data,
  ) async {
    try {
      return await _dataSource.createProject(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProjectResponseModel> getProjectDetail(int id) async {
    try {
      return await _dataSource.getProjectDetail(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProjectMember(int projectId, int userId) async {
    try {
      await _dataSource.addProjectMember(projectId, userId);
    } catch (e) {
      rethrow;
    }
  }
}
