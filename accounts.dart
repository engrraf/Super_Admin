import 'package:flutter/material.dart';
void main() {
  runApp(const AccountsScreen());
}

// Import AccountsScreen
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FacultyMembersPage(),
    );
  }
}



class FacultyMembersPage extends StatefulWidget {
  const FacultyMembersPage({super.key});

  @override
  State<FacultyMembersPage> createState() => _FacultyMembersPageState();
}

class _FacultyMembersPageState extends State<FacultyMembersPage> {
  final List<Faculty> facultyList = [
    Faculty(name: 'Joy Masiyahin', email: 'joy@example.com', password: 'joypass', color: Colors.yellow, imagePath: 'assets/images/joy.png'),
    Faculty(name: 'Sadness Malungkot', email: 'sadness@example.com', password: 'sadpass', color: Colors.blue, imagePath: 'assets/images/sadness.png'),
    Faculty(name: 'Fear Duwag', email: 'fear@example.com', password: 'fearpass', color: Colors.purple, imagePath: 'assets/images/fear.png'),
    Faculty(name: 'Anger Galit', email: 'anger@example.com', password: 'angerpass', color: Colors.red, imagePath: 'assets/images/anger.png'),
    Faculty(name: 'Disgust Yuck', email: 'disgust@example.com', password: 'disgustpass', color: Colors.green, imagePath: 'assets/images/disgust.png'),
  ];

  final List<Faculty> pendingFacultyList = [
    Faculty(name: 'Hope Pagasa', email: 'hope@example.com', password: 'hopepass', color: Colors.orange, imagePath: 'assets/images/anxiety.png'),
    Faculty(name: 'Brave Matapang', email: 'brave@example.com', password: 'bravepass', color: Colors.brown, imagePath: 'assets/images/jasper2.png'),
  ];

  void _navigateToAccountsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountsScreen()),
    );
  }

  void _editAccount(List<Faculty> list, int index) {
    final faculty = list[index];
    final nameController = TextEditingController(text: faculty.name);
    final emailController = TextEditingController(text: faculty.email);
    final passwordController = TextEditingController(text: faculty.password);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  list[index] = Faculty(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    color: faculty.color,
                    imagePath: faculty.imagePath,
                  );
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SALI-SEEK'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF2C9B44)),
            onPressed: () => _navigateToAccountsScreen(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/plsp.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Pamantasan ng Lungsod ng San Pablo\nCollege of Computer Studies and Technology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/ccst1.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              itemCount: facultyList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 6,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                final faculty = facultyList[index];
                return FacultyCard(
                  name: faculty.name,
                  email: faculty.email,
                  password: faculty.password,
                  color: faculty.color,
                  imagePath: faculty.imagePath,
                  onEdit: () => _editAccount(facultyList, index),
                  height: 200,
                  width: 200,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FacultyCard extends StatelessWidget {
  final String name;
  final String email;
  final String password;
  final Color color;
  final String imagePath;
  final VoidCallback onEdit;
  final double height;
  final double width;

  const FacultyCard({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.color,
    required this.imagePath,
    required this.onEdit,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: color,
              child: Image.asset(imagePath, width: 500, height: 500),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Faculty {
  final String name;
  String email;
  String password;
  final Color color;
  final String imagePath;

  Faculty({
    required this.name,
    required this.email,
    required this.password,
    required this.color,
    required this.imagePath,
  });
}
