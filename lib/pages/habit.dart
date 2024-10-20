import 'package:flutter/material.dart';
import 'package:habit_tracker/db/database_helper.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'habit.dart';

class HabitListScreen extends StatefulWidget {
  @override
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final dbHelper = DatabaseHelper();
  List<Habit> habitList = [];

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  void _fetchHabits() async {
    var habits = await dbHelper.getHabits();
    setState(() {
      habitList = habits
          .map((habit) => Habit(
                id: habit['id'],
                name: habit['name'],
                description: habit['description'],
                frequency: habit['frequency'],
                reminderTime: habit['reminder_time'],
              ))
          .toList();
    });
  }

  void _addHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(onSave: (newHabit) {
          setState(() {
            habitList.add(newHabit);
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: (context, index) {
          Habit habit = habitList[index];
          return ListTile(
            title: Text(habit.name),
            subtitle: Text(habit.description),
            trailing: Text(habit.frequency),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddHabitScreen extends StatefulWidget {
  final Function(Habit) onSave;

  AddHabitScreen({required this.onSave});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String frequency = '';
  String reminderTime = '';

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      Habit newHabit = Habit(
        name: name,
        description: description,
        frequency: frequency,
        reminderTime: reminderTime,
      );
      await DatabaseHelper().insertHabit(newHabit.toMap());
      widget.onSave(newHabit);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Frequency'),
                onChanged: (value) => frequency = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Reminder Time'),
                onChanged: (value) => reminderTime = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHabit,
                child: Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
