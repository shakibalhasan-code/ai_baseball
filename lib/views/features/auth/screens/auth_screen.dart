import 'package:baseball_ai/core/utils/const/app_images.dart';
import 'package:baseball_ai/core/utils/const/app_route.dart';
import 'package:baseball_ai/core/utils/theme/app_styles.dart';
import 'package:baseball_ai/views/features/auth/screens/intro_screen.dart';
import 'package:baseball_ai/views/glob_widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.h, // Use ScreenUtil for size
              width: 150.w, // Use ScreenUtil for size
              child: ClipRRect(
                child: Image.asset(AppImages.appLogo),
              ), // Load your logo
            ),

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
            SizedBox(height: 40),

            MyTextButton(
              isOutline: false,
              buttonText: 'Sign In',
              onTap: () => Get.toNamed(AppRoute.signIn),
            ),
            SizedBox(height: 10.h),
            MyTextButton(
              isOutline: true,
              buttonText: 'Sign Up',
              onTap: () => Get.to(IntroScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
