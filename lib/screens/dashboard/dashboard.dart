import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/avatar.dart';
import 'package:nwt_app/constants/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.zero,
        automaticallyImplyLeading: false,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      const Avatar(
                        path:
                            'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by-1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        width: 45,
                        height: 45,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            "Hi, Darshan",
                            variant: AppTextVariant.headline4,
                            weight: AppTextWeight.bold,
                          ),
                          const AppText(
                            "Good Morning !",
                            variant: AppTextVariant.bodySmall,
                            weight: AppTextWeight.semiBold,
                            colorType: AppTextColorType.gray,
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
               IconButton(
                 onPressed: (){}, 
                 icon: Icon(Icons.notifications_outlined),
                 style: ButtonStyle(
                   backgroundColor: WidgetStatePropertyAll(AppColors.darkRoundedButtonBackground),
                   iconColor: WidgetStatePropertyAll(AppColors.darkTextGray),
                   side: WidgetStateBorderSide.resolveWith((states) {
                     return const BorderSide(
                       color: AppColors.darkButtonBorder,
                       width: 1,
                       
                     );
                   })
                 ),
               )
            ],
          ),
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.darkRoundedButtonBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.darkButtonBorder)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Your Networth",
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.tertiary,
                      ),
                      AppText(
                        "Last Data Fetched at 11:00pm",
                        variant: AppTextVariant.tiny,
                        weight: AppTextWeight.semiBold,
                        colorType: AppTextColorType.tertiary,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      AppText(
                        "₹ 1,00,000",
                        variant: AppTextVariant.display,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ))
    );
  }
}