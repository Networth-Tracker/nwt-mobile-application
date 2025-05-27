import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class BankInsurance extends StatelessWidget {
  const BankInsurance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Set app bar background to black
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
        title: const AppText(
          'Insurance', // Changed title to 'Insurance' as per image
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
             child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Placeholder for the HDFC Bank Logo
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
                    const SizedBox(height: 10),
                    const AppText(
                      'HDFC Bank Unit Linked\nEndowment Plus',
                      variant: AppTextVariant.bodyLarge,
                      weight: AppTextWeight.bold,
                      colorType: AppTextColorType.primary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Details List
            _buildDetailCard(
              context,
              label: 'Premium Amount:',
              value: '₹1,00,000',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Premium Frequency:',
              value: 'Quarterly',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Sum Assured:',
              value: '₹1,00,000',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Policy No:',
              value: '214563842526',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Start Date:',
              value: '20-05-2022',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Premium Payment Years:',
              value: '5',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Next Premium Date:',
              value: '10-06-2025',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Policy Type:',
              value: 'Term',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Tenure Years:',
              value: '12',
            ),
            const SizedBox(height: 15),
            _buildDetailCard(
              context,
              label: 'Maturity Date:',
              value: '15-12-2025',
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark grey background
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            variant: AppTextVariant.bodyLarge,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.secondary, // Assuming secondary maps to light grey
          ),
          AppText(
            value,
            variant: AppTextVariant.bodyLarge,
            weight: AppTextWeight.semiBold,
            colorType: AppTextColorType.primary, // Assuming primary maps to white
          ),
        ],
      ),
    );
  }
}