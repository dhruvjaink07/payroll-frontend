import 'package:flutter/material.dart';
import 'package:payroll_app/model/Employee.dart';
import 'package:payroll_app/provider/employee_provider.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _dateOfJoiningController =
      TextEditingController();

  String? _selectedDepartment;

  final List<String> _departments = ['HR', 'Engineering', 'Marketing', 'Sales'];

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDepartment = _departments.first;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfJoiningController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(
                  hintText: 'Enter Designation',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter designation';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departments
                    .map((department) => DropdownMenuItem<String>(
                          value: department,
                          child: Text(department),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  hintText: 'Enter Salary',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateOfJoiningController,
                decoration: const InputDecoration(
                  hintText: 'Select Date of Joining',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select date of joining';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Employee newEmployee = Employee(
                        employeeId: 0,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        designation: _designationController.text,
                        department: _selectedDepartment!,
                        salary: double.parse(_salaryController.text),
                        dateOfJoining: _dateOfJoiningController.text);
                    Provider.of<EmployeeProvider>(context, listen: false)
                        .addEmployee(newEmployee);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Employee added successfully')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _designationController.dispose();
    _salaryController.dispose();
    _dateOfJoiningController.dispose();
    super.dispose();
  }
}
