import 'package:baseball_ai/views/glob_widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../auth/controller/auth_controller.dart';
import '../../notification_screen.dart';
import '../controller/daily_short_controller.dart';

// Assuming AppStyles exists in your project like this:
class AppStyles {
  static const Color backgroundColor = Color(0xFF1A1A1A); // Dark background
  static const Color primaryColor = Colors.yellow; // Yellow accent
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.grey;
  static const Color cardColor = Color(
    0xFF2C2C2C,
  ); // Slightly lighter grey for inputs
  static const Color sliderInactiveColor = Colors.grey;

  static const TextStyle headingTitle = TextStyle(
    color: textColor,
    fontSize: 20, // Adjust as needed
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText = TextStyle(
    color: textColor,
    fontSize: 15, // Adjust as needed
  );

  static const TextStyle labelText = TextStyle(
    color: textColor,
    fontSize: 16, // Adjust as needed
    fontWeight: FontWeight.w500,
  );

  static const TextStyle sliderValueText = TextStyle(
    color: textColor,
    fontSize: 18, // Adjust as needed
    fontWeight: FontWeight.bold,
  );

  static const TextStyle hintStyle = TextStyle(
    color: hintColor,
    fontSize: 14, // Adjust as needed
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.black, // Text color on yellow button
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

class DailyShortScreen extends StatelessWidget {
  const DailyShortScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final DailyController controller = Get.put(DailyController());
    final authController = Get.find<AuthController>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        authController.loadProgress();
        print('Back navigation invoked: $didPop');
      },
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppStyles.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppStyles.textColor),
            onPressed: () {
              authController.loadProgress();
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Daily Short Questions',
            style: AppStyles.headingTitle,
          ),
          // actions: [
          //   IconButton(
          //     icon: Container(
          //       padding: const EdgeInsets.all(6),
          //       decoration: BoxDecoration(
          //         color: Colors.grey.withOpacity(0.3), // Circle background
          //         shape: BoxShape.circle,
          //       ),
          //       child: const Icon(
          //         Icons.notifications_none_outlined, // Or Icons.notifications
          //         color: AppStyles.textColor,
          //         size: 24, // Adjust size
          //       ),
          //     ),
          //     onPressed: () {
          //       // Handle notification tap
          //       Get.to(() => NotificationScreen());
          //     },
          //   ),
          //   SizedBox(width: 10.w), // Add some padding
          // ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track your overall well-being and physical preparedness',
                style: AppStyles.bodyText.copyWith(color: AppStyles.hintColor),
              ),
              SizedBox(height: 25.h),

              // --- How are we feeling? ---
              Text('How are we feeling?', style: AppStyles.labelText),
              SizedBox(height: 10.h),
              TextField(
                controller: controller.feelingController,
                maxLines: 4,
                style: AppStyles.bodyText,
                decoration: InputDecoration(
                  hintText: 'Describe how you\'re feeling today...',
                  hintStyle: AppStyles.hintStyle,
                  filled: true,
                  fillColor: AppStyles.cardColor, // Input background
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                    ), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: AppStyles.primaryColor,
                    ), // Focused border
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // --- Soreness Scale ---
              Obx(
                () => _buildSliderSection(
                  context: context,
                  label:
                      'On a scale of 1 to 10, with 10 being unable to compete, how sore are you?',
                  value: controller.sorenessValue.value,
                  onChanged: controller.updateSorenessValue,
                ),
              ),
              SizedBox(height: 30.h),

              // --- Sleep Time ---
              Text('When did you go to sleep?', style: AppStyles.labelText),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildTimePickerField(
                        context: context,
                        isSleepTime: true,
                        currentTime: controller.sleepTime.value,
                        hint: 'Sleep Time',
                        onTap: () => _selectTime(context, controller, true),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w), // Space between fields
                  Expanded(
                    child: Obx(
                      () => _buildTimePickerField(
                        context: context,
                        isSleepTime: false, // This is for wake time
                        currentTime: controller.wakeTime.value,
                        hint: 'Wake Time',
                        onTap: () => _selectTime(context, controller, false),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // --- Hydration Scale ---
              Obx(
                () => _buildSliderSection(
                  context: context,
                  label: 'On a scale of 1 to 10, how hydrated are you?',
                  value: controller.hydrationValue.value,
                  onChanged: controller.updateHydrationValue,
                ),
              ),
              SizedBox(height: 30.h),

              // --- Readiness Scale ---
              Obx(
                () => _buildSliderSection(
                  context: context,
                  label:
                      'On a scale of 1 to 10, how ready to compete are you today?',
                  value: controller.readinessValue.value,
                  onChanged: controller.updateReadinessValue,
                ),
              ),
              SizedBox(height: 40.h), // Space before button if it scrolls
            ],
          ),
        ),
        // --- Submit Button (Fixed at Bottom) ---
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: SizedBox(
            height: 40.h,
            child: Obx(
              () => MyTextButton(
                buttonText:
                    controller.isSubmitting.value ? 'Submitting...' : 'Submit',
                onTap:
                    controller.isSubmitting.value
                        ? () {}
                        : () => controller.submitDailyWellness(),
                isOutline: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper function to show time picker ---
  Future<void> _selectTime(
    BuildContext context,
    DailyController controller,
    bool isSleepTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        // Theme the time picker
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppStyles.primaryColor, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: AppStyles.textColor, // body text color
            ),
            dialogBackgroundColor: AppStyles.cardColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppStyles.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isSleepTime) {
        controller.updateSleepTime(picked);
      } else {
        controller.updateWakeTime(picked);
      }
    }
  }

  // --- Helper Widget for Slider Sections ---
  Widget _buildSliderSection({
    required BuildContext context,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.labelText),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppStyles.primaryColor,
                  inactiveTrackColor: AppStyles.sliderInactiveColor.withOpacity(
                    0.5,
                  ),
                  trackHeight: 6.0, // Thickness of the track
                  thumbColor: Colors.white, // Color of the draggable thumb
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10.0,
                  ), // Size of the thumb
                  overlayColor: AppStyles.primaryColor.withAlpha(
                    0x29,
                  ), // Color when interacting
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20.0,
                  ), // Size of the overlay
                  trackShape:
                      const RoundedRectSliderTrackShape(), // Makes track ends rounded
                ),
                child: Slider(
                  value: value,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9, // Allows snapping to integers 1 through 10
                  // label: value.round().toString(), // Shows label on drag (optional)
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Text(
              value.round().toString(), // Display the rounded integer value
              style: AppStyles.sliderValueText,
            ),
          ],
        ),
      ],
    );
  }

  // --- Helper Widget for Time Picker Input Field ---
  Widget _buildTimePickerField({
    required BuildContext context,
    required bool isSleepTime,
    required TimeOfDay? currentTime,
    required String hint,
    required VoidCallback onTap,
  }) {
    final DailyController controller = Get.find<DailyController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppStyles.cardColor, // Input background
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Pushes icon to the right
          children: [
            Text(
              controller.formatTime(
                currentTime,
              ), // Display formatted time or placeholder
              style:
                  currentTime != null
                      ? AppStyles.bodyText
                      : AppStyles.hintStyle,
            ),
            const Icon(Icons.access_time, color: AppStyles.hintColor, size: 20),
          ],
        ),
      ),
    );
  }
}
