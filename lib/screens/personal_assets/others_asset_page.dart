import 'package:flutter/material.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class OthersAssetPage extends StatefulWidget {
  const OthersAssetPage({super.key});

  @override
  State<OthersAssetPage> createState() => _OthersAssetPageState();
}

class _OthersAssetPageState extends State<OthersAssetPage> {
  final TextEditingController assetnameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nomineeController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController shareholdingController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedPropertyType = 'Residential';
  String selectedOwnershipType = 'Individual';
  DateTime? selectedDate;

  @override
  void dispose() {
    assetnameController.dispose();
    valueController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    nomineeController.dispose();
    relationController.dispose();
    shareholdingController.dispose();
    noteController.dispose();
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
        dateController.text = "${picked.day}-${picked.month}-${picked.year}";
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
          "Others",
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("Asset Name*", assetnameController),
            _buildField("Purchased Value*", valueController),
            _buildDateField("Purchased Date*", dateController),
            _buildField("Description", descriptionController),
            _buildDropdown("Type of Ownership", ['Individual', 'Joint'], selectedOwnershipType, (val) {
              setState(() {
                selectedOwnershipType = val!;
              });
            }),
            _buildField("Nominee 1", nomineeController),
            _buildField("Relation", relationController),
            _buildField("Shareholding for Nominee 1", shareholdingController),
            Row(
              children: const [
                Icon(Icons.add_circle_outline, color: Colors.white70),
                SizedBox(width: 8),
                AppText("Add Nominee 1", colorType: AppTextColorType.primary),
              ],
            ),
            const SizedBox(height: 16),
            _buildField("Note", noteController, maxLines: 3),
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


            const SizedBox(height: 24),
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

  Widget _buildDropdown(String label, List<String> items, String selectedItem, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.headline6, weight: AppTextWeight.semiBold, colorType: AppTextColorType.secondary),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedItem,
              dropdownColor: const Color(0xFF242424),
              iconEnabledColor: Colors.white70,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: AppText(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
