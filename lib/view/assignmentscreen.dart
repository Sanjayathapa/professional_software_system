
import 'package:flutter/material.dart';
import 'package:principles_ss/provider/api/apiassignmentprovider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AssignmentsProvider>(context, listen: false).fetchStudentAssignments());
  }

  // void _launchURL(BuildContext context, String url) async {
  //   if (url.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('OOPS! Submission link has not been provided yet.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Could not launch the submission link.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
void _launchURL(BuildContext context, String url) async {
  if (url.isEmpty || url.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OOPS! Submission link has not been provided yet.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

 
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }

  final Uri uri;
  try {
    uri = Uri.parse(url);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid submission URL format.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (!await canLaunchUrl(uri)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not find an app to open the submission link.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong while opening the link.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentsProvider>(context);
    final assignments = assignmentProvider.assignments;

    return Scaffold(
     
      body: assignmentProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : assignments.isEmpty
              ? const Center(child: Text("No assignments available."))
              : ListView.builder(
                  itemCount: assignments.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("Subject: ${assignment.courseName}", style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 12, 201, 5)),),
                            Text(
                              assignment.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                          
                                 Text(assignment.description,style: TextStyle(fontSize: 16,color: const Color.fromARGB(255, 10, 1, 135))),
                              const SizedBox(height: 6),
                               Text(
                              "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(color: Color.fromARGB(255, 247, 159, 7)),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _launchURL(context, assignment.links),
                                icon: const Icon(Icons.open_in_new, color: Colors.white),
                                label: const Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


