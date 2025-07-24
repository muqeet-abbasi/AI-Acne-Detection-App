import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/controllers/profile_controllers.dart';
import 'package:acne_detection_app/view/widgets/scan_history_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (_controller.user.value != null) {
            final user = _controller.user.value!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${user.name}',
                          style: TextStyle(
                            fontSize: 16,
                            color: darkGrayText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Age: ${user.age}',
                          style: TextStyle(
                            fontSize: 16,
                            color: darkGrayText.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Skin Type: ${user.skinType}',
                          style: TextStyle(
                            fontSize: 16,
                            color: darkGrayText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Scan History Section
                // const Text(
                //   'Scan History',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Column(
                //   children: user.scanHistory
                //       .map(
                //         (scan) => ScanHistoryItem(scan: scan),
                //       )
                //       .toList(),
                // ),
                // const SizedBox(height: 20),

                // Settings Section
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Dark Mode Toggle
                        ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text('Dark Mode'),
                          trailing: Switch(
                            value: _controller.isDarkMode.value,
                            onChanged: (value) {
                              _controller.toggleDarkMode();
                            },
                          ),
                        ),
                        // Delete Data Option
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete User Data'),
                          onTap: _controller.deleteUserData,
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text(
                            'Logout',
                          ),
                          textColor: const Color.fromARGB(255, 241, 25, 10),
                          iconColor: const Color.fromARGB(255, 241, 25, 10),
                          onTap: () {
                            _controller.logoutUser();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No user data available.'),
            );
          }
        }),
      ),
    );
  }
}
