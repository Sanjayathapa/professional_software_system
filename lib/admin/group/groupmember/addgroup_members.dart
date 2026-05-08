import 'package:ciheapp/provider/api/dropdownprovider.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';
import 'package:ciheapp/provider/api/group_member_provider.dart';

import 'package:ciheapp/view/widget/dropdownwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AddGroupMembersScreen extends StatefulWidget {
  final int groupId;
  const AddGroupMembersScreen({super.key, required this.groupId}) ;
  @override
  _AddEnrollementScreenState createState() => _AddEnrollementScreenState();
}

class _AddEnrollementScreenState extends State<AddGroupMembersScreen> {
  final _formKey = GlobalKey<FormState>();

// @override
// void initState() {
//   super.initState();
//   Future.microtask(() => context.read<PosDropdownProvider>().fetchStudents());
// }
  @override
  Widget build(BuildContext context) {
      
     final posDropdownProvider = Provider.of<PosDropdownProvider>(context,listen: false);
    final groupProvider = Provider.of<GroupProvider>(context,listen: false);
     WidgetsBinding.instance.addPostFrameCallback((_) {
      
           if (posDropdownProvider.course.isEmpty) {
         posDropdownProvider.fetchCourses();
      }
            if (posDropdownProvider.student.isEmpty) {
         posDropdownProvider.fetchStudents();
      }
    });
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add GroupMembers',
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
                      DropDownWidget(
                      label: 'Student list',
                      selectLabel: 'Select Student list',
                      onChanged: (value) {
                        if (value != null && value.isNotEmpty) {
                      
                          posDropdownProvider.setStudent(value);

                          print('Selected student ID: ${posDropdownProvider.selectedstudentId}');
                        }
                      },
                      dropItems: posDropdownProvider.student
                          .map((student) => student['username'] as String)
                          .toList(),
                    ),
              const SizedBox(height: 20),
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
                      await groupProvider.submitgropmembers(posDropdownProvider.selectedCourseId!, posDropdownProvider.selectedstudentId!, widget.groupId);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Members Successful Added',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 1, 131, 9),));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add Members ',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 251, 6, 6),));
                    }
                  }
                },
                child: Text('Submit Members'),
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
