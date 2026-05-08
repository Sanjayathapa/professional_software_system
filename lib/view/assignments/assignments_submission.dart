import 'dart:convert';
import 'dart:io';
import 'package:ciheapp/provider/assignment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:file_picker/file_picker.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  final String assignmentId;
  
  const AssignmentSubmissionScreen({
    Key? key,
    required this.assignmentId,
  }) : super(key: key);

  @override
  State<AssignmentSubmissionScreen> createState() => _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState extends State<AssignmentSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _submissionUrl = '';
  bool _isUploading = false;

    Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    final assignment = assignmentProvider.selectedAssignment;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Assignment'),
      ),
      body: assignment == null
          ? const Center(child: Text('Assignment not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              assignment.courseName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Due: ${_formatDate(assignment.dueDate)}',
                                  style: TextStyle(
                                    color: _getDueDateColor(assignment.dueDate),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                
                    Text(
                      'Upload Assignment',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                 
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                             onPressed: _isUploading
                                ? null
                                : () async {
                                    
                                    await pickAndUploadFile(context);
                                  },
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Select File'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Supported formats: PDF, DOC, DOCX, ZIP',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                   
                    if (_submissionUrl.isNotEmpty)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: const Text('assignment.pdf'),
                          subtitle: const Text('PDF Document • 2.3 MB'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _submissionUrl = '';
                              });
                            },
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Comments (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 24),
                    
                   
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () async {
                          final file = await pickFile();
                          if (file != null) {
                            uploadFile(context, file);
                          }
                        },
                        child: _isUploading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit Assignment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
  
  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference < 0) {
      return Colors.red;
    } else if (difference <= 2) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
  Future<void> pickAndUploadFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf','docx', 'csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // await uploadFile(context, file);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File selection canceled.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> uploadFile(BuildContext context, File file) async {
    final prefs = await SharedPreferences.getInstance();
    const apiUrl = '';

    try {
      
      final token = prefs.getString('api_token');
      if (token == null) {
        throw ('No API token found.');
      }

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';

    
      // request.fields['slug'] = slug; 

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          // filename: basename(file.path),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
       
        String message = 'Upload failed';
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
          if (jsonResponse.containsKey('message')) {
            message = jsonResponse['message'];
          }
        } catch (e) {
          print('Error parsing response body: $e');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

