import 'package:ciheapp/model/course.dart';
import 'package:ciheapp/service/course_service.dart';
import 'package:flutter/material.dart';


class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  Course? _selectedCourse;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Course? get selectedCourse => _selectedCourse;

  final CourseService _courseService = CourseService();

 
  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final courses = await _courseService.getCourses();
      _courses = courses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }


  Future<void> fetchCourseById(String courseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final course = await _courseService.getCourseById(courseId);
      _selectedCourse = course;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

 
  Future<void> fetchCoursesByInstructor(String instructorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final courses = await _courseService.getCoursesByInstructor(instructorId);
      _courses = courses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

 
  Future<bool> createCourse({
    required String name,
    required String code,
    required String description,
    required String instructorId,
    required String instructorName,
    required int creditHours,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final course = await _courseService.createCourse(
        name: name,
        code: code,
        description: description,
        instructorId: instructorId,
        instructorName: instructorName,
        creditHours: creditHours,
      );
      
      _courses.add(course);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }


  Future<bool> enrollStudents(String courseId, List<String> studentIds) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedCourse = await _courseService.enrollStudents(courseId, studentIds);
      
  
      final index = _courses.indexWhere((c) => c.id == courseId);
      if (index != -1) {
        _courses[index] = updatedCourse;
      }
      
      _selectedCourse = updatedCourse;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }


  void clearError() {
    _error = null;
    notifyListeners();
  }
}

