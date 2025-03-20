import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'workout_form_screen.dart';
import 'diet_plan_details_screen.dart';
import 'map_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Future<void> saveWorkoutPlans() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('workoutPlans', jsonEncode(workoutPlans));
  }

  Future<void> loadWorkoutPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('workoutPlans');
    if (data != null) {
      setState(() {
        workoutPlans.clear();
        workoutPlans.addAll(List<Map<String, dynamic>>.from(jsonDecode(data)));
      });
    }
  }

  Future<void> saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('goals', jsonEncode(goals));
  }

  Future<void> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('goals');
    if (data != null) {
      setState(() {
        goals.clear();
        goals.addAll(List<Map<String, dynamic>>.from(jsonDecode(data)));
      });
    }
  }

  final List<Map<String, dynamic>> workoutPlans = [
    {
      'name': 'Weight Loss',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Medium',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': '6 Pack Abs',
      'progress': 0,
      'duration': '35 mins',
      'difficulty': 'Medium',
      'preferences': ['Cardio'],
      'equipmentUsed': false,
    },
    {
      'name': 'Powerlifting',
      'progress': 0,
      'duration': '10 mins',
      'difficulty': 'Easy',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Crossfit',
      'progress': 0,
      'duration': '36 mins',
      'difficulty': 'Hard',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Bodybuilding',
      'progress': 0,
      'duration': '45 mins',
      'difficulty': 'Hard',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Endurance Training',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Medium',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'HIIT',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Easy',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Yoga',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Easy',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'P90X',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Medium',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Pilates',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Medium',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
    {
      'name': 'Functional Training',
      'progress': 0,
      'duration': '30 mins',
      'difficulty': 'Easy',
      'preferences': ['Cardio'],
      'equipmentUsed': true,
    },
  ];

  final List<Map<String, dynamic>> nutritionPlans = [
    {
      'plan': 'Keto Diet',
      'details': {
        'Description': 'A low-carb, high-fat diet.',
        'Carbs': '20g',
        'Protein': '70g',
        'Fats': '100g',
        'Recommended Foods': 'Avocados, Eggs, Cheese, Meat',
        'Avoid Foods': 'Bread, Rice, Sugar',
      }
    },
    {
      'plan': 'Vegan Diet',
      'details': {
        'Description': 'A plant-based diet.',
        'Carbs': '150g',
        'Protein': '50g',
        'Fats': '20g',
        'Recommended Foods': 'Fruits, Vegetables, Nuts, Tofu',
        'Avoid Foods': 'Meat, Dairy, Eggs',
      }
    },
    {
      'plan': 'Mediterranean Diet',
      'details': {
        'Description': 'A heart-healthy diet inspired by the foods of the Mediterranean region.',
        'Carbs': '200g',
        'Protein': '60g',
        'Fats': '50g',
        'Recommended Foods': 'Olive oil, Fish, Whole grains, Vegetables',
        'Avoid Foods': 'Red meat, Processed foods, Sugary snacks',
      }
    },
    {
      'plan': 'Paleo Diet',
      'details': {
        'Description': 'A diet based on the eating habits of early humans, focusing on whole foods.',
        'Carbs': '100g',
        'Protein': '80g',
        'Fats': '60g',
        'Recommended Foods': 'Meat, Fish, Vegetables, Nuts, Fruits',
        'Avoid Foods': 'Dairy, Grains, Processed foods',
      }
    },
    {
      'plan': 'Intermittent Fasting',
      'details': {
        'Description': 'A dietary pattern that cycles between periods of fasting and eating.',
        'Carbs': 'Varies',
        'Protein': 'Varies',
        'Fats': 'Varies',
        'Recommended Foods': 'Whole foods, Balanced meals during eating windows',
        'Avoid Foods': 'Excessive processed foods, Junk foods',
      }
    },
    {
      'plan': 'Low-Fat Diet',
      'details': {
        'Description': 'A diet that restricts fat intake, focusing on low-fat foods.',
        'Carbs': '150g',
        'Protein': '70g',
        'Fats': '20g',
        'Recommended Foods': 'Lean meats, Whole grains, Fruits, Vegetables',
        'Avoid Foods': 'Fatty meats, Fried foods, High-fat dairy',
      }
    },
  ];

  final List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadWorkoutPlans();
    loadGoals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addGoal(String goalName, String workout, String diet) {
    setState(() {
      goals.add({
        'goal': goalName,
        'status': 'In Progress',
        'associatedWorkout': workout,
        'associatedDiet': diet,
      });
    });
    saveGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'CureFusion',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ApiScreen())),
          ),
        ],
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: Column(
          children: [
            Image.asset(
              'images/Icon.png',
              width: double.infinity,
              height: 130,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.teal.shade200,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.teal.shade900,
                unselectedLabelColor: Colors.teal.shade700,
                indicatorColor: Colors.teal.shade900,
                tabs: const [
                  Tab(text: 'Workouts'),
                  Tab(text: 'Nutrition'),
                  Tab(text: 'Goals'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWorkoutList(),
                  _buildNutritionList(),
                  _buildGoalsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    return ListView.builder(
      itemCount: workoutPlans.length,
      itemBuilder: (context, index) {
        final plan = workoutPlans[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: Colors.teal.shade100,
          child: ListTile(
            title: Text(plan['name']),
            subtitle: Text(
              'Progress: ${plan['progress']}%\n'
                  'Duration: ${plan['duration']}\n'
                  'Difficulty: ${plan['difficulty']}\n'
                  'Preferences: ${plan['preferences'].join(', ')}\n'
                  'Equipment Used: ${plan['equipmentUsed'] ? "Yes" : "No"}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.teal.shade900,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutFormScreen(
                          workoutName: plan['name'],
                          duration: plan['duration'],
                          difficulty: plan['difficulty'],
                          preferences: List<String>.from(plan['preferences']),
                          equipmentUsed: plan['equipmentUsed'],
                          progress: plan['progress'], // Pass progress to the form
                          onSubmit: (String updatedWorkoutName, String updatedDuration, String updatedDifficulty, List<String> updatedPreferences, bool updatedEquipmentUsed, double updatedProgress) async {
                            setState(() {
                              plan['name'] = updatedWorkoutName;
                              plan['duration'] = updatedDuration;
                              plan['difficulty'] = updatedDifficulty;
                              plan['preferences'] = updatedPreferences;
                              plan['equipmentUsed'] = updatedEquipmentUsed;
                              plan['progress'] = updatedProgress;
                            });
                            await saveWorkoutPlans();
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red.shade400,
                  onPressed: () async {
                    setState(() {
                      workoutPlans.removeAt(index);
                    });
                    await saveWorkoutPlans();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionList() {
    return ListView.builder(
      itemCount: nutritionPlans.length,
      itemBuilder: (context, index) {
        final plan = nutritionPlans[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: Colors.teal.shade100,
          shadowColor: Colors.teal.shade400,
          child: ListTile(
            title: Text(plan['plan']),
            subtitle: const Text('Tap to view details'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DietPlanDetailsScreen(dietPlan: plan),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGoalsList() {
    return Stack(
      children: [
        ListView.builder(
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Card(
              margin: const EdgeInsets.all(8),
              color: Colors.teal.shade100,
              shadowColor: Colors.teal.shade400,
              child: ListTile(
                title: Text(goal['goal']),
                subtitle: Text(
                  'Status: ${goal['status']} \nWorkout: ${goal['associatedWorkout']} \nDiet: ${goal['associatedDiet']}',
                ),
                trailing: const Icon(Icons.check_circle),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "addGoalButton",
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String newGoal = '';
                  String selectedWorkout = workoutPlans[0]['name'];
                  String selectedDiet = nutritionPlans[0]['plan'];

                  return AlertDialog(
                    title: const Text('Add New Goal'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            newGoal = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter goal name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          value: selectedWorkout,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedWorkout = newValue!;
                            });
                          },
                          items: workoutPlans
                              .map((plan) => DropdownMenuItem<String>(
                            value: plan['name'],
                            child: Text(plan['name']),
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          value: selectedDiet,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDiet = newValue!;
                            });
                          },
                          items: nutritionPlans
                              .map((plan) => DropdownMenuItem<String>(
                            value: plan['plan'],
                            child: Text(plan['plan']),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (newGoal.isNotEmpty) {
                            addGoal(newGoal, selectedWorkout, selectedDiet);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
