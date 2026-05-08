import 'package:ciheapp/provider/api/dropdownprovider.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';

import 'package:ciheapp/view/widget/dropdownwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AddGroupScreen extends StatefulWidget {
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
 final TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      
     final posDropdownProvider = Provider.of<PosDropdownProvider>(context,listen: false);
    final groupProvider = Provider.of<GroupProvider>(context,listen: false);
     WidgetsBinding.instance.addPostFrameCallback((_) {
      
           if (posDropdownProvider.course.isEmpty) {
         posDropdownProvider.fetchCourses();
      }
    });
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add Group',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
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
                          controller: groupNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Group Name',
                            hintText: 'Enter group name',
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter group name';
                            }
                            return null;
                          },
                        ),
                      
                      SizedBox(height: 15,),
               DropDownWidget(
                label: 'Course list',
                selectLabel: 'Select Course list',
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                
                    posDropdownProvider.setCourseType(value);

                    print('Selected Course ID: ${posDropdownProvider.selectedCourseId}');
                  }
                },
                dropItems: posDropdownProvider.course
                    .map((course) => course['name'] as String)
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (posDropdownProvider.selectedCourseId != null) {
                    try {
                      final groupName = groupNameController.text.trim();
                      await groupProvider.submitgroup(posDropdownProvider.selectedCourseId!,groupName);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group Added Successful',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 1, 131, 9),));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OOPS! Failed to Add Group',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 251, 6, 6),));
                    }
                  }
                },
                child: Text('Add Group'),
              )

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
