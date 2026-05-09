
import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/apiassignmentprovider.dart';
import 'package:principles_ss/provider/api/dropdownprovider.dart';
import 'package:principles_ss/view/widget/dropdownwidget.dart';
import 'package:provider/provider.dart';

class CreateAssignment extends StatefulWidget {
  const CreateAssignment({super.key});

  @override
  State<CreateAssignment> createState() => _CreateAssignmentState();
}

class _CreateAssignmentState extends State<CreateAssignment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _linkController = TextEditingController();
  DateTime? _dueDate;
  String selectedCourseId = '';
  bool _isLoading = false;
  
   void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
        final posDropdownProvider = Provider.of<PosDropdownProvider>(context,listen: false);
    final provider = Provider.of<AssignmentsProvider>(context);
     WidgetsBinding.instance.addPostFrameCallback((_) {
      
           if (posDropdownProvider.course.isEmpty) {
         posDropdownProvider.fetchCourses();
      }
      
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Assignment'),
       
      ),
      body:SingleChildScrollView(scrollDirection: Axis.vertical,child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical: 30),
        child: Container(
        
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 120, 119, 119).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3), 
                  ),
                ],
              
            ),
          
          
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:Form(
                key: _formKey,
                child:  Column(
                children: [
          DropDownWidget(
          label: 'Course list',
          selectLabel: 'Select Course list',
          onChanged: (value) {
            if (value != null && value.isNotEmpty) {
              posDropdownProvider.setCourseType(value);
              final selectedCourse = posDropdownProvider.course.firstWhere(
                (course) => course['name'] == value,
                orElse: () => {},
              );
              setState(() {
                selectedCourseId = selectedCourse['id'].toString(); 
              });

              print('Selected Course ID: $selectedCourseId');
            }
          },
          dropItems: posDropdownProvider.course
              .map((course) => course['name'] as String)
              .toList(),
        ),
              const SizedBox(height: 20),
                TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title",prefixIcon: Icon(Icons.title)),
                validator: (v) => v!.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description",prefixIcon: Icon(Icons.description)),
                validator: (v) => v!.isEmpty ? "Enter description" : null,
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(labelText: "Reference Link",prefixIcon: Icon(Icons.link)),
                validator: (v) => v!.isEmpty ? "Enter link" : null,
              ),
                  const SizedBox(height: 26),
                 InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Due Date",
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dueDate != null
                        ? _dueDate.toString().split(' ')[0]
                        : "Select date",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child:
              ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () {
                     if (_formKey.currentState!.validate() && _dueDate != null)
 {
                          provider.createAssignment(
                             courseId: int.tryParse(selectedCourseId) ?? 0,
                            title: _titleController.text,
                            description: _descController.text,
                            link: _linkController.text,
                            dueDate: _dueDate!,
                            context: context,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Fill all fields")),
                          );
                        }
                      },
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Add Assignment"),
              )),
            ],
          ),
        ),
      ),
    ))));
  }
}