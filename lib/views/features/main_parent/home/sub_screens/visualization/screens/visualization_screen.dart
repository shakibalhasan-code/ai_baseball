import 'package:baseball_ai/views/features/main_parent/home/sub_screens/notification_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/visualization/controller/visualization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // If using screenutil
import 'dart:math' as math; // For pi in CustomPainter
import 'package:get/get.dart'; // Import GetX

// --- Keep Color Constants ---
const Color kBackgroundColor = Color(0xFF121212);
const Color kAppBarColor = Color(0xFF1E1E1E);
const Color kCardColor = Color(0xFF2A2A2A);
const Color kPrimaryYellow = Color(0xFFFFD700);
const Color kTextColor = Colors.white;
const Color kSubtitleColor = Colors.grey;
const Color kControlIconColor = Colors.white;
const Color kControlBackgroundColor = Color(0xFF2C2C2E);
// --- ---

class VisualizationScreen extends StatelessWidget {
  final VisualizationController controller =
      Get.find<VisualizationController>();

  VisualizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: kTextColor, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Visualization',
          style: TextStyle(
            color: kTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: kTextColor,
              size: 24.sp,
            ),
            onPressed: () {
              Get.to(NotificationScreen());
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25.h),
            Text(
              'A 10-minute guided visualization to improve focus and mental preparedness',
              style: TextStyle(
                color: kSubtitleColor,
                fontSize: 15.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Box Breathing',
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Text(
                //   controller.remainingBoxTime,
                //   style: TextStyle(
                //     color: kPrimaryYellow,
                //     fontSize: 15.sp,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 40.h),

            // --- Reactive Circular Timer ---
            Center(
              child: SizedBox(
                width: 220.sp,
                height: 220.sp,
                child: Obx(
                  () => Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: CircularTimerPainter(
                          progress: controller.progress,
                          backgroundColor: kControlBackgroundColor,
                          progressColor: kPrimaryYellow,
                          strokeWidth: 14.sp,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.formattedTime,
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                '${controller.currentSession} of ${controller.totalSessions} sessions',
                                style: TextStyle(
                                  color: kSubtitleColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Show saving overlay when saving
                      if (controller.isSaving.value)
                        Container(
                          width: 220.sp,
                          height: 220.sp,
                          decoration: BoxDecoration(
                            color: kBackgroundColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30.sp,
                                  height: 30.sp,
                                  child: CircularProgressIndicator(
                                    color: kPrimaryYellow,
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  controller.savingMessage.value,
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Focus:',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Breathe in for 4 counts, hold for 4, exhale for 4, hold for 4. Repeat.',
                    style: TextStyle(
                      color: kSubtitleColor,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // --- Reactive Control Buttons ---
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: Icons.refresh,
                    onPressed: controller.restartTimer,
                  ),
                  Obx(
                    () => _buildControlButton(
                      icon:
                          controller.isRunning.value
                              ? Icons.pause
                              : Icons.play_arrow,
                      onPressed:
                          controller.isSaving.value
                              ? () {}
                              : controller.togglePlayPause,
                      isPrimary: true,
                      isDisabled: controller.isSaving.value,
                    ),
                  ),
                  _buildControlButton(
                    icon: Icons.stop,
                    onPressed: controller.stopTimer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
    bool isDisabled = false,
  }) {
    final double buttonSize = isPrimary ? 65.sp : 55.sp;
    final Color backgroundColor =
        isPrimary
            ? (isDisabled ? kPrimaryYellow.withOpacity(0.5) : kPrimaryYellow)
            : kControlBackgroundColor;
    final Color iconColor = isPrimary ? kBackgroundColor : kControlIconColor;

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        fixedSize: Size(buttonSize, buttonSize),
        elevation: 2,
      ),
      child: Icon(icon, size: isPrimary ? 35.sp : 28.sp),
    );
  }
}

// Keep the Custom Painter (no changes needed here)
class CircularTimerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularTimerPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress; // Progress determines the sweep
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularTimerPainter oldDelegate) {
    // More efficient repaint check
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
