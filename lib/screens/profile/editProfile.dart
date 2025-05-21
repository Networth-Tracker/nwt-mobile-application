import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 16,height: 24 / 16,letterSpacing: 0,),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text("Upload image", style:TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: Color(0XFF808284),

                    ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'First Name',
              style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: Color(0XFF808284),

                    ),
            ),
            const SizedBox(height: 6),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Last Name',
              style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: Color(0XFF808284),

                    ),
            ),
            const SizedBox(height: 6),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Date of Birth',
              style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: Color(0XFF808284),

                    ),
            ),
            const SizedBox(height: 6),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Add your save logic here
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,fontSize: 16,height: 32 / 16,letterSpacing: 0,),),
            ),
          ],
        ),
      ),
    );
  }
}
