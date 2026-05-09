
import 'package:flutter/material.dart';
import 'package:principles_ss/model/coursemodel.dart';
import 'package:principles_ss/service/api/courseservice.dart';

class CoursesProvider with ChangeNotifier {
  List<Courses> _courses = [];
  List<Courses> _filteredCourses = [];
  bool _isLoading = false;
  String? _error;
  Courses? _selectedCourse;
  String _searchQuery = '';

  List<Courses> get courses => _searchQuery.isEmpty ? _courses : _filteredCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Courses? get selectedCourse => _selectedCourse;

  final CoursesService _courseService = CoursesService();

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final courses = await _courseService.getCourses(); 
      _courses = courses;
      _filteredCourses = courses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
Future<void> fetchTeacherCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final courses = await _courseService.getTeacherCourses(); 
      _courses = courses;
      _filteredCourses = courses;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  void searchCourses(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses
          .where((course) => course.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
