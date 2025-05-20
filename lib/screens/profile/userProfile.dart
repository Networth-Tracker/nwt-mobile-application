// profile/userProfile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('User Profile',
        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 16,height: 32 / 16,letterSpacing: 0,),
      ),

        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile section
       Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF17181A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const AssetImage('assets/images/avatar.png'),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Virti Sanghavi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: 0,
                              color: Color(0xFFFCFCFC),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '+91 8369535136',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              height: 24 / 12,
                              letterSpacing: 0,
                              color: Color(0xFFFCFCFC),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit, color: Colors.white),
//                     IconButton(
//   icon: const Icon(Icons.edit, color: Colors.white),
//   onPressed: () {
//     Get.to(() => EditProfileScreen()); // Replace with your screen
//   },
// ),

                  ],
                ),
              ),
              const SizedBox(height: 20),


            // Menu items
            _buildMenuItem('Active Connections', () {}),
            _buildMenuItem('Set Pin', () {}),
            _buildMenuItem('Help & FAQ', () {}),
            _buildMenuItem('Data Protection', () {}),
            _buildMenuItem('Privacy Policy', () {}),
            _buildMenuItem('Terms of use', () {}),

            // Biometric toggle
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF17181A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Biometric Lock',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: Color(0xFFFCFCFC),
                    ),
                  ),
                  Switch(
                    value: isBiometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        isBiometricEnabled = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),


            const Spacer(),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Add logout logic
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 32 / 16,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildMenuItem(String title, VoidCallback onTap) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF17181A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 24 / 14,
              letterSpacing: 0,
              color: Color(0xFFFCFCFC),
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          onTap: onTap,
        ),
      );
    }
    }
