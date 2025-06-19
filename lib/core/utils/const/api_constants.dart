class ApiConstants {
  // Base URL
  // static const String baseUrl = 'http://192.168.10.99:5005/api/v1';
  static const String baseUrl =
      'https://3f11-115-127-156-9.ngrok-free.app/api/v1';
  // Authentication Endpoints
  static const String createUser = '/user';
  static const String loginUser = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resetPassword = '/auth/reset-password';
  // Profile Endpoints
  static const String getProfile = '/user/getme';
  static const String updateProfile = '/user'; // Chat Endpoints
  static const String chatWithBot = '/daily-logs/chat';

  // Daily Logs Endpoints
  static const String dailyLogs = '/daily-logs';

  // Nutrition Endpoints
  static const String nutrition = '/nutrition';

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers with Bearer token
  static Map<String, String> getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Headers for form data with Bearer token
  static Map<String, String> getFormDataHeaders(String token) {
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  // Response Keys
  static const String success = 'success';
  static const String message = 'message';
  static const String data = 'data';
  static const String error = 'error';
}
