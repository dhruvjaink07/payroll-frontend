class Attendance {
  final int employeeId;
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final double totalHoursWorked;
  final String status;
  final String remarks;

  Attendance({
    required this.employeeId,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalHoursWorked,
    required this.status,
    required this.remarks,
  });

  // Factory method to create an instance from JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      employeeId: json['employeeId'] as int,
      date: DateTime.parse(json['date']),
      checkInTime: json['checkInTime'] as String,
      checkOutTime: json['checkOutTime'] as String,
      totalHoursWorked: (json['totalHoursWorked'] as num).toDouble(),
      status: json['status'] as String,
      remarks: json['remarks'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'totalHoursWorked': totalHoursWorked,
      'status': status,
      'remarks': remarks,
    };
  }

  // / Implementing copyWith method
  Attendance copyWith({
    int? employeeId,
    DateTime? date,
    String? checkInTime,
    String? checkOutTime,
    double? totalHoursWorked,
    String? status,
    String? remarks,
  }) {
    return Attendance(
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      totalHoursWorked: totalHoursWorked ?? this.totalHoursWorked,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
    );
  }
}
