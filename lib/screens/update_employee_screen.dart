import 'package:flutter/material.dart';
import 'package:payroll_app/model/Employee.dart';
import 'package:payroll_app/provider/employee_provider.dart';
import 'package:provider/provider.dart';

class UpdateEmployeeScreen extends StatelessWidget {
  final Employee employee;

  const UpdateEmployeeScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController =
        TextEditingController(text: employee.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: employee.lastName);
    final TextEditingController designationController =
        TextEditingController(text: employee.designation);
    final TextEditingController departmentController =
        TextEditingController(text: employee.department);
    final TextEditingController salaryController =
        TextEditingController(text: employee.salary.toString());
    final TextEditingController dateOfJoiningController =
        TextEditingController(text: employee.dateOfJoining);

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
                Employee newEmployee = Employee(
                    employeeId: employee.employeeId,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    designation: designationController.text,
                    department: departmentController.text,
                    salary: double.parse(salaryController.text),
                    dateOfJoining: dateOfJoiningController.text);

                Provider.of<EmployeeProvider>(context, listen: false)
                    .updateEmployee(newEmployee);
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
