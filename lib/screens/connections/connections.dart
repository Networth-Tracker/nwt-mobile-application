import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/screens/connections/widgets/connections_card.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
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
              "Connections",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: AppText(
                "Skip",
                variant: AppTextVariant.bodySmall,
                weight: AppTextWeight.semiBold,
                colorType: AppTextColorType.link,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.scaffoldHorizontalPadding,
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svgs/connections/connection.svg"),
                ],
              ),
              SizedBox(height: 42),
              AppText(
                " Connect your accounts to easily track your Networth ",
                variant: AppTextVariant.bodySmall,
                weight: AppTextWeight.medium,
              ),
              SizedBox(height: 20),
              Column(
                spacing: 18,
                children: [
                  ConnectionsCard(
                    icon: Icons.account_balance_outlined,
                    title: "Banks & Investments",
                    addText: "Connect",
                    onAddPressed: () {
                      // Handle add action
                    },
                  ),
                   ConnectionsCard(
                    icon: Icons.account_balance_outlined,
                    title: "Personal Assets",
                    onAddPressed: () {
                      // Handle add action
                    },
                  ),
                  ConnectionsCard(
                    icon: Icons.credit_card_outlined,
                    title: "Credit Cards",
                    isDisabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
