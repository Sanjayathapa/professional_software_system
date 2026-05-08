import 'package:ciheapp/provider/api/announcementprovider.dart';
import 'package:ciheapp/provider/api/api_profile_provider.dart';
import 'package:ciheapp/provider/api/apiassignmentprovider.dart';
import 'package:ciheapp/provider/api/calendereventprovider.dart';
import 'package:ciheapp/provider/api/courseprovider.dart';
import 'package:ciheapp/provider/api/dashboardapiu_provider.dart';
import 'package:ciheapp/provider/api/dropdownprovider.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';
import 'package:ciheapp/provider/api/messageprovider.dart';
import 'package:ciheapp/provider/api/studentlist_provider.dart';
import 'package:ciheapp/provider/assignment.dart';

import 'package:ciheapp/provider/courses_provider.dart';

import 'package:ciheapp/provider/password_provider.dart';

import 'package:ciheapp/splashscreen.dart';
import 'package:ciheapp/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';




final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('ic_launcher'); // my  icon for the notification

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
        ChangeNotifierProvider(create: (_) =>PasswordVisibilityyProvider()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilitysProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => ProfilesProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider(),),
         ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_)=> MessagesProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
         ChangeNotifierProvider(create: (_) => EnrollmentProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => PosDropdownProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create:(_)=>AssignmentsProvider()),
         ChangeNotifierProvider(create:(_)=>StudentProvider()),
      ],
      child: MaterialApp(
        title: 'CIHE App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, //// if we want use the system theme then we can use ThemeMode.system
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

