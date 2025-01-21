import 'package:flutter/material.dart';
import 'package:payroll_app/provider/attendance_provider.dart';
import 'package:payroll_app/provider/employee_provider.dart';
import 'package:payroll_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AttendanceProvider(context: context),
          child: const MyApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmployeeProvider(context: context),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow)
            .copyWith(secondary: Colors.amber),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
