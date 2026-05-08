import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ciheapp/model/calender_event.dart';
import 'package:ciheapp/provider/api/calendereventprovider.dart';

class EventForm extends StatefulWidget {
  final DateTime selectedDay;
  const EventForm({Key? key, required this.selectedDay}) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDay;
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}"; 
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Container(
        decoration: BoxDecoration(
         color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 20),
              
           
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Select Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, 
                onTap: () => _pickDate(context), 
              ),

              const SizedBox(height: 20),

            
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text("Save Event"),
                ),
              ),
            ],
          ),
        ),
      ),)),
    );
  }
}
