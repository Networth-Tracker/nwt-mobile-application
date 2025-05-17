import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/data/categories/categories.dart';
import 'package:nwt_app/constants/data/categories/categories.types.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/controllers/transactions/banks/transactions.dart';
import 'package:nwt_app/screens/transactions/banks/widgets/transaction_card.dart';
import 'package:nwt_app/screens/transactions/banks/types/transaction.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class Bank {
  final String id;
  final String name;
  final String accountNumber;
  final IconData icon;
  bool isSelected;
  bool isPrimary;

  Bank({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.icon,
    this.isSelected = false,
    this.isPrimary = false,
  });
}

class FilterCategories extends Category {
  bool isSelected;

  FilterCategories({
    required super.id,
    required super.name,
    super.parentId,
    this.isSelected = false,
  });

  // Helper to check if this is a main category
  bool get isMainCategory => parentId == null;
}

class BankTransactionListScreen extends StatefulWidget {
  const BankTransactionListScreen({super.key});

  @override
  State<BankTransactionListScreen> createState() =>
      _BankTransactionListScreenState();
}

class _BankTransactionListScreenState extends State<BankTransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isTransactionsLoading = false;
  final bankTransactionController = Get.put(BankTransactionController());
  void getTransactions() {
    bankTransactionController.getBankTransactions(
      bankGUID: "B_1747388324308",
      onLoading: (isLoading) {
        if (mounted) {
          setState(() {
            isTransactionsLoading = isLoading;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter state variables
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedDateRange = '30 days';
  double _minAmount = 0;
  double _maxAmount = 10000;

  // Categories list with hierarchical structure

  final List<Bank> _banks = [
    Bank(
      id: '1',
      name: 'HDFC Bank',
      accountNumber: 'XXXX 1234',
      icon: Icons.account_balance,
      isPrimary: false,
    ),
    Bank(
      id: '2',
      name: 'ICICI Bank',
      accountNumber: 'XXXX 5678',
      icon: Icons.account_balance,
      isPrimary: false,
    ),
    Bank(
      id: '3',
      name: 'SBI',
      accountNumber: 'XXXX 9012',
      icon: Icons.account_balance,
      isPrimary: false,
    ),
    Bank(
      id: '4',
      name: 'Axis Bank',
      accountNumber: 'XXXX 3456',
      icon: Icons.account_balance,
      isPrimary: true,
    ),
  ];
  final List<Category> _categories = categories;
  List<Bank> get selectedBanks =>
      _banks.where((bank) => bank.isSelected).toList();

  // Store selected categories
  final List<FilterCategories> _selectedFilterCategories = [];

  List<FilterCategories> get selectedCategories => _selectedFilterCategories;

  Widget _buildBankChip(Bank bank, [StateSetter? setModalState]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkButtonBorder,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(bank.icon, size: 14, color: AppColors.darkTextMuted),
          const SizedBox(width: 4),
          AppText(
            bank.name,
            variant: AppTextVariant.bodySmall,
            colorType: AppTextColorType.primary,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              bank.isSelected = false;
              setState(() {});
              if (setModalState != null) {
                setModalState(() {});
              }
            },
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.darkTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    FilterCategories category, [
    StateSetter? setModalState,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkButtonBorder,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            category.name,
            variant: AppTextVariant.bodySmall,
            colorType: AppTextColorType.primary,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterCategories.removeWhere(
                  (cat) => cat.id == category.id,
                );
              });
              if (setModalState != null) {
                setModalState(() {});
              }
            },
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.darkTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showBankSelectionBottomSheet(
    BuildContext context,
    StateSetter setModalState,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.darkInputBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Select Banks",
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.semiBold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _banks.length,
                      separatorBuilder: (context, index) => const SizedBox(),
                      itemBuilder: (context, index) {
                        final bank = _banks[index];
                        return Banner(
                          message: bank.isPrimary ? 'Primary' : '',
                          location: BannerLocation.topStart,
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.darkButtonBorder,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                bank.icon,
                                color: AppColors.darkTextMuted,
                              ),
                            ),
                            title: AppText(
                              bank.name,
                              variant: AppTextVariant.bodyLarge,
                              weight: AppTextWeight.medium,
                            ),
                            subtitle: AppText(
                              bank.accountNumber,
                              variant: AppTextVariant.bodySmall,
                              colorType: AppTextColorType.secondary,
                            ),
                            trailing:
                                bank.isSelected
                                    ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : null,
                            onTap: () {
                              setBottomSheetState(() {
                                bank.isSelected = !bank.isSelected;
                              });
                              setModalState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: () => Navigator.pop(context),
                      variant: AppButtonVariant.primary,
                      text: "Done",
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCategorySelectionBottomSheet(
    BuildContext context,
    StateSetter setModalState,
  ) {
    // Create a temporary list to track selections during the bottom sheet session
    final List<FilterCategories> tempSelectedCategories = List.from(
      _selectedFilterCategories,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            // Group categories by their parent
            final Map<String?, List<Category>> groupedCategories = {};

            // Initialize with empty lists for each parent type
            groupedCategories[null] = [];

            // Group categories by parent
            for (final category in _categories) {
              if (!groupedCategories.containsKey(category.parentId)) {
                groupedCategories[category.parentId] = [];
              }
              groupedCategories[category.parentId]!.add(category);
            }

            // Get main categories (those without a parent)
            final mainCategories = groupedCategories[null] ?? [];

            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      AppText(
                        "Select Categories",
                        variant: AppTextVariant.headline4,
                        weight: AppTextWeight.semiBold,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: mainCategories.length,
                      itemBuilder: (context, index) {
                        final mainCategory = mainCategories[index];
                        final subCategories =
                            groupedCategories[mainCategory.id] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main category header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: AppText(
                                mainCategory.name,
                                variant: AppTextVariant.bodyLarge,
                                weight: AppTextWeight.semiBold,
                              ),
                            ),
                            // Subcategories
                            ...subCategories.map((subCategory) {
                              // Check if this category is selected
                              final isSelected = tempSelectedCategories.any(
                                (cat) => cat.id == subCategory.id,
                              );

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.darkInputBackground,
                                ),
                                child: ListTile(
                                  title: AppText(
                                    subCategory.name,
                                    variant: AppTextVariant.bodyMedium,
                                  ),
                                  trailing:
                                      isSelected
                                          ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                          : null,
                                  onTap: () {
                                    setBottomSheetState(() {
                                      // Find if this category is already selected
                                      final existingIndex =
                                          tempSelectedCategories.indexWhere(
                                            (cat) => cat.id == subCategory.id,
                                          );

                                      if (existingIndex >= 0) {
                                        // If already selected, remove it
                                        tempSelectedCategories.removeAt(
                                          existingIndex,
                                        );
                                      } else {
                                        // If not selected, add it
                                        tempSelectedCategories.add(
                                          FilterCategories(
                                            id: subCategory.id,
                                            name: subCategory.name,
                                            parentId: subCategory.parentId,
                                            isSelected: true,
                                          ),
                                        );
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: () {
                        // Update the actual selected categories list
                        setModalState(() {
                          _selectedFilterCategories.clear();
                          _selectedFilterCategories.addAll(
                            tempSelectedCategories,
                          );
                        });
                        Navigator.pop(context);
                      },
                      variant: AppButtonVariant.primary,
                      text: "Done",
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void openFilterBottomsheet() {
    // Initialize dates based on selected date range if not already set
    final now = DateTime.now();
    if (_selectedDateRange == "30 days") {
      _startDate = now.subtract(const Duration(days: 30));
    } else if (_selectedDateRange == "60 days") {
      _startDate = now.subtract(const Duration(days: 60));
    } else if (_selectedDateRange == "90 days") {
      _startDate = now.subtract(const Duration(days: 90));
    }
    _endDate = now;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Scaffold(
                backgroundColor: AppColors.darkBackground,
                appBar: AppBar(
                  backgroundColor: AppColors.darkBackground,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: AppText(
                    "Filter",
                    variant: AppTextVariant.headline4,
                    weight: AppTextWeight.semiBold,
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizing.scaffoldHorizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            AppText(
                              "Banks",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap:
                                  () => _showBankSelectionBottomSheet(
                                    context,
                                    setModalState,
                                  ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                constraints: BoxConstraints(minHeight: 60),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.darkButtonBorder,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (selectedBanks.isEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            "Select Banks",
                                            variant: AppTextVariant.bodyMedium,
                                            colorType: AppTextColorType.primary,
                                          ),
                                          const Icon(Icons.keyboard_arrow_down),
                                        ],
                                      ),
                                    if (selectedBanks.isNotEmpty) ...[
                                      // const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            selectedBanks
                                                .map(
                                                  (bank) => _buildBankChip(
                                                    bank,
                                                    setModalState,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppText(
                              "Date Range",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            Row(
                              spacing: 12,
                              children: [
                                ChoiceChip(
                                  selected: _selectedDateRange == "30 days",
                                  showCheckmark: false,
                                  surfaceTintColor: AppColors.darkButtonBorder,
                                  backgroundColor: AppColors.darkButtonBorder,
                                  selectedColor: AppColors.darkButtonBorder,
                                  disabledColor: AppColors.darkButtonBorder,
                                  side: BorderSide(
                                    color:
                                        _selectedDateRange == "30 days"
                                            ? Colors.white
                                            : AppColors.darkButtonBorder,
                                    width:
                                        _selectedDateRange == "30 days"
                                            ? 1.5
                                            : 1.0,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      final now = DateTime.now();
                                      final startDate = now.subtract(
                                        const Duration(days: 30),
                                      );

                                      setModalState(() {
                                        _startDate = startDate;
                                        _endDate = now;
                                        _selectedDateRange = "30 days";
                                      });
                                    }
                                  },
                                  label: AppText(
                                    "30 days",
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                  ),
                                ),
                                ChoiceChip(
                                  selected: _selectedDateRange == "60 days",
                                  showCheckmark: false,
                                  surfaceTintColor: AppColors.darkButtonBorder,
                                  backgroundColor: AppColors.darkButtonBorder,
                                  selectedColor: AppColors.darkButtonBorder,
                                  disabledColor: AppColors.darkButtonBorder,
                                  side: BorderSide(
                                    color:
                                        _selectedDateRange == "60 days"
                                            ? Colors.white
                                            : AppColors.darkButtonBorder,
                                    width:
                                        _selectedDateRange == "60 days"
                                            ? 1.5
                                            : 1.0,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      final now = DateTime.now();
                                      final startDate = now.subtract(
                                        const Duration(days: 60),
                                      );

                                      setModalState(() {
                                        _startDate = startDate;
                                        _endDate = now;
                                        _selectedDateRange = "60 days";
                                      });
                                    }
                                  },
                                  label: AppText(
                                    "60 days",
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                  ),
                                ),
                                ChoiceChip(
                                  selected: _selectedDateRange == "90 days",
                                  showCheckmark: false,
                                  surfaceTintColor: AppColors.darkButtonBorder,
                                  backgroundColor: AppColors.darkButtonBorder,
                                  selectedColor: AppColors.darkButtonBorder,
                                  disabledColor: AppColors.darkButtonBorder,
                                  side: BorderSide(
                                    color:
                                        _selectedDateRange == "90 days"
                                            ? Colors.white
                                            : AppColors.darkButtonBorder,
                                    width:
                                        _selectedDateRange == "90 days"
                                            ? 1.5
                                            : 1.0,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      final now = DateTime.now();
                                      final startDate = now.subtract(
                                        const Duration(days: 90),
                                      );

                                      setModalState(() {
                                        _startDate = startDate;
                                        _endDate = now;
                                        _selectedDateRange = "90 days";
                                      });
                                    }
                                  },
                                  label: AppText(
                                    "90 days",
                                    variant: AppTextVariant.bodySmall,
                                    weight: AppTextWeight.semiBold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            AppText(
                              "Select Date",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppInputField(
                                    controller: TextEditingController(
                                      text:
                                          _startDate == null
                                              ? ""
                                              : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                                    ),
                                    hintText: "Start Date",
                                    readOnly: true,
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _startDate ?? DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                          );
                                      if (picked != null) {
                                        setModalState(() {
                                          _startDate = picked;
                                        });
                                      }
                                    },
                                    suffix: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppInputField(
                                    controller: TextEditingController(
                                      text:
                                          _endDate == null
                                              ? ""
                                              : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                                    ),
                                    hintText: "End Date",
                                    readOnly: true,
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _endDate ?? DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime.now(),
                                          );
                                      if (picked != null) {
                                        setModalState(() {
                                          _endDate = picked;
                                        });
                                      }
                                    },
                                    suffix: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Bank Selection
                            const SizedBox(height: 20),

                            AppText(
                              "Categories",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap:
                                  () => _showCategorySelectionBottomSheet(
                                    context,
                                    setModalState,
                                  ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                constraints: BoxConstraints(minHeight: 60),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.darkButtonBorder,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (selectedCategories.isEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            "Select Categories",
                                            variant: AppTextVariant.bodyMedium,
                                            colorType: AppTextColorType.primary,
                                          ),
                                          const Icon(Icons.keyboard_arrow_down),
                                        ],
                                      ),
                                    if (selectedCategories.isNotEmpty) ...[
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            selectedCategories
                                                .map(
                                                  (category) =>
                                                      _buildCategoryChip(
                                                        category,
                                                        setModalState,
                                                      ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Amount Range
                            AppText(
                              "Amount Range",
                              variant: AppTextVariant.bodyLarge,
                              weight: AppTextWeight.semiBold,
                            ),
                            const SizedBox(height: 12),
                            RangeSlider(
                              values: RangeValues(_minAmount, _maxAmount),
                              min: 0,
                              max: 10000,
                              divisions: 100,
                              labels: RangeLabels(
                                '₹${_minAmount.round()}',
                                '₹${_maxAmount.round()}',
                              ),
                              onChanged: (RangeValues values) {
                                setModalState(() {
                                  _minAmount = values.start;
                                  _maxAmount = values.end;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  '₹${_minAmount.round()}',
                                  variant: AppTextVariant.bodyMedium,
                                ),
                                AppText(
                                  '₹${_maxAmount.round()}',
                                  variant: AppTextVariant.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: AppSizing.scaffoldHorizontalPadding,
                        left: AppSizing.scaffoldHorizontalPadding,
                        bottom: AppSizing.scaffoldHorizontalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkInputBackground,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              variant: AppButtonVariant.primary,
                              text: "Apply",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }


  // Group transactions by date
  Map<String, List<Banktransation>> _groupTransactionsByDate(List<Banktransation>? transactions) {
    final Map<String, List<Banktransation>> grouped = {};
    
    if (transactions == null || transactions.isEmpty) {
      return grouped;
    }

    // Sort transactions by date (newest first)
    transactions.sort((a, b) => b.transactiontimestamp.compareTo(a.transactiontimestamp));
    
    for (var transaction in transactions) {
      final dateKey = DateFormat('MMMM yyyy').format(transaction.transactiontimestamp);
      final transactionsForDate = grouped[dateKey] ?? [];
      transactionsForDate.add(transaction);
      grouped[dateKey] = transactionsForDate;
    }
    
    return grouped;
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
              "Transactions",
              variant: AppTextVariant.headline6,
              weight: AppTextWeight.semiBold,
            ),
            GestureDetector(
              onTap: openFilterBottomsheet,
              child: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GetBuilder<BankTransactionController>(
          builder: (bankTransactionController) {
            final transactions = bankTransactionController.transactionData?.banktransations ?? [];
            final groupedTransactions = _groupTransactionsByDate(transactions);
            final sortedMonths = groupedTransactions.keys.toList()..sort((a, b) => b.compareTo(a));
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizing.scaffoldHorizontalPadding,
                    vertical: 8,
                  ),
                  child: AppInputField(
                    controller: _searchController,
                    prefix: Icon(
                      CupertinoIcons.search,
                      color: AppColors.darkTextMuted,
                      size: 20,
                    ),
                    hintText: "Search transactions...",
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: isTransactionsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : transactions.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: AppColors.darkTextMuted.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  AppText(
                                    'No transactions found',
                                    variant: AppTextVariant.bodyLarge,
                                    weight: AppTextWeight.medium,
                                    colorType: AppTextColorType.secondary,
                                  ),
                                  const SizedBox(height: 8),
                                  AppText(
                                    'Your transactions will appear here',
                                    variant: AppTextVariant.bodySmall,
                                    colorType: AppTextColorType.muted,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              physics: const BouncingScrollPhysics(),
                              itemCount: sortedMonths.length,
                              itemBuilder: (context, monthIndex) {
                                final month = sortedMonths[monthIndex];
                                final monthTransactions = groupedTransactions[month]!;
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizing.scaffoldHorizontalPadding,
                                        vertical: 12,
                                      ),
                                      child: AppText(
                                        month,
                                        variant: AppTextVariant.bodyMedium,
                                        weight: AppTextWeight.semiBold,
                                        colorType: AppTextColorType.primary,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: monthTransactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction = monthTransactions[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                            left: AppSizing.scaffoldHorizontalPadding,
                                            right: AppSizing.scaffoldHorizontalPadding,
                                          ),
                                          child: BankTransactionCardWidget(
                                            transaction: transaction,
                                          ),
                                        );
                                      },
                                    ),
                                    if (monthIndex < sortedMonths.length - 1)
                                      const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
