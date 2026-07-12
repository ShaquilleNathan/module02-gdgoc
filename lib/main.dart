import 'package:flutter/material.dart';
import 'explorer.dart'; 

Future<Explorer> fetchExplorer(String id) async {
  if (id.isEmpty) {
    throw Exception('Error: Explorer ID cannot be empty');
  }

  await Future.delayed(const Duration(seconds: 2));

  return Explorer(
    name: 'Shaquille Nathan Kalevi',
    age: 19, 
    track: 'Mobile Development',
    skills: ['Flutter', 'React', 'Cybersecurity', 'IoT'],
    bio: 'Passionate about building webs and mobile apps.',
    email: '13525023@std.stei.itb.ac.id',
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDGoC Profile Card',
      theme: ThemeData.dark(), 
      home: const ProfileCardScreen(),
    );
  }
}

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  Explorer? explorerData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await fetchExplorer('GDGOC2026');
      setState(() {
        explorerData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), 
      appBar: AppBar(
        title: const Text('Explorer Profile Card', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.tealAccent) 
            : errorMessage != null
                ? Text(errorMessage!, style: const TextStyle(color: Colors.redAccent))
                : _buildProfileCard(),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 8,
      color: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              explorerData!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              '${explorerData!.track} Track | Age: ${explorerData!.age}',
              style: const TextStyle(fontSize: 16, color: Colors.tealAccent),
            ),
            const Divider(height: 32, color: Colors.grey),
            Text(
              'Bio: ${explorerData!.bio ?? 'No bio provided.'}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${explorerData!.email ?? 'No email provided.'}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Top Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true, 
                itemCount: explorerData!.skills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(Icons.speed, color: Colors.tealAccent),
                    title: Text(
                      explorerData!.skills[index],
                      style: const TextStyle(color: Colors.white),
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