import 'package:ciheapp/model/assignment.dart';
import 'package:ciheapp/service/assignment_service.dart';
import 'package:flutter/material.dart';


class AssignmentProvider with ChangeNotifier {
  List<Assignment> _assignments = [];
  bool _isLoading = false;
  String? _error;
  Assignment? _selectedAssignment;

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Assignment? get selectedAssignment => _selectedAssignment;


  List<Assignment> get pendingAssignments => 
      _assignments.where((a) => a.status == AssignmentStatus.pending).toList();
  
  List<Assignment> get submittedAssignments => 
      _assignments.where((a) => a.status == AssignmentStatus.submitted || a.status == AssignmentStatus.graded).toList();
  
  List<Assignment> get lateAssignments => 
      _assignments.where((a) => a.status == AssignmentStatus.late).toList();

  final AssignmentService _assignmentService = AssignmentService();


  Future<void> fetchAssignments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignments = await _assignmentService.getAssignments();
      _assignments = assignments;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

 
  Future<void> fetchAssignmentById(String assignmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignment = await _assignmentService.getAssignmentById(assignmentId);
      _selectedAssignment = assignment;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  


  Future<bool> createAssignment({
    required String title,
    required String description,
    required DateTime dueDate,
    required String courseId,
    required String courseName,
    required int totalPoints,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final assignment = await _assignmentService.createAssignment(
        title: title,
        description: description,
        dueDate: dueDate,
        courseId: courseId,
        courseName: courseName,
        totalPoints: totalPoints,
      );
      
      _assignments.add(assignment);
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


  Future<bool> gradeAssignment({
    required String assignmentId,
    required int earnedPoints,
    required String feedback,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedAssignment = await _assignmentService.gradeAssignment(
        assignmentId: assignmentId,
        earnedPoints: earnedPoints,
        feedback: feedback,
      );
      

      final index = _assignments.indexWhere((a) => a.id == assignmentId);
      if (index != -1) {
        _assignments[index] = updatedAssignment;
      }
      
      _selectedAssignment = updatedAssignment;
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

