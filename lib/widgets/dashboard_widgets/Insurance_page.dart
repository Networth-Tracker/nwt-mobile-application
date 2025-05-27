import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';
import 'package:nwt_app/widgets/dashboard_widgets/bank_insurance.dart';


class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const AppText(
          'Insurance',
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coverage card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Your Coverage',
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                      SizedBox(height: 5),
                      AppText(
                        '₹ 4,00,000',
                        variant: AppTextVariant.headline1,
                        weight: AppTextWeight.bold,
                        colorType: AppTextColorType.primary,
                      ),
                    ],
                  ),
                  const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),

          // Tabs - Scrollable version
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  _buildTab('All'),
                  const SizedBox(width: 8),
                  _buildTab('Life Insurance'),
                  const SizedBox(width: 8),
                  _buildTab('General Insurance'),
                  const SizedBox(width: 8),
                  _buildTab('Term Insurance'),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),


            const SizedBox(height: 20),

            // List of policies
            Expanded(
              child: ListView(
                children: const [
                  _PolicyCard(
                    bankName: 'HDFC Bank Unit Linked Endowment Plus',
                    policyNumber: '214563842526',
                    amount: '₹1,00,000',
                  ),
                  SizedBox(height: 15),
                  _PolicyCard(
                    bankName: 'HDFC Bank Unit Linked Endowment Plus',
                    policyNumber: '214563842526',
                    amount: '₹1,00,000',
                  ),
                  SizedBox(height: 15),
                  _PolicyCard(
                    bankName: 'HDFC Bank Unit Linked Endowment Plus',
                    policyNumber: '214563842526',
                    amount: '₹1,00,000',
                  ),
                  SizedBox(height: 15),
                  _PolicyCard(
                    bankName: 'HDFC Bank Unit Linked Endowment Plus',
                    policyNumber: '214563842526',
                    amount: '₹1,00,000',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              debugPrint('Track Insurance button pressed!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCFCFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: const AppText(
              'Track Insurance',
              variant: AppTextVariant.bodyLarge,
              weight: AppTextWeight.bold,
              colorType: AppTextColorType.tertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    bool isSelected = (_selectedTab == title);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ?const Color(0xFFfcfcfc) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AppText(
          title,
          variant: AppTextVariant.bodyMedium,
          weight: isSelected ? AppTextWeight.bold : AppTextWeight.semiBold,
          colorType: isSelected ? AppTextColorType.tertiary : AppTextColorType.primary,
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String bankName;
  final String policyNumber;
  final String amount;

  const _PolicyCard({
    required this.bankName,
    required this.policyNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.account_balance, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const BankInsurance()); // Navigate on tap
                        },
                child: AppText(
                  bankName,
                  variant: AppTextVariant.bodyLarge,
                  weight: AppTextWeight.regular,
                  colorType: AppTextColorType.primary,
                ),
              ),
                const SizedBox(height: 5),
                 RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Policy No: ',
                        style: TextStyle(
                          fontSize: 12, // Matches AppTextVariant.bodySmall
                          fontWeight: FontWeight.w400, // Matches AppTextWeight.regular
                          color: Color(0xFF48AEE4), // Blue like AppTextColorType.link
                        ),
                      ),
                      TextSpan(
                        text: policyNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF8B8B8B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppText(
            amount,
            variant: AppTextVariant.bodyLarge,
            weight: AppTextWeight.bold,
            colorType: AppTextColorType.primary,
          ),
        ],
      ),
    );
  }
}
