import 'package:baseball_ai/core/utils/const/app_pages.dart';
import 'package:baseball_ai/core/utils/const/app_route.dart';
import 'package:baseball_ai/core/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Baseball AI',
            theme: MyThemeData.theme,
            initialRoute: AppRoute.boarding,
            getPages: AppPages.app_pages,
          ),
    );
  }
}
