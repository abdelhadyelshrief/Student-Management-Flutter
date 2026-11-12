import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final deptController = TextEditingController();
  final gradeController = TextEditingController();

  List<Map<String, dynamic>> students = [];

  int? editingIndex;

  void addOrUpdateStudent() {
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        deptController.text.isEmpty ||
        gradeController.text.isEmpty)
      return;

    final grade = int.tryParse(gradeController.text) ?? 0;

    setState(() {
      if (editingIndex == null) {
        students.add({
          "id": idController.text,
          "name": nameController.text,
          "dept": deptController.text,
          "grade": grade,
        });
      } else {
        students[editingIndex!] = {
          "id": idController.text,
          "name": nameController.text,
          "dept": deptController.text,
          "grade": grade,
        };
        editingIndex = null;
      }

      clearFields();
    });
  }

  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  void editStudent(int index) {
    final student = students[index];
    setState(() {
      idController.text = student["id"];
      nameController.text = student["name"];
      deptController.text = student["dept"];
      gradeController.text = student["grade"].toString();
      editingIndex = index;
    });
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    deptController.clear();
    gradeController.clear();
  }

  double calculateAverage() {
    if (students.isEmpty) return 0;
    double sum = 0;
    for (var s in students) {
      sum += s["grade"];
    }
    return sum / students.length;
  }

  Color getGradeColor(int grade) {
    if (grade >= 85) return Colors.green.shade100;
    if (grade >= 60) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "ID"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: deptController,
              decoration: const InputDecoration(labelText: "Department"),
            ),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Grade"),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addOrUpdateStudent,
                child: Text(
                  editingIndex == null ? "Add Student" : "Update Student",
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Average Grade: ${calculateAverage().toStringAsFixed(1)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return Card(
                    color: getGradeColor(student["grade"]),
                    child: ListTile(
                      title: Text("${student["name"]} (${student["id"]})"),
                      subtitle: Text(
                        "Dept: ${student["dept"]} | Grade: ${student["grade"]}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editStudent(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteStudent(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
