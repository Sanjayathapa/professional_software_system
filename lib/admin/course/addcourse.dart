import 'package:ciheapp/service/api/courseservice.dart';
import 'package:ciheapp/service/api/usermanagement_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AddCourseScreen extends StatefulWidget {
  @override
  _AddUsersScreenState createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teachernameController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
 
 

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newCourse = {
        "faculty_name": _facultyController.text,
        "batch": _batchController.text,
        "teacher_name": _teachernameController.text,
        "name": _nameController.text,
        "description": _descriptionController.text,
        "start_date": _startController.text,
        "end_date": _endController.text,
        "schedule": _scheduleController.text,
        
     
      };

      try {
        await CoursesService().addcourse(newCourse);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Course added Successfully',
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
              'Failed to add Course',
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
        title: Text(
          'Add Course',
        ),
     
        centerTitle: true,
      ),
      body: Padding(
       padding:  EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
         
         
            child: Padding(
              padding: const EdgeInsets.symmetric( vertical:20,),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), 
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           TextFormField(
                          controller: _facultyController,
                          decoration: InputDecoration(
                            labelText: 'Faculty Name',
                           prefixIcon: Icon(Icons.school_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'facultyname is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),     
                        TextFormField(
                          controller: _nameController,  
                          decoration: InputDecoration(
                            labelText: 'Course name',
                            prefixIcon: Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Course name is required';
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
                                    return 'Teacher name is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _batchController,
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
                          controller: _startController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Select Start Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode()); 
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              _startController.text = pickedDate.toLocal().toString().split(' ')[0]; 
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
                          controller: _endController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Select End Date',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode()); 
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              _endController.text = pickedDate.toLocal().toString().split(' ')[0]; 
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
                        SizedBox(height: 20),
                
                  
                          SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            
                              minimumSize: Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              'Submit Course',
                              style:
                                  GoogleFonts.lato(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}
