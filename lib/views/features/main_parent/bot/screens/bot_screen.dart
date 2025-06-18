import 'package:baseball_ai/core/utils/const/app_icons.dart';
import 'package:baseball_ai/core/utils/theme/app_styles.dart';
// import 'package:baseball_ai/views/features/main_parent/home/sub_screens/notification_screen.dart';
import 'package:baseball_ai/views/features/main_parent/bot/controller/chat_controller.dart';
import 'package:baseball_ai/core/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late final ChatController chatController;

  // Define colors for easy reuse and modification
  static const Color darkBackground = Color(0xFF121212); // Very dark grey
  static const Color inputBackground = Color(
    0xFF3A3A3C,
  ); // Darker grey for input
  static const Color primaryYellow = Color(0xFFFFD60A); // Same yellow as before
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey; // Grey text

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
  }

  @override
  void dispose() {
    chatController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textPrimary),
          onPressed: () {
            // Handle back navigation
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'AI Chat',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true, // Center the title
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(
        //       right: 8.0,
        //     ), // Adjust padding slightly
        //     child: CircleAvatar(
        //       radius: 18,
        //       backgroundColor: inputBackground, // Use input bg for consistency
        //       child: IconButton(
        //         icon: const Icon(
        //           Icons.notifications_none_outlined,
        //           color: textPrimary,
        //           size: 22,
        //         ),
        //         onPressed: () {
        //           // Handle notification tap
        //           Get.to(NotificationScreen());
        //         },
        //         tooltip: 'Notifications', // Add tooltip for accessibility
        //         padding: EdgeInsets.zero, // Remove default padding
        //         constraints: const BoxConstraints(), // Remove constraints
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return _buildWelcomeScreen();
              }
              return _buildChatList();
            }),
          ),
          // Input field area at the bottom
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size column to its children
          children: [
            const Text(
              'Welcome to Your Personal',
              textAlign: TextAlign.center,
              style: TextStyle(color: textPrimary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: '"', // Opening quote
                style: const TextStyle(
                  color: primaryYellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Ask Coach PJ'), // Yellow text
                  const TextSpan(text: '"'), // Closing quote
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '"What\'s up Simi! What do you got today?"',
              textAlign: TextAlign.center,
              style: TextStyle(color: textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ListView.builder(
        controller: chatController.scrollController,
        itemCount: chatController.messages.length,
        itemBuilder: (context, index) {
          final message = chatController.messages[index];
          return _buildMessageBubble(message);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // Bot avatar
            CircleAvatar(
              radius: 16.r,
              backgroundColor: primaryYellow,
              child: Text(
                'PJ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ], // Message bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: message.isUser ? primaryYellow : inputBackground,
                borderRadius: BorderRadius.circular(16.r).copyWith(
                  bottomLeft:
                      message.isUser ? Radius.circular(16.r) : Radius.zero,
                  bottomRight:
                      message.isUser ? Radius.zero : Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isUser ? Colors.black : textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                  // Show download button if message contains a link
                  if (_containsLink(message.message) && !message.isUser) ...[
                    SizedBox(height: 8.h),
                    _buildLinkButton(_extractLink(message.message)),
                  ],
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8.w),
            // User avatar
            CircleAvatar(
              radius: 16.r,
              backgroundColor: inputBackground,
              child: Icon(Icons.person, color: textPrimary, size: 18.sp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            controller: chatController.messageController,
            scrollPadding: EdgeInsets.symmetric(horizontal: 10.w),
            style: AppStyles.bodySmall.copyWith(color: Colors.white),
            maxLines: null,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => chatController.sendMessage(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              hintText: 'Message with coach PJ...',
              hintStyle: AppStyles.bodySmall.copyWith(color: Colors.white),
              suffixIcon: Obx(
                () => IconButton(
                  onPressed:
                      chatController.isSending.value
                          ? null
                          : chatController.sendMessage,
                  icon:
                      chatController.isSending.value
                          ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : SvgPicture.asset(
                            AppIcons.send,
                            color: Colors.white,
                          ),
                ),
              ),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to check if message contains a link
  bool _containsLink(String message) {
    final urlRegExp = RegExp(r'https?://[^\s]+', caseSensitive: false);
    return urlRegExp.hasMatch(message);
  }

  // Helper method to extract the first link from message
  String _extractLink(String message) {
    final urlRegExp = RegExp(r'https?://[^\s]+', caseSensitive: false);
    final match = urlRegExp.firstMatch(message);
    return match?.group(0) ?? '';
  }

  // Widget to build the link button
  Widget _buildLinkButton(String url) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: ElevatedButton.icon(
        onPressed: () => _openLink(url),
        icon: Icon(Icons.download, size: 16.sp, color: Colors.black),
        label: Text(
          'Visit Link',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          minimumSize: Size(0, 32.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }

  // Method to open/launch the link
  Future<void> _openLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show error message if link can't be opened
        Get.snackbar(
          'Error',
          'Could not open the link',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Show error message if there's an exception
      Get.snackbar(
        'Error',
        'Invalid link format',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
