import 'package:flutter/material.dart';

class WorkoutFormScreen extends StatefulWidget {
  final String workoutName;
  final String duration;
  final String difficulty;
  final List<String> preferences;
  final bool equipmentUsed;
  final double progress;
  final Function(String, String, String, List<String>, bool, double) onSubmit;

  WorkoutFormScreen({
    required this.workoutName,
    required this.duration,
    required this.difficulty,
    required this.preferences,
    required this.equipmentUsed,
    required this.progress,
    required this.onSubmit,
  });

  @override
  _WorkoutFormScreenState createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  late TextEditingController nameController;
  late TextEditingController durationController;
  late String difficulty;
  late TextEditingController progressController;
  late List<String> preferences;
  late bool equipmentUsed;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.workoutName);
    durationController = TextEditingController(text: widget.duration);
    difficulty = widget.difficulty;
    progressController = TextEditingController(text: widget.progress.toString());
    preferences = List.from(widget.preferences);
    equipmentUsed = widget.equipmentUsed;
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Edit Workout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  child: TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration('Workout Name', Icons.fitness_center),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a workout name';
                      }
                      return null;
                    },
                  ),
                ),
                _buildCard(
                  child: TextFormField(
                    controller: durationController,
                    decoration: _inputDecoration('Duration', Icons.timer),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a duration';
                      }
                      return null;
                    },
                  ),
                ),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Difficulty:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      RadioListTile<String>(
                        title: const Text('Easy'),
                        value: 'Easy',
                        groupValue: difficulty,
                        onChanged: (String? value) {
                          setState(() {
                            difficulty = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Medium'),
                        value: 'Medium',
                        groupValue: difficulty,
                        onChanged: (String? value) {
                          setState(() {
                            difficulty = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Hard'),
                        value: 'Hard',
                        groupValue: difficulty,
                        onChanged: (String? value) {
                          setState(() {
                            difficulty = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  child: TextFormField(
                    controller: progressController,
                    decoration: _inputDecoration('Progress (%)', Icons.show_chart),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a progress value';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number for progress';
                      }
                      return null;
                    },
                  ),
                ),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferences:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      CheckboxListTile(
                        title: const Text('Yoga'),
                        value: preferences.contains('Yoga'),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              preferences.add('Yoga');
                            } else {
                              preferences.remove('Yoga');
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Cardio'),
                        value: preferences.contains('Cardio'),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              preferences.add('Cardio');
                            } else {
                              preferences.remove('Cardio');
                            }
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Strength Training'),
                        value: preferences.contains('Strength Training'),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              preferences.add('Strength Training');
                            } else {
                              preferences.remove('Strength Training');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                _buildCard(
                  child: SwitchListTile(
                    title: const Text('Equipment Used'),
                    value: equipmentUsed,
                    onChanged: (bool value) {
                      setState(() {
                        equipmentUsed = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final progress = double.tryParse(progressController.text) ?? 0.0;
                        widget.onSubmit(
                          nameController.text,
                          durationController.text,
                          difficulty,
                          preferences,
                          equipmentUsed,
                          progress,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.teal.shade200,
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
