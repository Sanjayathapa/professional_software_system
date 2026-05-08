import 'package:ciheapp/model/course.dart';


class CourseService {

 final List<Course> _mockCourses = [
  Course(
    id: 'COURSE1',
    name: 'Cloud Computing',
    code: 'CLOUD101',
    description: 'Learn about IaaS, PaaS, SaaS, virtualization, and cloud service providers.',
    instructorId: 'FACULTY1',
    instructorName: 'Ali Cheraghian',
    creditHours: 3,
    enrolledStudentIds: ['STUDENT1', 'STUDENT2', 'STUDENT3'],
  ),
  Course(
    id: 'COURSE2',
    name: 'Software Engineering',
    code: 'ICT206',
    description: 'Study software development lifecycle, design principles, and agile methodologies.',
    instructorId: 'FACULTY2',
    instructorName: 'Ambikesh Jayal',
    creditHours: 4,
    enrolledStudentIds: ['STUDENT1', 'STUDENT4', 'STUDENT5'],
  ),
  Course(
    id: 'COURSE3',
    name: 'Data Structures & Algorithms',
    code: 'ICT208',
    description: 'In-depth study of arrays, stacks, queues, trees, and sorting/searching algorithms.',
    instructorId: 'FACULTY3',
    instructorName: 'Mutaz Barika',
    creditHours: 4,
    enrolledStudentIds: ['STUDENT1', 'STUDENT2', 'STUDENT6'],
  ),
  Course(
    id: 'COURSE4',
    name: 'Mobile App Development',
    code: 'ICT202',
    description: 'Design and build apps using Flutter and Firebase.',
    instructorId: 'FACULTY4',
    instructorName: 'Ayaz Rahman',
    creditHours: 3,
    enrolledStudentIds: ['STUDENT1', 'STUDENT7', 'STUDENT8'],
  ),
];



  Future<List<Course>> getCourses() async {
  
    await Future.delayed(const Duration(seconds: 1));
    
  
    return _mockCourses;
  }

  Future<Course?> getCourseById(String courseId) async {
 
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mockCourses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

 
  Future<List<Course>> getCoursesByInstructor(String instructorId) async {
    
    await Future.delayed(const Duration(seconds: 1));
    
    return _mockCourses.where((c) => c.instructorId == instructorId).toList();
  }

 
  Future<Course> createCourse({
    required String name,
    required String code,
    required String description,
    required String instructorId,
    required String instructorName,
    required int creditHours,
  }) async {
    
    await Future.delayed(const Duration(seconds: 1));
    
    final course = Course(
      id: 'COURSE${_mockCourses.length + 1}',
      name: name,
      code: code,
      description: description,
      instructorId: instructorId,
      instructorName: instructorName,
      creditHours: creditHours,
      enrolledStudentIds: [],
    );
    
    _mockCourses.add(course);
    return course;
  }

 
  Future<Course> enrollStudents(String courseId, List<String> studentIds) async {
   
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _mockCourses.indexWhere((c) => c.id == courseId);
    if (index == -1) {
      throw Exception('Course not found');
    }
    
    final course = _mockCourses[index];
    final updatedEnrolledStudentIds = [...course.enrolledStudentIds, ...studentIds];
    
    final updatedCourse = Course(
      id: course.id,
      name: course.name,
      code: course.code,
      description: course.description,
      instructorId: course.instructorId,
      instructorName: course.instructorName,
      creditHours: course.creditHours,
      enrolledStudentIds: updatedEnrolledStudentIds,
    );
    
    _mockCourses[index] = updatedCourse;
    return updatedCourse;
  }
}

