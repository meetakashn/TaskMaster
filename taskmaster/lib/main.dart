import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmaster/taskadd/addtask.dart';

import 'edit task/edittask.dart';
import 'homepage/homepage.dart';
import 'utils/routes.dart';
import 'widgets/theme.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      child: MaterialApp(
        title: 'Task Master',
        themeMode: ThemeMode.light,
        theme: Mytheme.lighttheme(context),
        darkTheme: Mytheme.darktheme(context),
        debugShowCheckedModeBanner: false,
        initialRoute: MyRoutes.homepage,
        routes: {
          MyRoutes.homepage: (content) => const HomePage(),
          MyRoutes.addtask: (content) => const AddTask(),
        },
      ),
    );
  }
}