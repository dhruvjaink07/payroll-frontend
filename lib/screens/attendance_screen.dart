import 'package:flutter/material.dart';
import 'package:payroll_app/model/Employee.dart';
import 'package:payroll_app/model/Attendance.dart';
import 'package:payroll_app/provider/attendance_provider.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  final List<Employee> employees;

  AttendanceScreen({required this.employees});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Attendance> attendanceData;

  @override
  void initState() {
    super.initState();
    initializeAttendanceData();
  }

  void initializeAttendanceData() {
    attendanceData = widget.employees.map((employee) {
      return Attendance(
        employeeId: employee.employeeId!,
        date: DateTime.now(),
        checkInTime: "09:00:00", // Default check-in time
        checkOutTime: "", // Default empty check-out time
        totalHoursWorked: 0.0,
        status: "Present",
        remarks: "Good",
      );
    }).toList();
  }

  void updateAttendanceField(int index, String field, dynamic value) {
    setState(() {
      final attendance = attendanceData[index];
      switch (field) {
        case 'checkInTime':
          attendanceData[index] = attendance.copyWith(checkInTime: value);
          break;
        case 'checkOutTime':
          attendanceData[index] = attendance.copyWith(checkOutTime: value);
          break;
        case 'status':
          attendanceData[index] = attendance.copyWith(status: value);
          break;
        case 'remarks':
          attendanceData[index] = attendance.copyWith(remarks: value);
          break;
      }
    });
  }

  void submitAttendance() {
    if (attendanceData
        .any((data) => data.checkInTime.isEmpty || data.checkOutTime.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all entries before submitting.'),
        ),
      );
      return;
    }

    final attendanceList = attendanceData.map((data) => data.toJson()).toList();
    Provider.of<AttendanceProvider>(context, listen: false)
        .addAttendanceData(attendanceData);
    print('Submitting Attendance: $attendanceList');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance recorded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: ListView.builder(
        itemCount: widget.employees.length,
        itemBuilder: (context, index) {
          final employee = widget.employees[index];
          final attendance = attendanceData[index];

          return AttendanceCard(
            employee: employee,
            attendance: attendance,
            onFieldUpdated: (field, value) =>
                updateAttendanceField(index, field, value),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitAttendance,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final Employee employee;
  final Attendance attendance;
  final Function(String field, dynamic value) onFieldUpdated;

  const AttendanceCard({
    required this.employee,
    required this.attendance,
    required this.onFieldUpdated,
  });

  Future<void> _pickTime(BuildContext context, String field) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      onFieldUpdated(field, formattedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${employee.firstName} ${employee.lastName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Designation: ${employee.designation}'),
            Text('Department: ${employee.department}'),
            const Divider(height: 16, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, 'checkInTime'),
                    child: TimeDisplayField(
                      label: 'Check-in',
                      time: attendance.checkInTime.isNotEmpty
                          ? attendance.checkInTime
                          : 'Not set',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context, 'checkOutTime'),
                    child: TimeDisplayField(
                      label: 'Check-out',
                      time: attendance.checkOutTime.isNotEmpty
                          ? attendance.checkOutTime
                          : 'Not set',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: attendance.status,
              onChanged: (value) {
                if (value != null) onFieldUpdated('status', value);
              },
              items: ['Present', 'Absent', 'On Leave']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) => onFieldUpdated('remarks', value),
              decoration: const InputDecoration(
                labelText: 'Remarks',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeDisplayField extends StatelessWidget {
  final String label;
  final String time;

  const TimeDisplayField({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(time, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
