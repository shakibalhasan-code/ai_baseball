import 'package:baseball_ai/core/utils/const/app_images.dart'; // Ensure this path is correct
import 'package:baseball_ai/core/utils/theme/app_styles.dart'; // Ensure this path is correct
import 'package:baseball_ai/views/features/boarding/controllers/boarding_controller.dart'; // Ensure this path is correct
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BoardingScreen extends StatelessWidget {
  // We still need the controller to trigger the dialog logic
  final BoardingController boardingController = Get.find<BoardingController>();

  BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No need for Obx or isShowLoadingSection here.
    // The logo and text are the static splash content.
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150.h, // Use ScreenUtil for size
                width: 150.w, // Use ScreenUtil for size
                child: ClipRRect(
                  child: Image.asset(AppImages.appLogo),
                ), // Load your logo
              ),
              SizedBox(height: 10.h),
              Text(
                'Prism',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.primaryColor,
                  fontSize: 40.sp, // Use ScreenUtil for font size
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.bungee().fontFamily,
                ),
              ),
              Text(
                'Sports Journal',
                style: AppStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp, // Use ScreenUtil for font size
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.workSans().fontFamily,
                ),
              ),
              // The CupertinoActivityIndicator is not in the final splash image sequence,
              // but you can keep it here if you want a brief loading indicator before the dialog.
              // If you want *only* the logo then the dialog, remove this.
              SizedBox(height: 30.h),
              CupertinoActivityIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
