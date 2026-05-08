import 'package:ciheapp/service/api/dropdownservice.dart';
import 'package:flutter/material.dart';

class PosDropdownProvider with ChangeNotifier {
  List<Map<String, dynamic>> _course = [];
  List<Map<String, dynamic>> _student = [];
  List<Map<String, dynamic>> _students = [];
  int? selectedCourseId;
  String? selectedCourseName;
 int? selectedstudentId;
 int? selectedstudentIds;

  List<Map<String, dynamic>> get course => _course;
  List<Map<String, dynamic>> get student => _student;
  List<Map<String, dynamic>> get students => _students;

  Future<void> fetchCourses() async {
    try {
      _course = await DropdownService.fetchCourseList();
      notifyListeners();
    } catch (error) {
      print("Error fetching course list: $error");
    }
  }
  Future<void> fetchCoursesList() async {
   try {
      _course = await DropdownService.fetchCourse();
      notifyListeners();
    } catch (error) {
      print("Error fetching course list: $error");
    }
  }

   Future<void> fetchStudents() async {
    try {
      _student = await DropdownService.fetchStudentList();
      notifyListeners();
    } catch (error) {
      print("Error fetching  student list: $error");
    }
  }
  Future<void> fetchStudentslist() async {
  try {
    final dropdownService = DropdownService();
    _students = (await dropdownService.getstudents())
        .map((user) => {'id': user.id, 'username': user.name})
        .toList();
    notifyListeners();
  } catch (error) {
    print("Error fetching student list: $error");
  }
}
  void setCourseType(String value) {
    final title = value.split('(')[0].trim(); 

    final selectedCourse = _course.firstWhere(
      (element) => element['name'] == title, 
      orElse: () => {},
    );

    if (selectedCourse.isNotEmpty) {
      selectedCourseId = selectedCourse['id'];
      notifyListeners();
    } else {
      print("Course not found for title: $title");
    }
  }
   void setCoursename(String value) {
    final title = value.split('(')[0].trim(); 

    final selectedCourse = _course.firstWhere(
      (element) => element['name'] == title, 
      orElse: () => {},
    );

    if (selectedCourse.isNotEmpty) {
      selectedCourseName = selectedCourse['name'];
      notifyListeners();
    } else {
      print("Course not found for title: $title");
    }
  }
  void setStudent(String value) {
    final title = value.split('(')[0].trim(); 

    final selectedStudent = _student.firstWhere(
      (element) => element['username'] == title, 
      orElse: () => {},
    );

    if (selectedStudent.isNotEmpty) {
      selectedstudentId = selectedStudent['id'];
      print("Selected Student ID: $selectedstudentId");
      notifyListeners();
    } else {
      print("student not found for title: $title");
    }
  }
  void setselectedStudent(String value) {
  final title = value.split('(')[0].trim();
  print("Looking for student with username: $title");

  final selectedStudent = students.firstWhere(
    (element) => element['username']?.toString().toLowerCase().trim() == title.toLowerCase(),
    orElse: () {
      print("No student matched with username: $title");
      return <String, Object>{};
    },
  );

  if (selectedStudent.isNotEmpty) {
    selectedstudentId = selectedStudent['id'] as int?;
    print("Selected Student ID set to: $selectedstudentId");
  } else {
    selectedstudentId = null;
    print("Selected student not found in list.");
  }

  notifyListeners();
}

  void clearSelections() {
    selectedCourseId = null;
    selectedstudentId = null;
    notifyListeners();
  }
}
