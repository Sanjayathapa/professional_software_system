
import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/apiassignmentprovider.dart';
import 'package:principles_ss/provider/api/dropdownprovider.dart';
import 'package:principles_ss/view/widget/dropdownwidget.dart';
import 'package:provider/provider.dart';

class EditAssignment extends StatefulWidget {
  final int assignmentId;
  final int courseId;
  final String title;
  final String description;
  final String link;
  final DateTime dueDate;

  const EditAssignment({
    super.key,
    required this.assignmentId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.link,
    required this.dueDate,
  });

  @override
  State<EditAssignment> createState() => _EditAssignmentState();
}

class _EditAssignmentState extends State<EditAssignment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _linkController;
  DateTime? _dueDate;
  String selectedCourseId = '';
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descController = TextEditingController(text: widget.description);
    _linkController = TextEditingController(text: widget.link);
    _dueDate = widget.dueDate;
    selectedCourseId = widget.courseId.toString();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posDropdownProvider = Provider.of<PosDropdownProvider>(context);
    final provider = Provider.of<AssignmentsProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (posDropdownProvider.course.isEmpty) {
        posDropdownProvider.fetchCourses();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Assignment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropDownWidget(
                    label: 'Course list',
                    selectLabel: 'Select Course',
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
                      }
                    },
                    dropItems: posDropdownProvider.course
                        .map((course) => course['name'] as String)
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (v) => v!.isEmpty ? "Enter title" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (v) => v!.isEmpty ? "Enter description" : null,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _linkController,
                    decoration: const InputDecoration(labelText: "Reference Link"),
                    validator: (v) => v!.isEmpty ? "Enter link" : null,
                  ),
                  const SizedBox(height: 26),
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Due Date",
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
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate() && _dueDate != null) {
                                final data = {
                                  "course_id": int.tryParse(selectedCourseId) ?? widget.courseId,
                                  "title": _titleController.text,
                                  "description": _descController.text,
                                  "links": _linkController.text,
                                  "due_date": _dueDate!.toIso8601String().split("T").first,
                                };

                                provider.editAssignment(widget.assignmentId, data).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Assignment updated successfully!"),
                                      backgroundColor: Color.fromARGB(255, 2, 189, 36),
                                    ),
                                  );
                                  Navigator.pop(context); 
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fill all fields")),
                                );
                              }
                            },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Update Assignment"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
