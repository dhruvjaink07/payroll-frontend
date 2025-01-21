import 'package:flutter/material.dart';
import 'package:payroll_app/model/Employee.dart';

class AttendanceScreen extends StatefulWidget {
  final List<Employee> employees;

  AttendanceScreen({required this.employees});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    attendanceData = widget.employees
        .map((employee) => {
              'employeeId': employee.employeeId,
              'checkInTime': const TimeOfDay(hour: 9, minute: 0),
              'checkOutTime': null,
              'status': 'Present',
              'remarks': '',
            })
        .toList();
  }

  void updateAttendance(int index, String field, dynamic value) {
    setState(() {
      attendanceData[index][field] = value;
    });
  }

  void submitAllAttendance() {
    // Check if all fields are filled
    if (attendanceData.any((data) =>
        data['checkInTime'] == null || data['checkOutTime'] == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all entries before submitting.'),
        ),
      );
      return;
    }

    // Convert attendance data to a format suitable for database insertion
    final attendanceList = attendanceData.map((data) {
      return {
        'employeeId': data['employeeId'],
        'date': DateTime.now().toIso8601String(),
        'checkInTime': (data['checkInTime'] as TimeOfDay).format(context),
        'checkOutTime': (data['checkOutTime'] as TimeOfDay).format(context),
        'status': data['status'],
        'remarks': data['remarks'],
      };
    }).toList();

    // Send attendanceList to the backend API
    // Example: http.post('your_api_endpoint', body: json.encode(attendanceList));

    print(
        'Attendance List: $attendanceList'); // Debugging: Check the generated data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All attendance recorded successfully!')),
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
          final data = attendanceData[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${employee.firstName} ${employee.lastName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Designation: ${employee.designation}'),
                  Text('Department: ${employee.department}'),
                  const Divider(height: 16, thickness: 1),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 9, minute: 0),
                            );
                            if (picked != null) {
                              updateAttendance(index, 'checkInTime', picked);
                            }
                          },
                          child: buildTimeField(
                            label: 'Check-in',
                            time: data['checkInTime'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              updateAttendance(index, 'checkOutTime', picked);
                            }
                          },
                          child: buildTimeField(
                            label: 'Check-out',
                            time: data['checkOutTime'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: data['status'],
                    onChanged: (value) {
                      if (value != null)
                        updateAttendance(index, 'status', value);
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
                    onChanged: (value) =>
                        updateAttendance(index, 'remarks', value),
                    decoration: const InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitAllAttendance,
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget buildTimeField({required String label, TimeOfDay? time}) {
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
          Text(
            time != null ? time.format(context) : 'Not set',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
