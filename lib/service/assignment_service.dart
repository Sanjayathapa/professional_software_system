import 'package:ciheapp/model/assignment.dart';



class AssignmentService {
 
 final List<Assignment> _mockAssignments = [
  Assignment(
    id: '1',
    title: 'Cloud Service Comparison Report',
    description: 'Compare AWS, Azure, and Google Cloud based on services and pricing.',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    courseId: 'COURSE1',
    courseName: 'Cloud Computing',
    totalPoints: 100,
    status: AssignmentStatus.pending,
  ),
  Assignment(
    id: '2',
    title: 'Software Development Life Cycle Analysis',
    description: 'Write a report on various SDLC models and their pros & cons.',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    courseId: 'COURSE2',
    courseName: 'Software Engineering',
    totalPoints: 80,
    status: AssignmentStatus.pending,
  ),
  Assignment(
    id: '3',
    title: 'OS Scheduling Algorithms',
    description: 'Implement FCFS, SJF, and Round Robin scheduling in any language.',
    dueDate: DateTime.now().subtract(const Duration(days: 2)),
    courseId: 'COURSE3',
    courseName: 'Operating Systems',
    totalPoints: 90,
    status: AssignmentStatus.late,
  ),
  Assignment(
    id: '4',
    title: 'Database ER Diagram Design',
    description: 'Design an ER diagram for a hospital management system.',
    dueDate: DateTime.now().subtract(const Duration(days: 5)),
    courseId: 'COURSE4',
    courseName: 'Database Management Systems',
    totalPoints: 100,
    status: AssignmentStatus.submitted,
    submissionDate: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Assignment(
    id: '5',
    title: 'Build a Flutter App',
    description: 'Create a mobile app using Flutter to manage daily tasks.',
    dueDate: DateTime.now().subtract(const Duration(days: 10)),
    courseId: 'COURSE5',
    courseName: 'Mobile App Development',
    totalPoints: 100,
    status: AssignmentStatus.graded,
    earnedPoints: 92,
    submissionDate: DateTime.now().subtract(const Duration(days: 11)),
    feedback: 'Excellent work! Smooth UI and good state management.',
  ),
];


  
  Future<List<Assignment>> getAssignments() async {
  
    await Future.delayed(const Duration(seconds: 1));
    
   
    return _mockAssignments;
  }


  Future<Assignment?> getAssignmentById(String assignmentId) async {
  
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mockAssignments.firstWhere((a) => a.id == assignmentId);
    } catch (e) {
      return null;
    }
  }

 
  Future<Assignment> submitAssignment(String assignmentId, String submissionUrl) async {
   
    await Future.delayed(const Duration(seconds: 1));
    
   
    final index = _mockAssignments.indexWhere((a) => a.id == assignmentId);
    if (index == -1) {
      throw Exception('Assignment not found');
    }
    
    final assignment = _mockAssignments[index];
    final updatedAssignment = Assignment(
      id: assignment.id,
      title: assignment.title,
      description: assignment.description,
      dueDate: assignment.dueDate,
      courseId: assignment.courseId,
      courseName: assignment.courseName,
      totalPoints: assignment.totalPoints,
      status: AssignmentStatus.submitted,
      submissionUrl: submissionUrl,
      submissionDate: DateTime.now(),
    );
    
    _mockAssignments[index] = updatedAssignment;
    return updatedAssignment;
  }

  
  Future<Assignment> createAssignment({
    required String title,
    required String description,
    required DateTime dueDate,
    required String courseId,
    required String courseName,
    required int totalPoints,
  }) async {
    
    await Future.delayed(const Duration(seconds: 1));
    
  
    final assignment = Assignment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      courseId: courseId,
      courseName: courseName,
      totalPoints: totalPoints,
      status: AssignmentStatus.pending,
    );
    
    _mockAssignments.add(assignment);
    return assignment;
  }


  Future<Assignment> gradeAssignment({
    required String assignmentId,
    required int earnedPoints,
    required String feedback,
  }) async {
  
    await Future.delayed(const Duration(seconds: 1));
    
 
    final index = _mockAssignments.indexWhere((a) => a.id == assignmentId);
    if (index == -1) {
      throw Exception('Assignment not found');
    }
    
    final assignment = _mockAssignments[index];
    final updatedAssignment = Assignment(
      id: assignment.id,
      title: assignment.title,
      description: assignment.description,
      dueDate: assignment.dueDate,
      courseId: assignment.courseId,
      courseName: assignment.courseName,
      totalPoints: assignment.totalPoints,
      status: AssignmentStatus.graded,
      earnedPoints: earnedPoints,
      submissionUrl: assignment.submissionUrl,
      submissionDate: assignment.submissionDate,
      feedback: feedback,
    );
    
    _mockAssignments[index] = updatedAssignment;
    return updatedAssignment;
  }
}

