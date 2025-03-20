import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _profileData = {
    'name': '',
    'email': '',
    'phone': '',
    'dob': '',
    'height': '',
    'weight': '',
    'gender': '',
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileData['name'] = prefs.getString('name') ?? '';
      _profileData['email'] = prefs.getString('email') ?? '';
      _profileData['phone'] = prefs.getString('phone') ?? '';
      _profileData['dob'] = prefs.getString('dob') ?? '';
      _profileData['height'] = prefs.getString('height') ?? '';
      _profileData['weight'] = prefs.getString('weight') ?? '';
      _profileData['gender'] = prefs.getString('gender') ?? '';
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    _profileData.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  Future<void> _deleteProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _profileData.forEach((key, _) => _profileData[key] = '');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile data deleted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField('Name', 'Enter your name', 'name'),
                _buildTextField('Email', 'Enter your email', 'email', keyboardType: TextInputType.emailAddress),
                _buildTextField('Phone', 'Enter your phone number', 'phone', keyboardType: TextInputType.phone),
                _buildTextField('Date of Birth', 'Enter your DOB (yyyy-mm-dd)', 'dob'),
                _buildTextField('Height (cm)', 'Enter your height', 'height', keyboardType: TextInputType.number),
                _buildTextField('Weight (kg)', 'Enter your weight', 'weight', keyboardType: TextInputType.number),
                _buildDropdown('Gender', 'gender', ['Male', 'Female', 'Other']),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await _saveProfileData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile Saved!')),
                            );
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _deleteProfileData,
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, String key,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        initialValue: _profileData[key],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        onSaved: (value) {
          if (value != null) _profileData[key] = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (key == 'email' &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          if (key == 'phone' && !RegExp(r'^\d{10,15}$').hasMatch(value)) {
            return 'Please enter a valid phone number';
          }
          if (key == 'dob' &&
              !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
            return 'Please enter a valid date in yyyy-mm-dd format';
          }
          if ((key == 'height' || key == 'weight') &&
              !RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
            return 'Please enter a valid number for $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        value: (_profileData[key] == null || _profileData[key]!.isEmpty) ? null : _profileData[key],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options
            .map((option) =>
            DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: (value) {
          if (value != null) _profileData[key] = value;
        },
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }
}
