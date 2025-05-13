import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/dashboard/dashboard.dart';
import 'package:nwt_app/services/auth/auth.dart';
import 'package:nwt_app/utils/validators.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  DateTime? selectedDate;
  final TextEditingController dobController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updateProfile() async {
    if (firstNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }
    if (lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your last name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }
    if (selectedDate == null) {
      // AppRouter.showErrorSnackbar(
      //   title: 'Error',
      //   message: 'Please enter a valid date of birth',
      //   position: SnackPosition.BOTTOM,
      // );
      return;
    }

    final response = await AuthService().updateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      dob: selectedDate!,
      onLoading: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
    );

    if (response != null) {
      // AppRouter.showSuccessSnackbar(
      //   title: 'Success',
      //   message: 'Profile updated successfully',
      //   position: SnackPosition.BOTTOM,
      // );
      // Navigator.pop(context);
      Get.to(() => const Dashboard(), transition: Transition.rightToLeft);
    } else {
      // Get.snackbar(
      //   'Error',
      //   'Failed to update profile',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red.withValues(alpha: 0.1),
      //   colorText: Colors.red,
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize with current date if needed
    // selectedDate = DateTime.now();
    // updateDobController();
  }

  @override
  void dispose() {
    dobController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void updateDobController() {
    if (selectedDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Reasonable minimum date
      lastDate: DateTime.now(), // Not allowing future dates for DOB
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: Color(0xFFFFFFFF), // White in dark mode
                    onPrimary: Color(0xFF000000), // Black text on primary
                    surface: Color(0xFF0C0C0C), // Very dark gray surface
                    onSurface: Color(0xFFFFFFFF), // White text on surface
                  )
                : const ColorScheme.light(
                    primary: Color(0xFF000000), // Black in light mode
                    onPrimary: Color(0xFFFFFFFF), // White text on primary
                    surface: Color(0xFFFFFFFF), // White surface
                    onSurface: Color(0xFF000000), // Black text on surface
                  ),
            dialogBackgroundColor: isDarkMode ? const Color(0xFF0C0C0C) : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        updateDobController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left),
            ),
            AppText(
              "Profile",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizing.scaffoldHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(112 / 2),
                          child: CachedNetworkImage(
                            width: 112,
                            height: 112,
                            imageUrl:
                                'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppInputField(
                        controller: firstNameController,
                        hintText: "First Name",
                        labelText: "First Name",
                        validator: AppValidators.validateFirstName,
                        inputFormatters:
                            AppInputFormatters.firstNameFormatters(),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 22),
                      AppInputField(
                        controller: lastNameController,
                        hintText: "Last Name",
                        labelText: "Last Name",
                        validator: AppValidators.validateLastName,
                        inputFormatters:
                            AppInputFormatters.lastNameFormatters(),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 22),
                      AppInputField(
                        controller: dobController,
                        hintText: "DD/MM/YYYY",
                        labelText: "Date of Birth",
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: AppValidators.validateDOB,
                        inputFormatters: AppInputFormatters.dobFormatters(),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Continue',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      isLoading: _isLoading,
                      onPressed: _updateProfile,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
