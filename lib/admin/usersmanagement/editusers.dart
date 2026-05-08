import 'package:ciheapp/service/api/usermanagement_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditusersScreen extends StatefulWidget {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final String role;
  final String status;
 

  EditusersScreen({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.role,
    required this.status,
 
  });

  @override
  _EditusersScreenState createState() => _EditusersScreenState();
}

class _EditusersScreenState extends State<EditusersScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _emailController;
  late TextEditingController _statusController;
   late TextEditingController _roleController; 
   late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
   late TextEditingController _usernameController; 
 

  @override
  void initState() {
    super.initState();

   _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _roleController = TextEditingController(text: widget.role);
    _firstnameController = TextEditingController(text: widget.firstname);
    _lastnameController = TextEditingController(text: widget.lastname);
    _statusController = TextEditingController(text: widget.status);
  
  }

  @override
  

  void _updateItem() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'id': widget.id,
        'email': _emailController.text,
        'status': _statusController.text,
        'role': _roleController.text,
        'first_name': _firstnameController.text,
        'last_name': _lastnameController.text,
        'username': _usernameController.text,
       
      };

      try {
         await UserManagementService().editUsers(widget.id, updatedData); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Users Updated Successfully',
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
              'Error updating Users: $e',
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
          'Edit Users',
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
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(227, 1, 37, 198),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                        TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person_2),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(227, 1, 37, 198),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the  first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                        TextFormField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: ' Last Name',
                        prefixIcon: Icon(Icons.person_2_outlined),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(227, 1, 37, 198),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Last name';
                        }
                        return null;
                      },
                    ),
              
                    SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(227, 1, 37, 198),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';  
                            }                       
                            String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address';  
                            }
                            return null; 
                          },
                        ),
                         SizedBox(height: 15),
              DropdownButtonFormField<String>(
              value: _roleController.text.isEmpty ? null : _roleController.text,
              onChanged: (String? newValue) {
                setState(() {
                  _roleController.text = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.supervised_user_circle),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(227, 1, 37, 198),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a role';
                }
                return null;
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'student',
                  child: Text('Student'),
                ),
                DropdownMenuItem<String>(
                  value: 'lecturer',
                  child: Text('Lecturer'),
                ),
                
              ],
            ),

              
                    SizedBox(height: 15),
                        SizedBox(height: 15),
                   
                   
                      DropdownButtonFormField<int>(
                        value: _statusController.text.isEmpty ? null : int.tryParse(_statusController.text),
                        onChanged: (int? newValue) {
                          setState(() {
                            _statusController.text = newValue.toString();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.group),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(227, 1, 37, 198),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                        items: [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('Active'),
                          ),
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Inactive'),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateItem,
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
