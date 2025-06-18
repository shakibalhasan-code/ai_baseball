import 'dart:io'; // Import for File type

import 'package:baseball_ai/core/utils/const/app_icons.dart';
import 'package:baseball_ai/core/utils/const/app_images.dart';
import 'package:baseball_ai/core/utils/image_utils.dart';
import 'package:baseball_ai/core/utils/theme/app_styles.dart';
import 'package:baseball_ai/views/features/main_parent/profile/controller/profile_controller.dart';
import 'package:baseball_ai/views/features/main_parent/profile/screens/edit_profile.dart';
import 'package:baseball_ai/views/features/main_parent/profile/screens/privacy_policy.dart';
import 'package:baseball_ai/views/features/auth/controller/auth_controller.dart';
import 'package:baseball_ai/views/glob_widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// A screen displaying the user's profile information and options.
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Use Get.find if the controller is already initialized elsewhere (e.g., Binding)
  // Or use Get.put if this is the first place it's needed.
  // Assuming it's put here for simplicity based on original code.
  final ProfileController controller = Get.put(ProfileController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: [
              // ======== Profile Picture Section ========
              _buildProfilePicture(),
              SizedBox(height: 10.h), // Add space after picture
              // ======== User Info Section (Name & Email) ========
              _buildUserInfo(),
              SizedBox(height: 20.h), // Add space after user info
              // ======== Divider ========
              const Divider(),
              SizedBox(height: 20.h), // Add space after divider
              // ======== Profile Options List ========
              Expanded(
                // Use Expanded to push options down or manage space
                child: ListView(
                  // Use ListView for scrollability if options grow
                  padding: EdgeInsets.zero, // Remove default ListView padding
                  children: [
                    _buildProfileOption(
                      icon: const Icon(
                        Icons.person_3_outlined,
                        color: Colors.white,
                      ),
                      title: "Edit Profile",
                      ontap: () => Get.to(() => EditProfile()),
                    ),
                    _buildProfileOption(
                      icon: SvgPicture.asset(
                        AppIcons.passIcon,
                        color: Colors.white,
                        width: 24.w,
                        height: 24.h,
                      ), // Explicit size for SVG
                      title: "Privacy Policy",
                      ontap: () => Get.to(() => PrivacyPolicyScreen()),
                    ),
                    // _buildProfileOption(
                    //   icon: SvgPicture.asset(
                    //     AppIcons.logout,
                    //     color: Colors.red,
                    //     width: 24.w,
                    //     height: 24.h,
                    //   ), // Explicit size for SVG
                    //   title: "Logout",
                    //   hasLast: false, // No trailing icon for logout
                    //   ontap: () => _showLogoutDialog(),
                    // ),
                    _buildProfileOption(
                      icon: SvgPicture.asset(
                        AppIcons.logout,
                        color: Colors.red,
                        width: 24.w,
                        height: 24.h,
                      ), // Explicit size for SVG
                      title: "Logout",
                      hasLast: false, // No trailing icon for logout
                      ontap: () => showLogOutSheet(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the profile picture area with image selection functionality.
  Widget _buildProfilePicture() {
    return Obx(() {
      final pickedImage = controller.pickedImage.value;
      final user = authController.currentUser.value;

      return InkWell(
        // onTap: () async {
        //   await controller.pickImage();
        // },
        borderRadius: BorderRadius.circular(100.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppStyles.primaryColor, width: 2),
                color: AppStyles.cardColor,
              ),
              child: ClipOval(
                child:
                    pickedImage != null
                        ? Image.file(File(pickedImage.path), fit: BoxFit.cover)
                        : user?.image != null && user!.image!.isNotEmpty
                        ? Image.network(
                          ImageUtils.getProfileImageUrl(user.image!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.avatarLogo,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(AppImages.avatarLogo, fit: BoxFit.cover),
              ),
            ),

            // Positioned edit icon
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     padding: EdgeInsets.all(5.w),
            //     decoration: BoxDecoration(
            //       color: AppStyles.primaryColor,
            //       shape: BoxShape.circle,
            //       border: Border.all(
            //         color: AppStyles.backgroundColor,
            //         width: 2,
            //       ),
            //     ),
            //     child: Icon(
            //       Icons.edit,
            //       color: Colors.white,
            //       size: 18.w,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  /// Builds the user's name and email display section.
  Widget _buildUserInfo() {
    return Obx(() {
      final user = authController.currentUser.value;
      String fullName = 'John David'; // Default fallback

      if (user != null) {
        // If firstName and lastName are available, use them
        if (user.firstName != null && user.lastName != null) {
          fullName = '${user.firstName!} ${user.lastName!}'.trim();
        } else {
          // Use the name field directly if available
          fullName = user.name.isNotEmpty ? user.name : 'User';
        }
      }

      final email = user?.email ?? 'john@gmail.com';

      return Column(
        children: [
          Text(
            fullName.isNotEmpty ? fullName : 'User',
            style: AppStyles.headingLarge,
          ),
          SizedBox(height: 4.h),
          Text(
            email,
            style: AppStyles.bodySmall.copyWith(color: AppStyles.primaryColor),
          ),
        ],
      );
    });
  }

  /// Builds a single row for a profile option.
  Widget _buildProfileOption({
    required Widget icon,
    required String title,
    required VoidCallback ontap,
    bool hasLast = true, // Whether to show the trailing arrow
  }) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        leading: SizedBox(
          width: 24.w,
          height: 24.h,
          child: Center(child: icon),
        ), // Ensure leading icon has space and is centered
        title: Text(title, style: AppStyles.bodySmall),
        trailing:
            hasLast
                ? Icon(
                  Icons.chevron_right_outlined,
                  size: 30.w, // Scaled icon size
                  color: Colors.white,
                )
                : null, // No trailing icon if hasLast is false
        contentPadding: EdgeInsets.zero, // Remove default ListTile padding
        dense: true, // Make the list tile a bit more compact
      ),
    );
  }

  Future<void> showLogOutSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppStyles.primaryColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppStyles.secondaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppStyles.hintTextColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Logout',
                style: AppStyles.headingLarge.copyWith(
                  color: Colors.red,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Divider(thickness: 1, color: AppStyles.hintTextColor),
              SizedBox(height: 15.h),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppStyles.backgroundColor,
                        ), // Blue outline
                        backgroundColor: Colors.white, // White background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            24.r,
                          ), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.black, // Blue text
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: MyTextButton(
                      buttonText: 'Yes, Logout',
                      onTap: () {
                        Get.back();
                        authController.logout();
                      },
                      isOutline: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
