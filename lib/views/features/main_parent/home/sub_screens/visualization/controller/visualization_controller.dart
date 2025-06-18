import 'dart:async';
import 'dart:ui';
import 'package:baseball_ai/core/models/daily_data_model.dart';
import 'package:get/get.dart';
import 'package:baseball_ai/views/features/auth/controller/auth_controller.dart';
import 'package:baseball_ai/core/services/api_service.dart';

class VisualizationController extends GetxController {
  // Timer variables
  Timer? _timer;

  // Observable variables
  final RxInt currentSession = 1.obs;
  final RxInt totalSessions = 4.obs;
  final RxInt remainingSeconds = 24.obs; // 4 minutes per session (4*60)
  final RxBool isRunning = false.obs;
  final RxBool isSaving = false.obs;
  final RxString savingMessage = ''.obs;
  final authController = Get.find<AuthController>();

  // Session duration (4 minutes in seconds)
  static const int sessionDuration = 24;

  // Session names for better UX
  final List<String> sessionNames = [
    'Box Breathing',
    'Game Environment',
    'Game Execution',
    'Pregame Routine',
  ];

  @override
  void onInit() {
    super.onInit();
    authController.loadProgress(detectCurrentSession);
  }

  void detectCurrentSession(DailyLogRetrievalResponse data) {
    print('Detecting current session...');
    print(
      authController.dailyLogResponse.value.data!.visualization?.boxBreathing,
    );
    print(
      authController
          .dailyLogResponse
          .value
          .data!
          .visualization
          ?.gameEnvironment,
    );
    print(
      authController.dailyLogResponse.value.data!.visualization?.gameExecution,
    );
    print(
      authController.dailyLogResponse.value.data!.visualization?.pregameRoutine,
    );
    if (authController
            .dailyLogResponse
            .value
            .data!
            .visualization
            ?.boxBreathing ==
        true) {
      currentSession.value = 2;
    } else if (authController
            .dailyLogResponse
            .value
            .data!
            .visualization
            ?.gameEnvironment ==
        true) {
      currentSession.value = 3;
    } else if (authController
            .dailyLogResponse
            .value
            .data!
            .visualization
            ?.gameExecution ==
        true) {
      currentSession.value = 4;
    } else if (authController
            .dailyLogResponse
            .value
            .data!
            .visualization
            ?.pregameRoutine ==
        true) {
      _onAllSessionsCompleted();
    } else {
      currentSession.value = 1; // Default to first session
    }
    print('Current session detected: ${currentSession.value}');
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Get current session name
  String get currentSessionName {
    if (currentSession.value > 0 &&
        currentSession.value <= sessionNames.length) {
      return sessionNames[currentSession.value - 1];
    }
    return 'Session ${currentSession.value}';
  }

  // Computed properties
  double get progress {
    if (remainingSeconds.value <= 0) return 1.0;
    return 1.0 - (remainingSeconds.value / sessionDuration);
  }

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get remainingBoxTime {
    final totalRemaining =
        (totalSessions.value - currentSession.value + 1) * sessionDuration +
        remainingSeconds.value;
    final minutes = totalRemaining ~/ 60;
    return '${minutes}min remaining';
  }

  // Timer control methods
  void togglePlayPause() {
    if (isRunning.value) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  void startTimer() {
    if (remainingSeconds.value <= 0) return;

    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        // Session completed
        _onSessionCompleted();
      }
    });
  }

  void pauseTimer() {
    isRunning.value = false;
    _timer?.cancel();
  }

  void stopTimer() {
    isRunning.value = false;
    _timer?.cancel();
    remainingSeconds.value = sessionDuration;
  }

  void restartTimer() {
    stopTimer();
    remainingSeconds.value = sessionDuration;
  }

  void resetToFirstSession() {
    stopTimer();
    currentSession.value = 1;
    remainingSeconds.value = sessionDuration;
    isSaving.value = false;
    savingMessage.value = '';
  }

  // Handle session completion
  Future<void> _onSessionCompleted() async {
    pauseTimer();

    // Call API to save session data
    await _saveSessionToAPI();

    // Check if all sessions are completed
    if (currentSession.value >= totalSessions.value) {
      _onAllSessionsCompleted();
    } else {
      _moveToNextSession();
    }
  }

  // Generate session-specific data based on current session
  Map<String, dynamic> _getSessionData() {
    final sessionTime = (sessionDuration / 60).round(); // Convert to minutes

    switch (currentSession.value) {
      case 1: // Box Breathing
        return {
          'visualization': {
            'boxBreathing': true,
            'boxBreathingTime': sessionTime,
          },
        };

      case 2: // Game Environment
        return {
          'visualization': {
            'gameEnvironment': true,
            'gameEnvironmentTime': sessionTime,
          },
        };

      case 3: // Game Execution
        return {
          'visualization': {
            'gameExecution':
                true, // Changed to true since session was completed
            'gameExecutionTime': sessionTime,
          },
        };

      case 4: // Pregame Routine
        return {
          'visualization': {
            'pregameRoutine': true,
            'pregameRoutineTime': sessionTime,
          },
        };

      default:
        return {
          'visualization': {
            'boxBreathing': true,
            'boxBreathingTime': sessionTime,
          },
        };
    }
  }

  // API call to save session data
  Future<void> _saveSessionToAPI() async {
    try {
      isSaving.value = true;
      savingMessage.value = 'Saving ${currentSessionName}...';

      // Check authentication
      if (!Get.isRegistered<AuthController>()) {
        throw Exception('Authentication not found. Please login again.');
      }

      final authController = Get.find<AuthController>();
      final userId = authController.currentUser.value?.id;
      final token = authController.accessToken.value;

      if (userId == null || userId.isEmpty) {
        throw Exception('User not found. Please login again.');
      }

      if (token.isEmpty) {
        throw Exception('Access token not found. Please login again.');
      }

      // Create request data with session-specific content
      final requestData = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        ..._getSessionData(), // Spread the session-specific data
      };

      // Print for debugging
      print('Saving Visualization Session:');
      print(
        'Session: ${currentSession.value}/${totalSessions.value} - ${currentSessionName}',
      );
      print('Request Data: $requestData');

      // Call API
      final response = await ApiService.submitVisualizationSession(
        request: requestData.cast<String, Object>(),
        token: token,
      );

      if (response == null || !response.success) {
        throw Exception(
          'Failed to save session: ${response?.message ?? 'Unknown error'}',
        );
      }

      savingMessage.value = '$currentSessionName saved!';

      // Show success message
      Get.snackbar(
        'Session Saved',
        '$currentSessionName completed and saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 2),
      );

      // Wait a moment to show the saved message
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      savingMessage.value = 'Failed to save session';

      Get.snackbar(
        'Save Error',
        'Failed to save ${currentSessionName}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
      );

      // Even if save fails, continue to next session
      print('Error saving session: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // Move to next session
  void _moveToNextSession() {
    currentSession.value++;
    remainingSeconds.value = sessionDuration;
    savingMessage.value = '';

    Get.snackbar(
      'Next Session',
      'Ready for $currentSessionName (${currentSession.value}/${totalSessions.value})',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFD700),
      colorText: const Color(0xFF000000),
      duration: const Duration(seconds: 2),
    );
  }

  // Handle completion of all sessions
  void _onAllSessionsCompleted() async {
    savingMessage.value = 'All sessions completed!';

    Get.snackbar(
      'Congratulations!',
      'All ${totalSessions.value} visualization sessions completed!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFD700),
      colorText: const Color(0xFF000000),
      duration: const Duration(seconds: 3),
    );

    // Navigate back or reset
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
  }

  // Manual session completion (for testing)
  void completeCurrentSession() {
    remainingSeconds.value = 0;
    _onSessionCompleted();
  }

  // Skip to specific session (for testing/development)
  void skipToSession(int sessionNumber) {
    if (sessionNumber >= 1 && sessionNumber <= totalSessions.value) {
      stopTimer();
      currentSession.value = sessionNumber;
      remainingSeconds.value = sessionDuration;
      savingMessage.value = '';
    }
  }
}
