import 'dart:convert';
import 'dart:io';
import 'package:baseball_ai/core/models/daily_data_model.dart';
import 'package:baseball_ai/core/models/insights_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:baseball_ai/core/utils/const/api_constants.dart';
import 'package:baseball_ai/core/models/user_model.dart';
import 'package:baseball_ai/core/models/chat_model.dart';

import 'package:baseball_ai/core/models/daily_logs_model.dart';

import '../models/daily_checkin_model.dart';

class ApiService {
  static Future<ApiResponse<User>> signup(SignupRequest request) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.createUser}',
      );

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data),
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: responseData['message'] ?? 'Signup failed',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<User>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<User>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Signup failed',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginUser}');

      final requestBody = {'email': email, 'password': password};

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<LoginResponse>.fromJson(
          responseData,
          (data) => LoginResponse.fromJson(data),
        );
      } else {
        return ApiResponse<LoginResponse>(
          success: false,
          message: responseData['message'] ?? 'Login failed',
          error: responseData['error'] ?? 'Invalid credentials',
        );
      }
    } on SocketException {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Login failed',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<ForgotPasswordResponse>> forgotPassword({
    required String email,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
      );

      final requestBody = {'email': email};

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<ForgotPasswordResponse>.fromJson(
          responseData,
          (data) => ForgotPasswordResponse.fromJson(responseData),
        );
      } else {
        return ApiResponse<ForgotPasswordResponse>(
          success: false,
          message: responseData['message'] ?? 'Request failed',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<ForgotPasswordResponse>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<ForgotPasswordResponse>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<ForgotPasswordResponse>(
        success: false,
        message: 'Request failed',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<VerifyEmailResponse>> verifyEmail({
    required String email,
    required String oneTimeCode,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.verifyEmail}',
      );

      final requestBody = {'email': email, 'oneTimeCode': oneTimeCode};

      final response = await http.post(
        url,
        headers: ApiConstants.headers,
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<VerifyEmailResponse>.fromJson(
          responseData,
          (data) => VerifyEmailResponse.fromJson(responseData),
        );
      } else {
        return ApiResponse<VerifyEmailResponse>(
          success: false,
          message: responseData['message'] ?? 'Verification failed',
          error: responseData['error'] ?? 'Invalid code',
        );
      }
    } on SocketException {
      return ApiResponse<VerifyEmailResponse>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<VerifyEmailResponse>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<VerifyEmailResponse>(
        success: false,
        message: 'Verification failed',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<ResetPasswordResponse>> resetPassword({
    required String resetCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    print('Reset Code: $resetCode');
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.resetPassword}',
      );

      final requestBody = {
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(resetCode),
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<ResetPasswordResponse>.fromJson(
          responseData,
          (data) => ResetPasswordResponse.fromJson(responseData),
        );
      } else {
        return ApiResponse<ResetPasswordResponse>(
          success: false,
          message: responseData['message'] ?? 'Password reset failed',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<ResetPasswordResponse>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<ResetPasswordResponse>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<ResetPasswordResponse>(
        success: false,
        message: 'Password reset failed',
        error: e.toString(),
      );
    }
  }

  // Profile API methods
  static Future<ApiResponse<User>> getProfile(String token) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getProfile}',
      );

      final response = await http.get(
        url,
        headers: ApiConstants.getAuthHeaders(token),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data),
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: responseData['message'] ?? 'Failed to get profile',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<User>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<User>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to get profile',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<User>> updateProfile({
    required String token,
    String? name,
    DateTime? birthDate,
    File? imageFile,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.updateProfile}',
      );

      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(ApiConstants.getFormDataHeaders(token));

      // Prepare the data object
      Map<String, dynamic> dataObject = {};
      if (name != null) dataObject['name'] = name;
      if (birthDate != null)
        dataObject['birthDate'] = birthDate.toIso8601String();

      // Add the data field as JSON string
      if (dataObject.isNotEmpty) {
        request.fields['data'] = jsonEncode(dataObject);
      }
      // Add image file if provided
      if (imageFile != null) {
        // Get MIME type from file extension
        String? mimeType = lookupMimeType(imageFile.path);

        // Default to image/jpeg if MIME type cannot be determined
        mimeType ??= 'image/jpeg';

        // Split MIME type to get main type and subtype
        final mimeTypeParts = mimeType.split('/');
        final mainType = mimeTypeParts.isNotEmpty ? mimeTypeParts[0] : 'image';
        final subType = mimeTypeParts.length > 1 ? mimeTypeParts[1] : 'jpeg';

        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: imageFile.path.split('/').last,
          contentType: MediaType(mainType, subType),
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data),
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: responseData['message'] ?? 'Failed to update profile',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<User>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<User>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to update profile',
        error: e.toString(),
      );
    }
  }

  // Chat API methods
  static Future<ApiResponse<ChatResponse>> sendChatMessage({
    required String token,
    required String userId,
    required String message,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.chatWithBot}',
      );

      final requestBody = {'userId': userId, 'message': message};

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<ChatResponse>.fromJson(
          responseData,
          (data) => ChatResponse.fromJson(responseData),
        );
      } else {
        return ApiResponse<ChatResponse>(
          success: false,
          message: responseData['message'] ?? 'Failed to send message',
          error: responseData['error'] ?? 'Unknown error occurred',
        );
      }
    } on SocketException {
      return ApiResponse<ChatResponse>(
        success: false,
        message: 'No internet connection',
        error: 'Please check your internet connection and try again',
      );
    } on FormatException {
      return ApiResponse<ChatResponse>(
        success: false,
        message: 'Invalid response format',
        error: 'Server returned invalid data',
      );
    } catch (e) {
      return ApiResponse<ChatResponse>(
        success: false,
        message: 'Failed to send message',
        error: e.toString(),
      );
    }
  }

  // Daily Logs API methods
  static Future<DailyLogsResponse> submitDailyLogs({
    required String token,
    required DailyLogsRequest dailyLogsRequest,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(dailyLogsRequest.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  // Daily Logs API methods
  static Future<DailyLogsResponse> submitDailyWellness({
    required String token,
    required DailyWellnessRequest request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  // Daily Logs API methods
  static Future<DailyLogsResponse> submitThrowingJournal({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  // Daily Logs API methods
  static Future<DailyLogsResponse> submitArmCare({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  static Future<DailyLogsResponse> submitLiftingData({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  static Future<DailyLogsResponse> submitHittingJournal({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  static Future<DailyLogsResponse> submitVisualizationSession({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  static Future<DailyLogsResponse> submitNutrition({
    required String token,
    required Map<String, Object> request,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dailyLogs}');

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(request),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DailyLogsResponse(
          success: true,
          message:
              responseData['message'] ?? 'Daily logs submitted successfully',
          data: responseData['data'],
        );
      } else {
        return DailyLogsResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to submit daily logs',
        );
      }
    } on SocketException {
      return DailyLogsResponse(
        success: false,
        message: 'No internet connection',
      );
    } on FormatException {
      return DailyLogsResponse(
        success: false,
        message: 'Invalid response format',
      );
    } catch (e) {
      return DailyLogsResponse(
        success: false,
        message: 'Failed to submit daily logs',
      );
    }
  }

  static Future<DailyLogRetrievalResponse> getDailyData({
    required String token,
    required String userId,
    required String date,
  }) async {
    try {
      // Construct URL with proper endpoint format: daily-logs/user/{userId}/date?date={date}
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.dailyLogs}/user/$userId/date?date=$date',
      );

      final response = await http.get(
        url,
        headers: ApiConstants.getAuthHeaders(token),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Use fromJson to properly parse the response
        return DailyLogRetrievalResponse.fromJson(responseData);
      } else {
        return DailyLogRetrievalResponse(
          success: false,
          message:
              responseData['message'] ?? 'Failed to retrieve daily log data',
          data: null, // Set data to null for error cases
        );
      }
    } on SocketException {
      return DailyLogRetrievalResponse(
        success: false,
        message: 'No internet connection',
        data: null, // Set data to null for error cases
      );
    } on FormatException {
      return DailyLogRetrievalResponse(
        success: false,
        message: 'Invalid response format',
        data: null, // Set data to null for error cases
      );
    } catch (e) {
      return DailyLogRetrievalResponse(
        success: false,
        message: 'Failed to retrieve daily log data: ${e.toString()}',
        data: null, // Set data to null for error cases
      );
    }
  }

  static Future<InsightsResponse> getInsightsData({
    required String token,
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.dailyLogs}/insights',
      );
      final requestBody = {
        'userId': userId,
        'startDate': startDate,
        'endDate': endDate,
      };

      final response = await http.post(
        url,
        headers: ApiConstants.getAuthHeaders(token),
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return InsightsResponse.fromJson(responseData);
      } else {
        return InsightsResponse(
          success: false,
          message:
              responseData['message'] ?? 'Failed to retrieve insights data',
          data: null,
        );
      }
    } on SocketException {
      return InsightsResponse(
        success: false,
        message: 'No internet connection',
        data: null,
      );
    } on FormatException {
      return InsightsResponse(
        success: false,
        message: 'Invalid response format',
        data: null,
      );
    } catch (e) {
      return InsightsResponse(
        success: false,
        message: 'Failed to retrieve insights data: ${e.toString()}',
        data: null,
      );
    }
  }
}
