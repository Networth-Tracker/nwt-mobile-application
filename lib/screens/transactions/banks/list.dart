import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/constants/sizing.dart';
import 'package:nwt_app/screens/transactions/banks/widgets/transaction_card.dart';
import 'package:nwt_app/widgets/common/app_input_field.dart';
import 'package:nwt_app/widgets/common/button_widget.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class Bank {
  final String id;
  final String name;
  final String accountNumber;
  final IconData icon;
  bool isSelected;

  Bank({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.icon,
    this.isSelected = false,
  });
}

class BankTransactionListScreen extends StatefulWidget {
  const BankTransactionListScreen({super.key});

  @override
  State<BankTransactionListScreen> createState() =>
      _BankTransactionListScreenState();
}

class _BankTransactionListScreenState extends State<BankTransactionListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Filter state variables
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedCategory = 'All';
  double _minAmount = 0;
  double _maxAmount = 10000;

  final List<Bank> _banks = [
    Bank(
      id: '1',
      name: 'HDFC Bank',
      accountNumber: 'XXXX 1234',
      icon: Icons.account_balance,
    ),
    Bank(
      id: '2',
      name: 'ICICI Bank',
      accountNumber: 'XXXX 5678',
      icon: Icons.account_balance,
    ),
    Bank(
      id: '3',
      name: 'SBI',
      accountNumber: 'XXXX 9012',
      icon: Icons.account_balance,
    ),
    Bank(
      id: '4',
      name: 'Axis Bank',
      accountNumber: 'XXXX 3456',
      icon: Icons.account_balance,
    ),
  ];

  List<Bank> get selectedBanks =>
      _banks.where((bank) => bank.isSelected).toList();

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
                        return ListTile(
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
                          trailing: bank.isSelected
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

  void openFilterBottomsheet() {
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
                              "Date Range",
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

                            const SizedBox(height: 20),

                            // Bank Selection
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
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (selectedBanks.isEmpty)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                              "Category",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items:
                                    <String>[
                                      'All',
                                      'Food',
                                      'Transport',
                                      'Shopping',
                                      'Entertainment',
                                      'Utilities',
                                      'Others',
                                    ].map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: AppText(
                                          value,
                                          variant: AppTextVariant.bodyMedium,
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  setModalState(() {
                                    _selectedCategory = newValue!;
                                  });
                                },
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
              child: Icon(Icons.tune_rounded),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizing.scaffoldHorizontalPadding,
              ),
              child: AppInputField(
                controller: _searchController,
                prefix: Icon(
                  CupertinoIcons.search,
                  color: AppColors.darkTextMuted,
                ),
                hintText: "Search...",
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizing.scaffoldHorizontalPadding,
                ),
                child: Column(
                  children: [
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              "May 2025",
                              variant: AppTextVariant.bodyMedium,
                              weight: AppTextWeight.semiBold,
                              colorType: AppTextColorType.primary,
                            ),
                          ],
                        ),
                        BankTransactionCardWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
