import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:payroll_app/model/Attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:8080';
  List<Attendance> attendanceData = [];
  AttendanceProvider({required BuildContext context}) {
    getAttendanceData();
  }

  Future<void> getAttendanceData() async {
    try {
      final Response response = await _dio.get('$_baseUrl/attendance');
      attendanceData = (response.data as List)
          .map((json) => Attendance.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetching attendance data: $e');
    }
    notifyListeners();
  }

  Future<void> addAttendanceData(List<Attendance> attendances) async {
    try {
      final Response response =
          await _dio.post('$_baseUrl/attendance', data: attendances);
      if (response.statusCode == 200) {
        attendanceData = (response.data as List)
            .map((json) => Attendance.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error Recording Attendance $e');
    }
  }
}
