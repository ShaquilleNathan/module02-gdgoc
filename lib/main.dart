import 'package:flutter/material.dart';
import 'explorer.dart';

Future<Explorer> fetchExplorer(String id) async {
  if (id.isEmpty) throw Exception('Error: Explorer ID cannot be empty');
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

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GDGoC Profile Card',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: ProfileCardScreen(
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class ProfileCardScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ProfileCardScreen({super.key, required this.isDarkMode, required this.onThemeToggle});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  Explorer? explorerData;
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _skillController = TextEditingController();
  
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
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

  Future<void> _connect() async {
    setState(() {
      isConnecting = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isConnecting = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Successfully connected with Explorer!'),
          backgroundColor: widget.isDarkMode ? Colors.tealAccent[700] : Colors.teal,
        ),
      );
    }
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        explorerData!.skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey[200],
      appBar: AppBar(
        title: const Text('Explorer Profile Card', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          )
        ],
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
      color: widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              '${explorerData!.track} Track | Age: ${explorerData!.age}',
              style: TextStyle(fontSize: 16, color: widget.isDarkMode ? Colors.tealAccent : Colors.teal),
            ),
            const Divider(height: 32, color: Colors.grey),
            Text(
              'Bio: ${explorerData!.bio ?? 'No bio provided.'}',
              style: TextStyle(fontSize: 14, color: widget.isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${explorerData!.email ?? 'No email provided.'}',
              style: TextStyle(fontSize: 14, color: widget.isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Top Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
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
                    leading: Icon(Icons.speed, color: widget.isDarkMode ? Colors.tealAccent : Colors.teal),
                    title: Text(
                      explorerData!.skills[index],
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Add a new skill (e.g. Reverse Engineering)',
                      hintStyle: TextStyle(color: widget.isDarkMode ? Colors.white54 : Colors.black54),
                      isDense: true,
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.teal),
                  onPressed: _addSkill,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDarkMode ? Colors.tealAccent[700] : Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isConnecting ? null : _connect,
                child: isConnecting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Connect', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}