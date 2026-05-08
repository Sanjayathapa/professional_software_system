import 'package:ciheapp/provider/api/dropdownprovider.dart';
import 'package:ciheapp/provider/api/enrollementprovider.dart';

import 'package:ciheapp/view/widget/dropdownwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AddEnrollementScreen extends StatefulWidget {
  @override
  _AddEnrollementScreenState createState() => _AddEnrollementScreenState();
}

class _AddEnrollementScreenState extends State<AddEnrollementScreen> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
      
     final posDropdownProvider = Provider.of<PosDropdownProvider>(context,listen: false);
    final enrollmentProvider = Provider.of<EnrollmentProvider>(context,listen: false);
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
          'Course Enrollment',
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
                      await enrollmentProvider.submitEnrollment(posDropdownProvider.selectedCourseId!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enrollment Successful',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 1, 131, 9),));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enrollment Failed',style: TextStyle(color: Colors.white),),backgroundColor: const Color.fromARGB(255, 251, 6, 6),));
                    }
                  }
                },
                child: Text('Submit Enrollment'),
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
