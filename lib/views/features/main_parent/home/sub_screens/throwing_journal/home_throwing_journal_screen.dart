import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../auth/controller/auth_controller.dart';
import '../notification_screen.dart';
import 'throwing_journal_controller.dart';

// Assuming AppStyles exists in your project like this:
class AppStyles {
  static const Color backgroundColor = Color(0xFF1A1A1A); // Dark background
  static const Color primaryColor = Colors.yellow; // Yellow accent
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.grey;
  static const Color cardColor = Color(
    0xFF2C2C2C,
  ); // Slightly lighter grey for inputs
  static const Color radioActiveColor =
      primaryColor; // Yellow for selected radio
  static const Color radioInactiveColor = Colors.grey;

  static const TextStyle headingTitle = TextStyle(
    color: textColor,
    fontSize: 20, // Adjust as needed
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText = TextStyle(
    color: textColor,
    fontSize: 15, // Adjust as needed
    height: 1.4, // Improve readability for multi-line text
  );

  static const TextStyle labelText = TextStyle(
    color: textColor,
    fontSize: 16, // Adjust as needed
    fontWeight: FontWeight.w500,
  );

  static const TextStyle smallLabelText = TextStyle(
    // For text above text fields
    color: textColor,
    fontSize: 14, // Adjust as needed
    fontWeight: FontWeight.normal,
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

class HomeThrowingJournalScreen extends StatelessWidget {
  const HomeThrowingJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final ThrowingJournalController controller = Get.put(ThrowingJournalController());
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
          title: const Text('Throwing Journal', style: AppStyles.headingTitle),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3), // Circle background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_outlined, // Or Icons.notifications
                  color: AppStyles.textColor,
                  size: 24, // Adjust size
                ),
              ),
              onPressed: () {
                // Handle notification tap
                Get.to(() => NotificationScreen());
              },
            ),
            SizedBox(width: 10.w), // Add some padding
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track your throwing sessions',
                style: AppStyles.bodyText.copyWith(color: AppStyles.hintColor),
              ),
              SizedBox(height: 25.h),
      
              // --- What drills ---
              _buildTextFieldSectionFromConfig(controller.getDrillsFieldConfig()),
      
              // --- Training tools ---
              _buildTextFieldSectionFromConfig(controller.getToolsFieldConfig()),
      
              // --- Sets and Reps ---
              _buildTextFieldSectionFromConfig(controller.getSetsRepsFieldConfig()),
      
              // --- Long Toss Distance ---
              _buildTextFieldSectionFromConfig(controller.getLongTossFieldConfig()),
      
              // --- Pitch Count ---
              _buildTextFieldSectionFromConfig(controller.getPitchCountFieldConfig()),
      
              // --- Focus ---
              _buildTextFieldSectionFromConfig(controller.getFocusFieldConfig()),
      
              // --- Workload Environment ---
              Text(
                'Was your workload in a controlled environment or in-game?',
                style: AppStyles.smallLabelText, // Smaller label style
              ),
              SizedBox(height: 10.h),
              Obx(() => Row(
                children: [
                  _buildRadioButton(
                    controller: controller,
                    title: controller.getEnvironmentText(WorkloadEnvironment.controlled),
                    value: WorkloadEnvironment.controlled,
                  ),
                  SizedBox(width: 20.w), // Space between radio buttons
                  _buildRadioButton(
                    controller: controller,
                    title: controller.getEnvironmentText(WorkloadEnvironment.inGame),
                    value: WorkloadEnvironment.inGame,
                  ),
                ],
              )),
      
              SizedBox(height: 40.h), // Space before button
            ],
          ),
        ),
        // --- Submit Button (Fixed at Bottom) ---
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.primaryColor,
              foregroundColor: Colors.black, // Text color
              minimumSize: Size(double.infinity, 50.h), // Full width
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r), // Rounded corners
              ),
            ),
            onPressed: controller.isSubmitting.value
                ? null
                : () => controller.submitThrowingJournal(),
            child: Text(
              controller.isSubmitting.value ? 'Submitting...' : 'Submit',
              style: AppStyles.buttonTextStyle,
            ),
          )),
        ),
      ),
    );
  }

  // --- Helper Widget for Text Field Sections from Config ---
  Widget _buildTextFieldSectionFromConfig(Map<String, dynamic> config) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h), // Space below each section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config['label'],
            style: AppStyles.smallLabelText,
          ), // Use smaller label style
          SizedBox(height: 10.h),
          TextField(
            controller: config['controller'],
            maxLines: config['maxLines'] ?? 1,
            style: AppStyles.bodyText,
            keyboardType: config['keyboardType'] ?? TextInputType.text,
            inputFormatters: config['inputFormatters'],
            decoration: InputDecoration(
              hintText: config['hint'],
              hintStyle: AppStyles.hintStyle,
              filled: true,
              fillColor: AppStyles.cardColor, // Input background
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 12.h,
              ), // Adjust padding
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
              suffixIcon: config['suffixIcon'] != null
                  ? Icon(config['suffixIcon'], color: AppStyles.hintColor, size: 20)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for Radio Button ---
  Widget _buildRadioButton({
    required ThrowingJournalController controller,
    required String title,
    required WorkloadEnvironment value,
  }) {
    return GestureDetector(
      // Make the text tappable as well
      onTap: () => controller.updateEnvironment(value),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Keep row tight
        children: [
          Radio<WorkloadEnvironment>(
            value: value,
            groupValue: controller.selectedEnvironment.value,
            onChanged: controller.updateEnvironment,
            activeColor: AppStyles.radioActiveColor,
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return AppStyles.radioActiveColor; // Color of the dot
              }
              return AppStyles
                  .radioInactiveColor; // Color of the circle border when unselected
            }),
            visualDensity: const VisualDensity(
              horizontal: -4,
              vertical: -4,
            ), // Make radio smaller
          ),
          Text(title, style: AppStyles.bodyText),
        ],
      ),
    );
  }
}