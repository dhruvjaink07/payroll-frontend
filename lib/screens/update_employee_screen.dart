import 'package:flutter/material.dart';

class UpdateEmployeeScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  const UpdateEmployeeScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController =
        TextEditingController(text: employee['firstName']);
    final TextEditingController lastNameController =
        TextEditingController(text: employee['lastName']);
    final TextEditingController designationController =
        TextEditingController(text: employee['designation']);
    final TextEditingController departmentController =
        TextEditingController(text: employee['department']);
    final TextEditingController salaryController =
        TextEditingController(text: employee['salary'].toString());
    final TextEditingController dateOfJoiningController =
        TextEditingController(text: employee['dateOfJoining']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: designationController,
              decoration: const InputDecoration(labelText: 'Designation'),
            ),
            TextField(
              controller: departmentController,
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            TextField(
              controller: salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dateOfJoiningController,
              decoration: const InputDecoration(labelText: 'Date of Joining'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle update logic here
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
