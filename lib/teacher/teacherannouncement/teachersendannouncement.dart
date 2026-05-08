import 'package:ciheapp/provider/api/announcementprovider.dart';
import 'package:ciheapp/provider/api/dropdownprovider.dart';
import 'package:ciheapp/view/widget/dropdownwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherNotificationScreen extends StatefulWidget {
  const TeacherNotificationScreen({super.key});

  @override
  State<TeacherNotificationScreen> createState() => _announcementscreenState();
}

class _announcementscreenState extends State<TeacherNotificationScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String? _dropdownSelectedStudent;
  String selectedCourseName = '';
  List<String> _selectedStudents = [];
  bool _selectAll = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<PosDropdownProvider>(context, listen: false)
          .fetchStudentslist();
    });
  }

  void _toggleSelectAll(bool? value, List<String> students) {
    setState(() {
      _selectAll = value ?? false;
      _selectedStudents = _selectAll ? List.from(students) : [];
    });
  }

  void _toggleStudent(String student, bool? value) {
    setState(() {
      if (value == true) {
        _selectedStudents.add(student);
      } else {
        _selectedStudents.remove(student);
        _selectAll = false;
      }
    });
  }

Future<void> _pickDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final posDropdownProvider = Provider.of<PosDropdownProvider>(context);
    final studentList = posDropdownProvider.students
        .map((e) => e['username'] as String)
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (posDropdownProvider.course.isEmpty) {
        posDropdownProvider.fetchCourses();
      }
      if (posDropdownProvider.students.isEmpty) {
        posDropdownProvider.fetchStudents();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Notification'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _titlecontroller,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 10),
                  DropDownWidget(
                  label: 'Course list',
                  selectLabel: 'Select Course list',
                  onChanged: (value) {
                    if (value != null && value.isNotEmpty) {
                      posDropdownProvider.setCoursename(value);
                      setState(() {
                        selectedCourseName = value;
                      });
                    }
                  },
                  dropItems: posDropdownProvider.course
                      .map((course) => course['name'] as String)
                      .toList(),
                ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _dropdownSelectedStudent,
                        decoration: InputDecoration(
                          hintText: 'Select Student',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        items: studentList.map((student) {
                          return DropdownMenuItem(
                            value: student,
                            child: Text(student),
                          );
                        }).toList(),
                        onChanged: _selectAll
                        ? null
                        : (value) {
                            setState(() {
                              _dropdownSelectedStudent = value;
                              _selectedStudents = value != null ? [value] : [];
                            });
                            if (value != null) {
                              posDropdownProvider.setStudent(value);
                            }
                          },
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        title: const Text('Select All Students'),
                        value: _selectAll,
                        onChanged: (value) =>
                            _toggleSelectAll(value, studentList),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if (_selectAll)
                        ...studentList.map((student) {
                          return CheckboxListTile(
                            title: Text(student),
                            value: _selectedStudents.contains(student),
                            onChanged: (value) =>
                                _toggleStudent(student, value),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }).toList(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : 'Selected Date: ${_selectedDate!.toLocal()}'
                                      .split(' ')[0],
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Pick Date'),
                            onPressed: () => _pickDate(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptioncontroller,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          prefixIcon: const Icon(Icons.description_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send, color: Colors.white),
                        iconAlignment: IconAlignment.end,
                        onPressed: () async {
                          String title = _titlecontroller.text;
                          String description = _descriptioncontroller.text;

                          if (_selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a date')),
                            );
                            return;
                          }

                          final now =
                              DateTime.now().add(const Duration(minutes: 5));
                          if (_selectedDate!.isBefore(now)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Scheduled time must be at least 5 minutes later',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (_selectedStudents.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select at least one student',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          List<int> userIds = posDropdownProvider.students
                              .where((e) =>
                                  _selectedStudents.contains(e['username']))
                              .map((e) => e['id'] as int)
                              .toList();
                         final courseName = selectedCourseName.isNotEmpty ? selectedCourseName : 'Unknown Course';
                        final buffer = StringBuffer()
                          ..writeln("Title: $title")
                          ..writeln("Description: $description")
                          ..writeln("Course: $courseName");

                        final message = buffer.toString();


                          final announcementProvider =
                              Provider.of<AnnouncementProvider>(context,
                                  listen: false);
                          final success =
                              await announcementProvider.sendAnnouncement(
                            userIds: userIds,
                            title:title,
                           course:posDropdownProvider.selectedCourseName ?? '',
                            message: message,
                            scheduledAt: _selectedDate!.toIso8601String(),
                          );
                    print('Announcement sent: $success');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              success
                                  ? 'Announcement sent successfully'
                                  : 'Failed to send announcement',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}