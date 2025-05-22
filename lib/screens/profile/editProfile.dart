import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/utils/validators.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

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
        title: const AppText(
          'Edit Profile',
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
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
              child: AppText(
                "Upload image",
                variant: AppTextVariant.bodySmall,
                weight: AppTextWeight.medium,
                colorType: AppTextColorType.secondary,
              ),
            ),
            const SizedBox(height: 30),

            const AppText(
              'First Name',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.medium,
              colorType: AppTextColorType.secondary,
            ),
            const SizedBox(height: 6),
            AppInputField(
              controller: firstNameController,
              hintText: "First Name",
              validator: AppValidators.validateFirstName,
              inputFormatters: AppInputFormatters.firstNameFormatters(),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),

            const AppText(
              'Last Name',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.medium,
              colorType: AppTextColorType.secondary,
            ),
            const SizedBox(height: 6),
            AppInputField(
              controller: lastNameController,
              hintText: "Last Name",
              validator: AppValidators.validateLastName,
              inputFormatters: AppInputFormatters.lastNameFormatters(),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),

            const AppText(
              'Date of Birth',
              variant: AppTextVariant.bodyMedium,
              weight: AppTextWeight.medium,
              colorType: AppTextColorType.secondary,
            ),
            const SizedBox(height: 6),
            AppInputField(
              controller: dobController,
              hintText: "DD/MM/YYYY",
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: AppValidators.validateDOB,
              inputFormatters: AppInputFormatters.dobFormatters(),
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
              child: const AppText(
                'Continue',
                variant: AppTextVariant.bodyLarge,
                weight: AppTextWeight.bold,
                colorType: AppTextColorType.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
