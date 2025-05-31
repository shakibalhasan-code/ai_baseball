import 'package:baseball_ai/core/models/chart_data.dart';
import 'package:baseball_ai/core/utils/const/app_icons.dart';
import 'package:baseball_ai/core/utils/const/app_images.dart';
import 'package:baseball_ai/core/utils/const/app_route.dart';
import 'package:baseball_ai/views/features/auth/controller/auth_controller.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/notification_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/performance/performance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:baseball_ai/core/utils/image_utils.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Define colors for easy reuse and modification
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF2C2C2E);
  static const Color primaryYellow = Color(0xFFFFD60A);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color greenCheck = Colors.green;
  static const Color redCross = Colors.red;
  static const Color pillarFocusBg = Color(0xFF4A4A4A);
  static const Color pillarConsistencyBg = Color(0xFF2E7D32);
  static const Color pillarGritBg = Color(0xFFC62828);
  static const Color chartContainerBackground = Color(0xFF1A1A1A);
  static const Color chartBackground = Colors.transparent;
  
  final authController = Get.find<AuthController>();
  
  // Add observable for view toggle
  final RxBool isWeeklyView = true.obs;

  @override
  Widget build(BuildContext context) {
    authController.loadProgress();
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: cardBackground,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 5.h),
          child: Obx(() {
            final user = authController.currentUser.value;
            return CircleAvatar(
              radius: 25,
              backgroundImage: user?.image != null && user!.image!.isNotEmpty
                  ? NetworkImage(ImageUtils.getProfileImageUrl(user.image!))
                  : AssetImage(AppImages.defaultProfileImage) as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Failed to load profile image: $exception');
              },
            );
          }),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'hey 👋,',
              style: TextStyle(color: textSecondary, fontSize: 16),
            ),
            Text(
              'Good Morning',
              style: TextStyle(
                color: textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: cardBackground,
              child: IconButton(
                icon: SvgPicture.asset(AppIcons.bell, color: Colors.white),
                onPressed: () {
                  Get.to(NotificationScreen());
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompletionSection(),
              const SizedBox(height: 24),
              _buildVisualizationCard(),
              const SizedBox(height: 24),
              _buildCorePillars(),
              const SizedBox(height: 24),
              _buildDailyCheckinCard(),
              const SizedBox(height: 24),
              _buildQuickAccessButtons(),
              const SizedBox(height: 24),
              _buildOverviewSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCompletionSection() {
    return Obx(
       () {
        bool wellnessLogResponse = (authController.dailyLogResponse.value.data?.dailyWellnessQuestionnaire?.isBlank ?? true)?
            false : true;
        bool throwingJournalResponse = (authController.dailyLogResponse.value.data?.throwingJournal?.isBlank ?? true)?
            false : true;
        bool armCareResponse = (authController.dailyLogResponse.value.data?.armCare?.isBlank ?? true)?
            false : true;


        double _percantageCalculation() {
          int completedTasks = 0;
          if (wellnessLogResponse) completedTasks++;
          if (throwingJournalResponse) completedTasks++;
          if (armCareResponse) completedTasks++;

          double percentage = completedTasks / 3; // Total tasks = 3
          return percentage;
        }
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Completion",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTaskItem('Wellness Log', wellnessLogResponse),
                    const SizedBox(height: 8),
                    _buildTaskItem('Throwing Journal', throwingJournalResponse),
                    const SizedBox(height: 8),
                     _buildTaskItem('Arm Care', armCareResponse),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 10.0,
                percent: _percantageCalculation(),
                center:  Text(
                  '${(_percantageCalculation() * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: textPrimary,
                  ),
                ),
                progressColor: primaryYellow,
                backgroundColor: Colors.grey.shade700,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildTaskItem(String title, bool completed) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: completed ? greenCheck : redCross,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: textPrimary, fontSize: 14)),
      ],
    );
  }

  Widget _buildVisualizationCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_pin_circle_outlined,
                color: primaryYellow,
                size: 24,
              ), // Example icon
              SizedBox(width: 8),
              Text(
                "Visualization",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Time to start visualizing for success – make this a daily habit to lock in your focus, sharpen your concentration, and gear up for peak performance. Experience a 10-minute guided visualization that primes you mentally and readies you to compete at your very best on the field.',
            style: TextStyle(color: textSecondary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryYellow,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoute.visualation);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorePillars() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Core Pillars",
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
              () {
                  return _buildPillarChip(
                   authController.currentUser.value?.threeWordThtDescribeYou.split(',').first.capitalize ??'Focus',
                    Icons.track_changes,
                    pillarFocusBg,
                  );
                }
              ), // Example Icon
              Obx(
                () {
                  return _buildPillarChip(
                   authController.currentUser.value?.threeWordThtDescribeYou.split(',')[1].capitalize ?? 'Consistency',
                    Icons.sync_alt,
                    pillarConsistencyBg,
                  );
                }
              ), // Example Icon
              Obx(
                () {
                  return _buildPillarChip(
                   authController.currentUser.value?.threeWordThtDescribeYou.split(',')[2].capitalize ?? 'Grit',
                    Icons.whatshot,
                    pillarGritBg,
                  );
                }
              ), // Example Icon
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillarChip(String label, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.8), // Slightly transparent bg
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textPrimary, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyCheckinCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Check-In",
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'This short survey is designed to track how you\'re feeling day in and day out in order to establish a baseline of how you\'re feeling overall. From there, we can identify when changes need to be made or simply stay the course.',
            style: TextStyle(color: textSecondary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryYellow,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () {
                // Handle Let's Go tap
                Get.toNamed(AppRoute.dailyShort);
              },
              child: const Text(
                "Let's Go",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButtons() {
    // Define a width for each button. Adjust this value as needed.
    // A fixed pixel width is common for scrollable lists.
    final double buttonWidth = 108.0.w; // Example width
    final double buttonHeight = 108.0.h; // Example width

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // mainAxisAlignment won't have much effect if the total width
        // of children exceeds the screen width, as the Row will be wider.
        // If the total width is less than screen width, it will work.
        // Keep it if you want spacing when the list isn't full screen.
        mainAxisAlignment:
            MainAxisAlignment.start, // or MainAxisAlignment.spaceBetween
        crossAxisAlignment: CrossAxisAlignment.start, // Align items nicely
        children: [
          // Removed Expanded, wrapped in SizedBox to give a fixed width
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,
            child: buildAccessButton(
              'Throwing\nJournal',
              AppIcons.throwIcon,
              () => Get.toNamed(AppRoute.homethrowing),
            ),
          ),
          const SizedBox(width: 12), // Spacer between buttons
          // Removed Expanded, wrapped in SizedBox
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,

            child: buildAccessButton(
              'Arm Care',
              AppIcons.arm,
              () => Get.toNamed(AppRoute.armCare),
            ),
          ),
          const SizedBox(width: 12), // Spacer
          // Removed Expanded, wrapped in SizedBox
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,

            child: buildAccessButton(
              'Lifting Log',
              AppIcons.lifting,
              () => Get.toNamed(AppRoute.lifting),
            ),
          ),
          const SizedBox(width: 12), // Spacer
          // Removed Expanded, wrapped in SizedBox
          SizedBox(
            width: buttonWidth,
            height: buttonHeight,

            child: buildAccessButton(
              'Hitting Journal',
              AppIcons
                  .hitingJournal, // Using AppIcons.lifting for Hitting Journal? Check this icon.
              () => Get.toNamed(AppRoute.hitingJournal),
            ),
          ),
          // Add more buttons and spacers as needed
          // const SizedBox(width: 12),
          // SizedBox(...),
        ],
      ),
    );
  }

  Widget buildAccessButton(String label, String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 104.h,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: primaryYellow,
              height: 30.h,
              width: 30.w,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return InkWell(
      onTap: () => Get.to(PerformanceScreen(isWeeklyView: isWeeklyView.value,)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  isWeeklyView.value ? "Last 7 Days Overview" : "Last 30 Days Overview",
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Row(
                  children: [
                    // Toggle Switch
                    Obx(() => _buildViewToggle()),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () => Get.to(PerformanceScreen(isWeeklyView: isWeeklyView.value)),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          color: primaryYellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildChartPreview(
                    'Hydration',
                    isWeeklyView.value ? _getWeeklyChartData1() : _getMonthlyChartData1(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildChartPreview(
                    'Soreness',
                    isWeeklyView.value ? _getWeeklyChartData2() : _getMonthlyChartData2(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildChartPreview(
                    'Bullpen Volume',
                    isWeeklyView.value ? _getWeeklyChartData3() : _getMonthlyChartData3(),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => isWeeklyView.value = true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isWeeklyView.value ? primaryYellow : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '7D',
                style: TextStyle(
                  color: isWeeklyView.value ? Colors.black : textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => isWeeklyView.value = false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: !isWeeklyView.value ? primaryYellow : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '30D',
                style: TextStyle(
                  color: !isWeeklyView.value ? Colors.black : textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPreview(String title, List<ChartData> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: chartContainerBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              primaryYAxis: NumericAxis(
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.zero,
              backgroundColor: chartBackground,
              series: <CartesianSeries<ChartData, double>>[
                SplineAreaSeries<ChartData, double>(
                  dataSource: data,
                  xValueMapper: (ChartData sales, _) => sales.x,
                  yValueMapper: (ChartData sales, _) => sales.y,
                  borderColor: primaryYellow,
                  borderWidth: 2,
                  gradient: LinearGradient(
                    colors: [
                      primaryYellow.withOpacity(0.7),
                      primaryYellow.withOpacity(0.3),
                      primaryYellow.withOpacity(0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Sample data methods - replace with your actual data
  List<ChartData> _getWeeklyChartData1() {
    return [
      ChartData(1, 3),
      ChartData(2, 5),
      ChartData(3, 4),
      ChartData(4, 7),
      ChartData(5, 6),
      ChartData(6, 8),
      ChartData(7, 5),
    ];
  }

  List<ChartData> _getMonthlyChartData1() {
    return [
      ChartData(1, 4),
      ChartData(5, 6),
      ChartData(10, 5),
      ChartData(15, 8),
      ChartData(20, 7),
      ChartData(25, 6),
      ChartData(30, 9),
    ];
  }

  List<ChartData> _getWeeklyChartData2() {
    return [
      ChartData(1, 2),
      ChartData(2, 3),
      ChartData(3, 1),
      ChartData(4, 4),
      ChartData(5, 3),
      ChartData(6, 2),
      ChartData(7, 1),
    ];
  }

  List<ChartData> _getMonthlyChartData2() {
    return [
      ChartData(1, 3),
      ChartData(5, 2),
      ChartData(10, 4),
      ChartData(15, 1),
      ChartData(20, 3),
      ChartData(25, 2),
      ChartData(30, 1),
    ];
  }

  List<ChartData> _getWeeklyChartData3() {
    return [
      ChartData(1, 20),
      ChartData(2, 35),
      ChartData(3, 30),
      ChartData(4, 45),
      ChartData(5, 40),
      ChartData(6, 50),
      ChartData(7, 35),
    ];
  }

  List<ChartData> _getMonthlyChartData3() {
    return [
      ChartData(1, 25),
      ChartData(5, 40),
      ChartData(10, 35),
      ChartData(15, 55),
      ChartData(20, 45),
      ChartData(25, 50),
      ChartData(30, 60),
    ];
  }
}
