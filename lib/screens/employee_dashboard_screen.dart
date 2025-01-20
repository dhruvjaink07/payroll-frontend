import 'package:flutter/material.dart';
import 'package:payroll_app/screens/add_employee.dart';
import 'package:payroll_app/screens/attendance_screen.dart';
import 'package:payroll_app/screens/update_employee_screen.dart';

class EmployeeDashBoard extends StatefulWidget {
  const EmployeeDashBoard({super.key});

  @override
  _EmployeeDashBoardState createState() => _EmployeeDashBoardState();
}

class _EmployeeDashBoardState extends State<EmployeeDashBoard> {
  final List<Map<String, dynamic>> employees = [
    {
      "employeeId": 1,
      "firstName": "John",
      "lastName": "Doe",
      "designation": "Software Engineer",
      "department": "IT",
      "salary": 50000.00,
      "dateOfJoining": "2021-06-15"
    },
    {
      "employeeId": 2,
      "firstName": "Jane",
      "lastName": "Smith",
      "designation": "HR Manager",
      "department": "HR",
      "salary": 60000.00,
      "dateOfJoining": "2019-04-01"
    },
    {
      "employeeId": 3,
      "firstName": "Robert",
      "lastName": "Johnson",
      "designation": "Accountant",
      "department": "Finance",
      "salary": 55000.00,
      "dateOfJoining": "2020-08-10"
    },
    {
      "employeeId": 4,
      "firstName": "Emily",
      "lastName": "Davis",
      "designation": "Project Manager",
      "department": "IT",
      "salary": 70000.00,
      "dateOfJoining": "2018-03-23"
    },
    {
      "employeeId": 5,
      "firstName": "Michael",
      "lastName": "Miller",
      "designation": "System Analyst",
      "department": "IT",
      "salary": 65000.00,
      "dateOfJoining": "2021-02-10"
    },
    {
      "employeeId": 7,
      "firstName": "Emily",
      "lastName": "Jain",
      "designation": "Data Analyst",
      "department": "Analytics",
      "salary": 68000.00,
      "dateOfJoining": "2019-11-12"
    }
  ];

  void navigateToAddEmployeeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEmployeeScreen(),
      ),
    );
  }

  void navigateToUpdateEmployeeScreen(Map<String, dynamic> employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEmployeeScreen(employee: employee),
      ),
    );
  }

  void navigateToAttendanceScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScreen(employees: employees),
      ),
    );
  }

  void deleteEmployee(int employeeId) {
    setState(() {
      employees.removeWhere((employee) => employee['employeeId'] == employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
              onPressed: navigateToAttendanceScreen,
              icon: Icon(Icons.check_box)),
          IconButton(
              onPressed: navigateToAddEmployeeScreen,
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideContainers();
          } else {
            return _buildNarrowContainers();
          }
        },
      ),
    );
  }

  Widget _buildWideContainers() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3, // Adjusted aspect ratio for better view
        crossAxisSpacing: 20, // Added spacing between columns
        mainAxisSpacing: 20, // Added spacing between rows
      ),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return _buildEmployeeCard(employees[index]);
      },
    );
  }

  Widget _buildNarrowContainers() {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return _buildEmployeeCard(employees[index]);
      },
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return Card(
      elevation: 5, // Added shadow for elegance
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${employee['firstName'][0]}${employee['lastName'][0]}', // Initials as avatar
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${employee['firstName']} ${employee['lastName']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow
                        .ellipsis, // Prevents overflow if name is too long
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Designation: ${employee['designation']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Department: ${employee['department']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Salary: \$${employee['salary']}',
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Date of Joining: ${employee['dateOfJoining']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => navigateToUpdateEmployeeScreen(employee),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteEmployee(employee['employeeId']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
