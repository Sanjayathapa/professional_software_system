
import 'package:flutter/material.dart';
import 'package:principles_ss/model/apiusers.dart';
import 'package:principles_ss/provider/api/api_profile_provider.dart';
import 'package:principles_ss/view/authscreen/changepassword.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadUserProfile();
    });

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
    await profileProvider.fetchUserProfile();
    
    final user = profileProvider.user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
      
      final success = await profileProvider.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );
      
      if (mounted) {
        if (success) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully',style:TextStyle(color: Colors.white),),backgroundColor: Colors.green,),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfilesProvider>(context);
   
    final user = profileProvider.user;
    
    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (user == null) {
      return const Center(child: Text('Failed to load profile'));
    }
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(
                            user.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    _getRoleText(user.role),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
           
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            icon: Icon(_isEditing ? Icons.close : Icons.edit),
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing;
                                if (!_isEditing) {
                                
                                  _nameController.text = user.name;
                                  _emailController.text = user.email;
                                  _phoneController.text = user.phoneNumber ?? '';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        enabled: _isEditing,
                      ),
                      if (_isEditing) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: profileProvider.isLoading ? null : _saveProfile,
                            child: profileProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save Changes'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
          
            // Card(
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Notification Preferences',
            //           style: Theme.of(context).textTheme.titleMedium,
            //         ),
            //         const SizedBox(height: 16),
                   
            //         _buildNotificationPreferenceSwitch(
            //           'Push Notifications',
            //           notification?.notificationPreferences?.pushNotifications ?? false,
            //           (value) => _updateNotificationPreference(
            //             (notification?.notificationPreferences ?? NotificationPreferences()).copyWith(pushNotifications: value),
            //           ),
            //         ),
            //         const Divider(),
            //         _buildNotificationPreferenceSwitch(
            //           'Assignment Reminders',
            //           notification?.notificationPreferences?.assignmentReminders?? false,
            //           (value) => _updateNotificationPreference(
            //             notification?.notificationPreferences?.copyWith(assignmentReminders: value) ?? NotificationPreferences(),
            //           ),
            //         ),
            //         _buildNotificationPreferenceSwitch(
            //           'Exam Reminders',
            //            notification?.notificationPreferences?.examReminders?? false,
            //           (value) => _updateNotificationPreference(
            //             notification?.notificationPreferences?.copyWith(examReminders: value) ?? NotificationPreferences(),
            //           ),
            //         ),
            //         _buildNotificationPreferenceSwitch(
            //           'College Notices',
            //           notification?.notificationPreferences?.collegeNotices?? false,
            //           (value) => _updateNotificationPreference(
            //             (notification?.notificationPreferences ?? NotificationPreferences()).copyWith(collegeNotices: value),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),
               InkWell(onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePasswordScreen()));
               },
               child:Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ChangePassword',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                   Icon(Icons.arrow_forward_ios)
                   
                  ],
                ),
              ),
            ),)
          
          ],
        ),
      ),
    );
  }

  // Widget _buildNotificationPreferenceSwitch(
  //   String title,
  //   bool value,
  //   Function(bool) onChanged,
  // ) {
  //   return SwitchListTile(
  //     title: Text(title),
  //     value: value,
  //     onChanged: onChanged,
  //   );
  // }

  // Widget _buildSecuritySwitch(
  //   String title,
  //   bool value,
  //   Function(bool) onChanged,
  // ) {
  //   return SwitchListTile(
  //     title: Text(title),
  //     value: value,
  //     onChanged: onChanged,
  //   );
  // }

  // Future<void> _updateNotificationPreference(NotificationPreferences preferences) async {
  //   final profileProvider = Provider.of<ProfilesProvider>(context, listen: false);
  //   await profileProvider.updateNotificationPreferences(preferences);
  // }


  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.lecturer:
        return 'Faculty';
      case UserRole.admin:
        return 'Administrator';
      default:
        return 'User';
    }
  }
}

