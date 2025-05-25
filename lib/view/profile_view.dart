import 'package:flutter/material.dart';
import 'package:todolist/session_manager/session_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? userEmail;
  bool faceIdEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await SessionManager().getUserEmail();
    setState(() {
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // BG putih
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: userEmail == null
            ? _buildLoginSignupUI(context)
            : _buildProfileUI(context),
      ),
    );
  }

  Widget _buildLoginSignupUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 100, color: Colors.orange),
          const SizedBox(height: 24),
          const Text("You're not logged in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Login"),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.person_add, color: Colors.orange),
              label:
                  const Text("Sign Up", style: TextStyle(color: Colors.orange)),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileUI(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.person, color: Colors.black, size: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userEmail ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const Text('@user', style: TextStyle(color: Colors.white70)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.edit, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildTile(
            Icons.settings, "Account Settings", "Manage your preferences"),
        _buildTile(Icons.fingerprint, "Biometric Security",
            "Use Face ID or Fingerprint",
            trailing: Switch(
              value: faceIdEnabled,
              onChanged: (val) => setState(() => faceIdEnabled = val),
              activeColor: Colors.orange,
            )),
        _buildTile(Icons.verified_user, "Two-Factor Auth",
            "Extra layer of protection"),
        const Divider(height: 40),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: () async {
            await SessionManager().clearUserEmail();
            if (mounted) {
              setState(() => userEmail = null);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle,
      {Widget? trailing}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
