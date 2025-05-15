class ApiRoutes {
  static const String baseUrl = 'https://b7ef-59-103-246-18.ngrok-free.app/api';

  // Auth
  static const String userRegister = '$baseUrl/users/register';
  static const String login = '$baseUrl/users/login';

  // Courses
  static const String courses = '$baseUrl/courses';
  static const String createCourse = '$baseUrl/courses/create';

  // Sessions
  static const String sessions = '$baseUrl/sessions';

  // ✅ ADD THESE TWO LINES:
  static const String enrollmentOptions = '$baseUrl/enrollment-options';
  static const String enrollments = '$baseUrl/enrollments';
  static const String fetchStudentEnrollments = '$baseUrl/enrollments/student';

  // Attendance
  static const String fetchStudentAttendance =
      '$baseUrl/attendance/student'; // Added attendance route
}
