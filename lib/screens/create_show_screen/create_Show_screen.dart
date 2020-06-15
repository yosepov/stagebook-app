import 'package:flutter/material.dart';
import 'package:stagebook/screens/lessons_screen/create_lesson.dart';

class CreateShowScreen extends StatefulWidget {
  final userId;
  static final String id = "createShow_screen";

  CreateShowScreen({this.userId});
  @override
  _CreateShowScreenState createState() => _CreateShowScreenState();
}

class _CreateShowScreenState extends State<CreateShowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: CreateLessonScreen(),
    );
  }
}
