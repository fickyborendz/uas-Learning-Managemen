import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassMaterialsScreen extends StatefulWidget {
  final ClassModel classData;

  const ClassMaterialsScreen({super.key, required this.classData});

  @override
  State<ClassMaterialsScreen> createState() => _ClassMaterialsScreenState();
}

class _ClassMaterialsScreenState extends State<ClassMaterialsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,
        title: Text(
          widget.classData.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Pertemuan'),
            Tab(text: 'Materi'),
            Tab(text: 'Tugas'),
            Tab(text: 'Kuis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMeetingsTab(),
          _buildMaterialsTab(),
          _buildAssignmentsTab(),
          _buildQuizzesTab(),
        ],
      ),
    );
  }

  Widget _buildMeetingsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.classData.meetings.length,
      itemBuilder: (context, index) {
        final meeting = widget.classData.meetings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: meeting.isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : const Color(0xFFFF9800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                meeting.isCompleted
                    ? Icons.check_circle
                    : Icons.schedule,
                color: meeting.isCompleted
                    ? Colors.green
                    : const Color(0xFFFF9800),
              ),
            ),
            title: Text(
              meeting.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${meeting.date} • ${meeting.time}'),
                const SizedBox(height: 4),
                Text(meeting.description),
              ],
            ),
            trailing: meeting.isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to meeting details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka pertemuan: ${meeting.title}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMaterialsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.classData.materials.length,
      itemBuilder: (context, index) {
        final material = widget.classData.materials[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description,
                color: Color(0xFFFF9800),
              ),
            ),
            title: Text(
              material.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipe: ${material.type}'),
                const SizedBox(height: 4),
                Text(material.description),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open material
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka materi: ${material.title}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAssignmentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.classData.assignments.length,
      itemBuilder: (context, index) {
        final assignment = widget.classData.assignments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: assignment.status == 'Selesai'
                    ? Colors.green.withOpacity(0.1)
                    : const Color(0xFFFF9800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                assignment.status == 'Selesai'
                    ? Icons.assignment_turned_in
                    : Icons.assignment,
                color: assignment.status == 'Selesai'
                    ? Colors.green
                    : const Color(0xFFFF9800),
              ),
            ),
            title: Text(
              assignment.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${assignment.dueDate}'),
                const SizedBox(height: 4),
                Text('Status: ${assignment.status}'),
                if (assignment.status == 'Dinilai' && assignment.score > 0)
                  Text('Nilai: ${assignment.score}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open assignment
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka tugas: ${assignment.title}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQuizzesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.classData.quizzes.length,
      itemBuilder: (context, index) {
        final quiz = widget.classData.quizzes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: quiz.status == 'Selesai'
                    ? Colors.green.withOpacity(0.1)
                    : const Color(0xFFFF9800).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                quiz.status == 'Selesai'
                    ? Icons.quiz
                    : Icons.quiz_outlined,
                color: quiz.status == 'Selesai'
                    ? Colors.green
                    : const Color(0xFFFF9800),
              ),
            ),
            title: Text(
              quiz.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${quiz.dueDate}'),
                const SizedBox(height: 4),
                Text('Status: ${quiz.status} • ${quiz.totalQuestions} soal'),
                if (quiz.status == 'Dinilai' && quiz.score > 0)
                  Text('Nilai: ${quiz.score}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open quiz
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka kuis: ${quiz.title}')),
              );
            },
          ),
        );
      },
    );
  }
}
