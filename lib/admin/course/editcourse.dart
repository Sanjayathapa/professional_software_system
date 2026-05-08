import 'package:ciheapp/service/api/courseservice.dart';
import 'package:ciheapp/service/api/usermanagement_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCourseScreen extends StatefulWidget {
  final int id;
  final String name;
  final String schedule;
  final String description;
  final String enddate;
  final String faculty;
  final String teacher;
  final String batch;
  final String startdate;

  EditCourseScreen({
    required this.id,
    required this.name,
    required this.schedule,
    required this.faculty,
    required this.teacher,
    required this.batch,
    required this.description,
    required this.enddate,
    required this.startdate,
  });

  @override
  _EditusersScreenState createState() => _EditusersScreenState();
}

class _EditusersScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _facultyController;
  late TextEditingController _teachernameController;
  late TextEditingController _batcController;
  late TextEditingController _scheduleController;
  late TextEditingController _descriptionController;
  late TextEditingController _enddateController;
  late TextEditingController _startdateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _scheduleController = TextEditingController(text: widget.schedule);
    _batcController = TextEditingController(text: widget.batch);
    _facultyController = TextEditingController(text: widget.faculty);
    _teachernameController = TextEditingController(text: widget.teacher);
    _descriptionController = TextEditingController(text: widget.description);
    _enddateController = TextEditingController(text: widget.enddate);
    _startdateController = TextEditingController(text: widget.startdate);
  }

  @override
  void _updateCourse() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'id': widget.id,
        'description': _descriptionController.text,
        'name': _nameController.text,
        'faculty_name': _facultyController.text,
        'batch': _batcController.text,
        'teacher_name': _teachernameController.text,
       
        'schedule': _scheduleController.text,
        'start_date': _startdateController.text,
        'end_date': _enddateController.text,
      };

      try {
        await CoursesService().editcourse(widget.id, updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Course Updated Successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating Course: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Edit Course',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _facultyController,
                      decoration: InputDecoration(
                        labelText: 'Faculty',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Faculty is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Coursename',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Coursename is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _teachernameController,
                      decoration: InputDecoration(
                        labelText: 'Teacher Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Teacher Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _batcController,
                      decoration: InputDecoration(
                        labelText: 'Batch',
                        prefixIcon: Icon(Icons.batch_prediction),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Batch is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: null,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'description  is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _startdateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Start Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Dismiss keyboard
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          _startdateController.text = pickedDate
                              .toLocal()
                              .toString()
                              .split(' ')[0]; // Format as yyyy-MM-dd
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _enddateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select End Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Dismiss keyboard
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          _enddateController.text = pickedDate
                              .toLocal()
                              .toString()
                              .split(' ')[0]; // Format as yyyy-MM-dd
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _scheduleController,
                      decoration: InputDecoration(
                        labelText: 'Schedule',
                        prefixIcon: Icon(Icons.schedule),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Schedule is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateCourse,
                      child: Text('Submit Form',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
