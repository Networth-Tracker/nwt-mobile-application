import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MFSearch extends StatefulWidget {
  const MFSearch({Key? key}) : super(key: key);

  @override
  State<MFSearch> createState() => _MFSearchState();
}

class _MFSearchState extends State<MFSearch> {
  String selectedFilter = 'Mutual Funds';
  final TextEditingController _searchController = TextEditingController(text: 'Bajaj');

  final List<String> filterOptions = ['All', 'Stocks', 'Mutual Funds', 'ETF'];

  final List<String> bajajFunds = [
    "Bajaj Finserv Large Cap Fund Direct Growth",
    "Bajaj Finserv Overnight Fund Direct Growth",
    "Bajaj Finserv Multi Cap Fund Direct Growth",
    "Bajaj Finserv Arbitrage Fund Direct Growth",
    "Bajaj Finserv Money Market Fund Direct Growth",
    "Bajaj Finserv Healthcare Fund Direct Growth",
  ];

  final List<String> trendingFunds = [
    "Parag Parikh Flexi Cap Direct Growth",
    "Bandhan Small Cap Fund",
    "ITI Small Cap Fund",
    "ICICI Midcap Fund",
    "Invesco India Mid Cap Fund",
    "Nippon India Growth Fund",
    "Axis Midcap Fund",
    "Tata Midcap Fund",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
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

              // Horizontal Filter Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterOptions.map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterTab(label),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Search Results
              ...bajajFunds.map(
                (fund) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.show_chart, color: Colors.white, size: 18),
                      const SizedBox(width: 15),
                      Expanded(
                        child: AppText(
                          fund,
                          variant: AppTextVariant.bodySmall,
                          colorType: AppTextColorType.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Trending Section
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 20),
                  const SizedBox(width:15),
                  AppText(
                    "Trending Searches",
                    variant: AppTextVariant.bodyMedium,
                    colorType: AppTextColorType.primary,
                    weight: AppTextWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Trending Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3,
                  children: trendingFunds
                      .map(
                        (title) => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up, color: Colors.grey, size: 16),
                              const SizedBox(width: 14),
                              Expanded(
                                child: AppText(
                                  title,
                                  variant: AppTextVariant.bodySmall,
                                  colorType: AppTextColorType.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title) {
    final bool isSelected = (selectedFilter == title);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFfcfcfc) : const Color(0xFF1E1E1E),
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
