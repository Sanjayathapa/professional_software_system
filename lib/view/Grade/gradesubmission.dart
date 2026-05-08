import 'package:flutter/material.dart';

class GradeSubmissionCard extends StatefulWidget {
  @override
  _GradeSubmissionCardState createState() => _GradeSubmissionCardState();
}

class _GradeSubmissionCardState extends State<GradeSubmissionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedStudent;
  String? selectedSubject;
  final TextEditingController _gradeController = TextEditingController();

 
  final List<String> students = ["bijaya gautam", "kritika mahahrjan", "Anish prasai","sanjaya thapa", "sandip gyawali"];
  final List<String> subjects = ["Math", "Science", "English"];

  void _submitGrade() {
    if (_formKey.currentState?.validate() ?? false) {
 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grade submitted for $selectedStudent')),
      );
      _gradeController.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: Text("Grade Submission"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Grade Submission", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    
                  
                    DropdownButtonFormField<String>(
                      value: selectedStudent,
                      decoration: InputDecoration(labelText: "Select Student", border: OutlineInputBorder()),
                      items: students.map((student) {
                        return DropdownMenuItem(value: student, child: Text(student));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedStudent = value),
                      validator: (value) => value == null ? "Please select a student" : null,
                    ),
                    const SizedBox(height: 10),
            
                   
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      decoration: InputDecoration(labelText: "Select Subject", border: OutlineInputBorder()),
                      items: subjects.map((subject) {
                        return DropdownMenuItem(value: subject, child: Text(subject));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedSubject = value),
                      validator: (value) => value == null ? "Please select a subject" : null,
                    ),
                    const SizedBox(height: 10),
            
                   
                    TextFormField(
                      controller: _gradeController,
                      decoration: InputDecoration(labelText: "Enter Grade", border: OutlineInputBorder()),
                      keyboardType: TextInputType.text,
                      validator: (value) => value == null || value.isEmpty ? "Enter a valid grade" : null,
                    ),
                    const SizedBox(height: 20),
            
                  
                    ElevatedButton.icon(
                      onPressed: _submitGrade,
                      icon: Icon(Icons.check,color:Colors.white),
                      label: Text("Submit Grade"),
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    ),
                  ],
                ),
              ),
            ),
                ),
          ],
        ),
      )));
  }
}
