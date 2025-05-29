import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/custom_accordion.dart';

class FundsDistributionWidget extends StatefulWidget {
  const FundsDistributionWidget({super.key});

  @override
  State<FundsDistributionWidget> createState() =>
      _FundsDistributionWidgetState();
}

class _FundsDistributionWidgetState extends State<FundsDistributionWidget> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Equity', 'Debt & Cash'];

  @override
  Widget build(BuildContext context) {
    return CustomAccordion(
      title: 'Funds Distribution',
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs for Equity and Debt & Cash
          _buildTabs(),
          const SizedBox(height: 24),

          // Size Breakup section
          _buildSizeBreakup(),
          const SizedBox(height: 24),

          // Size categories with percentages
          _buildSizeCategories(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _selectedTabIndex == index
                          ? Colors.white
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        _selectedTabIndex == index
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeBreakup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Size Breakup',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '97.9%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3ABFF8), // Light blue color
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Progress bars
        Stack(
          children: [
            // Base bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            // Mid Cap (Light blue)
            FractionallySizedBox(
              widthFactor: 0.6, // 60% width
              child: Container(
                height: 8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                  color: Color(0xFF3ABFF8), // Light blue
                ),
              ),
            ),
            // Large Cap (Pink)
            Positioned(
              left:
                  MediaQuery.of(context).size.width *
                  0.6 *
                  0.7, // Adjust based on screen width
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25, // 25% width
                height: 8,
                color: const Color(0xFFD926AA), // Pink
              ),
            ),
            // Small Cap (Yellow)
            Positioned(
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.1, // 10% width
                height: 8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                  color: Color(0xFFFBBD23), // Yellow
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeCategories() {
    return Column(
      children: [
        _buildSizeCategory('Mid Cap', '48.2%', const Color(0xFF3ABFF8)),
        const SizedBox(height: 16),
        _buildSizeCategory('Large Cap', '40.5%', const Color(0xFFD926AA)),
        const SizedBox(height: 16),
        _buildSizeCategory('Small Cap', '5.8%', const Color(0xFFFBBD23)),
      ],
    );
  }

  Widget _buildSizeCategory(String name, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
