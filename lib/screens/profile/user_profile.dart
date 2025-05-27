import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/screens/profile/edit_profile.dart';
import 'package:nwt_app/screens/profile/set_pin.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

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
        title: const AppText(
          'User Profile',
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
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
                        AppText(
                          'Virti Sanghavi',
                          variant: AppTextVariant.bodyLarge,
                          weight: AppTextWeight.semiBold,
                          colorType: AppTextColorType.primary,
                        ),
                        SizedBox(height: 4),
                        AppText(
                          '+91 8369535136',
                          variant: AppTextVariant.bodySmall,
                          weight: AppTextWeight.light,
                          colorType: AppTextColorType.primary,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfile()),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Menu items
            _buildMenuItem('Active Connections', () {}),
            _buildMenuItem('Set Pin', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetPin()),
              );
            }),
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
                  const AppText(
                    'Biometric Lock',
                    variant: AppTextVariant.bodyMedium,
                    weight: AppTextWeight.semiBold,
                    colorType: AppTextColorType.primary,
                  ),
                  Switch(
                    value: isBiometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        isBiometricEnabled = value;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 82, 88, 82),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Add logout logic
                },
                child: const AppText(
                  'Log out',
                  variant: AppTextVariant.bodyLarge,
                  weight: AppTextWeight.bold,
                  colorType: AppTextColorType.tertiary,
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
        title: AppText(
          title,
          variant: AppTextVariant.bodyMedium,
          weight: AppTextWeight.semiBold,
          colorType: AppTextColorType.primary,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
