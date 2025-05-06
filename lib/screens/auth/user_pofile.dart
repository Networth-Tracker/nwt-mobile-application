import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nwt_app/common/button_widget.dart';
import 'package:nwt_app/common/input_decorator.dart';
import 'package:nwt_app/common/text_widget.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left),
            ),
            AppText("Profile", variant: AppTextVariant.headline6),
            const Opacity(opacity: 0, child: Icon(Icons.chevron_left)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          AppText(
                            "First Name",
                            variant: AppTextVariant.bodyMedium,
                            colorType: AppTextColorType.secondary,
                            weight: AppTextWeight.medium,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        style: TextStyle(
                          color: AppColors.lightTheme['text']!['primary']!,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: primaryInputDecoration(
                          "First Name",
                          fillColor: Color.fromRGBO(245, 245, 245, 1),
                          borderColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          AppText(
                            "Last Name",
                            variant: AppTextVariant.bodyMedium,
                            colorType: AppTextColorType.secondary,
                            weight: AppTextWeight.medium,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        style: TextStyle(
                          color: AppColors.lightTheme['text']!['primary']!,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: primaryInputDecoration(
                          "Last Name",
                          fillColor: Color.fromRGBO(245, 245, 245, 1),
                          borderColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          AppText(
                            "Date of Birth",
                            variant: AppTextVariant.bodyMedium,
                            colorType: AppTextColorType.secondary,
                            weight: AppTextWeight.medium,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        style: TextStyle(
                          color: AppColors.lightTheme['text']!['primary']!,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: primaryInputDecoration(
                          "DD/MM/YYYY",
                          fillColor: Color.fromRGBO(245, 245, 245, 1),
                          borderColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizing.scaffoldHorizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Continue',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      onPressed: () {},
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