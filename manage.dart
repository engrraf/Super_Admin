import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppInitializer());
}

class AppInitializer extends StatelessWidget {
  Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: 'https://eqaqizznngarxghlrpul.supabase.co',
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxYXFpenpubmdhcnhnaGxycHVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAyODk5MzgsImV4cCI6MjA0NTg2NTkzOH0.gCKoYLBnY0em8c0WnaWFCdukjgMvWiOmZgGzIstb8Kk',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeSupabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Failed to initialize supabase: ${snapshot.error}'),
              ),
            ),
          );
        }
        return MyApp();
      },
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Students',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ManageStudentsScreen(),
    );
  }
}

class ManageStudentsScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> pendingStudents = [];
  List<Map<String, dynamic>> approvedStudents = [];
  double _studentFontSize = 25.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchStudents(); // Fetch students on initialization
  }

  Future<void> fetchStudents() async {
    try {
      final response = await supabase.from('students').select().execute();

      if (response.status == 200 && response.data != null) {
        final data = response.data as List<dynamic>;

        setState(() {
          pendingStudents = data
              .where((student) => student['Status'] == 'pending')
              .toList()
              .cast<Map<String, dynamic>>(); // Ensure correct casting
          approvedStudents = data
              .where((student) => student['Status'] == 'approved')
              .toList()
              .cast<Map<String, dynamic>>(); // Ensure correct casting
        });
      } else {
        print('Error fetching students: ${response.status}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> updateStudentStatus(int studentId, String status) async {
    try {
      final response = await supabase
          .from('students')
          .update({'Status': status})
          .eq('id', studentId)
          .execute();

      if (response.status == 200) {
        fetchStudents(); // Refresh the list after updating
      } else {
        print('Error updating Status: ${response.status}');
      }
    } catch (e) {
      print('Error updating Status: $e');
    }
  }

  Widget buildHeader() {
    double screenWidth = MediaQuery.of(context).size.width;
    double mainFontSize = screenWidth < 800 ? 22.0 : 28.0;
    double subFontSize = screenWidth < 800 ? 14.0 : 18.0;
    double padding = screenWidth < 600 ? 12.0 : 16.0;
    double iconSize = screenWidth < 600 ? 50.0 : 70.0;

    return Container(
      color: const Color(0xFFF2F8FC),
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/plsp.png',
            width: iconSize,
            height: iconSize,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PAMANTASAN NG LUNGSOD NG SAN PABLO',
                style: TextStyle(
                  fontSize: mainFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                'College of Computer Studies and Technology',
                style: TextStyle(
                  fontSize: subFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/image/ccst.png',
            width: iconSize,
            height: iconSize,
          ),
        ],
      ),
    );
  }

  Widget buildYearTab(String year) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$year - Pending Students',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: pendingStudents
                        .map((student) => buildPendingStudent(student))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 20, thickness: 1, color: Colors.grey),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$year - Approved',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: approvedStudents
                        .map(
                          (student) => ListTile(
                        title: Text(student['name'],
                            style: TextStyle(fontSize: _studentFontSize)),
                        leading: Icon(Icons.person),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPendingStudent(Map<String, dynamic> student) {
    return ListTile(
      title: Text(student['name'], style: TextStyle(fontSize: _studentFontSize)),
      leading: Icon(Icons.person),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () {
              updateStudentStatus(student['id'], 'approved');
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              updateStudentStatus(student['id'], 'pending');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '1st Year'),
              Tab(text: '2nd Year'),
              Tab(text: '3rd Year'),
              Tab(text: '4th Year'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildYearTab('1st Year'),
                buildYearTab('2nd Year'),
                buildYearTab('3rd Year'),
                buildYearTab('4th Year'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
