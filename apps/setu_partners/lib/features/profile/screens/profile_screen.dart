import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),

            const SizedBox(height: 16),

            // Name
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            const Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // Info Cards
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: const Text('+91 9876543210'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Location'),
                subtitle: const Text('Mumbai, India'),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Profession'),
                subtitle: const Text('Software Developer'),
              ),
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add logout logic here
                },
                child: const Text('Logout'),
              ),
            )
          ],
        ),
      ),
    );
  }
}