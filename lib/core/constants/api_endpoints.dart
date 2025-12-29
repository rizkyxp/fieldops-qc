class ApiEndpoints {
  // Auth
  static const String login = '/mobile/auth/login';
  static const String register = '/mobile/auth/register';
  static const String logout = '/mobile/auth/logout';

  // Project
  static const String getProjects = '/mobile/projects';
  static const String createProject = '/mobile/projects';
  static const String getProjectDetail = '/mobile/projects/{id}';
  static const String getProjectPlanDetail =
      '/mobile/projects/floor-plans/{id}';
  static const String uploadProjectPlan = '/mobile/projects/floor-plans/{id}';
  static const String addProjectMember = '/mobile/projects/{id}/members';
}
