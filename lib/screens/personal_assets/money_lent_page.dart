import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class MoneyLentPage extends StatefulWidget {
  const MoneyLentPage({super.key});

  @override
  State<MoneyLentPage> createState() => _MoneyLentPageState();
}

class _MoneyLentPageState extends State<MoneyLentPage> {
  final TextEditingController towhomController = TextEditingController();
  final TextEditingController rateofinterestController = TextEditingController();
  final TextEditingController moneylentvalueController = TextEditingController();
  final TextEditingController moneyLentdateController = TextEditingController();
  final TextEditingController timelineinmonthsController = TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    towhomController.dispose();
    rateofinterestController.dispose();
    moneylentvalueController.dispose();
    moneyLentdateController.dispose();
    timelineinmonthsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        moneyLentdateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText(
          "Money Lent",
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("To whom*", towhomController),
            _buildField("Rate of Interest*", rateofinterestController),
            _buildField("Money Lent Value*",moneylentvalueController),
            _buildDateField("Money Lent Date*", moneyLentdateController),
            _buildField("Timeline in Months",timelineinmonthsController),
            const SizedBox(height: 8),
              InkWell(
              onTap: () {
                // Add your file picker or upload logic here
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    AppText("Supporting Image", variant: AppTextVariant.headline6,weight: AppTextWeight.semiBold ,colorType: AppTextColorType.primary,),
                    AppText("Upload", variant: AppTextVariant.headline6, weight: AppTextWeight.semiBold, colorType: AppTextColorType.link),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {},
              child: const AppText("Add another asset", variant: AppTextVariant.bodyLarge,weight: AppTextWeight.semiBold,colorType: AppTextColorType.tertiary,),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Handle Save & Continue logic here
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const AppText(
                  "Save & Continue",
                  variant: AppTextVariant.headline6,
                  weight: AppTextWeight.semiBold,
                  colorType: AppTextColorType.primary,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.headline6,weight: AppTextWeight.semiBold,colorType: AppTextColorType.secondary),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF242424),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.headline6, weight: AppTextWeight.semiBold, colorType: AppTextColorType.secondary),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () => _selectDate(context),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF242424),
              suffixIcon: const Icon(Icons.calendar_month, color: Colors.white70),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
