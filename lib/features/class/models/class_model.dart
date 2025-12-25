import 'package:flutter/material.dart';

class ClassModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final int progress;
  final List<Meeting> meetings;
  final List<Material> materials;
  final List<Assignment> assignments;
  final List<Quiz> quizzes;

  const ClassModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.progress,
    required this.meetings,
    required this.materials,
    required this.assignments,
    required this.quizzes,
  });

  IconData get icon {
    switch (iconName) {
      case 'palette':
        return Icons.palette_rounded;
      case 'phone_android':
        return Icons.phone_android_rounded;
      case 'storage':
        return Icons.storage_rounded;
      default:
        return Icons.class_rounded;
    }
  }
}

class Meeting {
  final String id;
  final String title;
  final String date;
  final String time;
  final String description;
  final bool isCompleted;

  const Meeting({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.isCompleted,
  });
}

class Material {
  final String id;
  final String title;
  final String type;
  final String description;
  final String url;

  const Material({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.url,
  });
}

class Assignment {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String status;
  final int score;

  const Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.score = 0,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String status;
  final int score;
  final int totalQuestions;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.score = 0,
    required this.totalQuestions,
  });
}
