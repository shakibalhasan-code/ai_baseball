import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:baseball_ai/core/utils/theme/app_styles.dart';
import 'package:baseball_ai/views/features/auth/controller/auth_controller.dart';
import 'package:baseball_ai/views/glob_widgets/my_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppStyles.cardColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          'Reset Password',
          style: AppStyles.bodyMedium.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Set your new password', style: AppStyles.bodyMedium),
                SizedBox(height: 8.h),
                Text(
                  'Enter your new password below',
                  style: AppStyles.bodySmall,
                ),
                SizedBox(height: 20.h),

                // New Password Field
                TextFormField(
                  controller: authController.newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  style: AppStyles.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 8.h),

                // Confirm Password Field
                TextFormField(
                  controller: authController.confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  style: AppStyles.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'Re-enter new password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != authController.newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                Obx(
                  () => MyTextButton(
                    buttonText:
                        authController.isResetPasswordLoading.value
                            ? 'Resetting...'
                            : 'Reset Now',
                    onTap:
                        authController.isResetPasswordLoading.value
                            ? () {}
                            : () => _handleResetPassword(
                              Get.arguments['resetCode'],
                            ),
                    isOutline: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetPassword(String? resetCode) {
    print('Reset Code: $resetCode');
    if (_formKey.currentState!.validate()) {
      authController.resetPassword(
        resetCode: resetCode ?? '',
        newPassword: authController.newPasswordController.text.trim(),
        confirmPassword: authController.confirmPasswordController.text.trim(),
      );
    }
  }
}
