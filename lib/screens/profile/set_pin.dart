import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nwt_app/screens/profile/reset_pin.dart';
import 'package:lottie/lottie.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class SetPin extends StatefulWidget {
  const SetPin({super.key});

  @override
  State<SetPin> createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  String _enteredPin = '';

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPinChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _pinControllers.length - 1) {
        FocusScope.of(context).nextFocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
    _updateEnteredPin();
  }

  void _updateEnteredPin() {
    setState(() {
      _enteredPin = _pinControllers.map((c) => c.text).join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const AppText(
          'Set Pin',
          variant: AppTextVariant.headline6,
          weight: AppTextWeight.bold,
          colorType: AppTextColorType.primary,
        ),
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Lottie.asset('assets/lottie/Reset Pin.json'),
                ),
              ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: AppText(
                "Set your 4-digit pin",
                variant: AppTextVariant.headline4, // or another variant based on your theme
                lineHeight: 1.5, // equivalent to 30 / 20
                colorType: AppTextColorType.primary, // or secondary if your theme uses that
                weight: AppTextWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
                      
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < 3 ? 12 : 0), // space between boxes
                    child: _buildPinInputBox(index),
                  );
                }),
              ),
            ),


                  const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  AppText(
                    "Forget your pin?",
                    variant: AppTextVariant.bodyMedium,
                    lineHeight: 28 / 14,
                    colorType: AppTextColorType.muted,
                    weight: AppTextWeight.bold,
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPin(),
                        ),
                      );
                    },
                    child: AppText(
                      "Reset Pin",
                      variant: AppTextVariant.bodyMedium,
                      lineHeight: 28 / 14,
                      colorType: AppTextColorType.primary, // or secondary, depending on your theme
                      weight: AppTextWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Add your save logic here
              },
              child: const AppText(
                'Confirm',
                  variant: AppTextVariant.bodyLarge,
                  weight: AppTextWeight.bold,
                  colorType: AppTextColorType.tertiary,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPinInputBox(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF242424), width: 1.2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: Center(
        child: TextField(
          controller: _pinControllers[index],
          maxLength: 1,
          obscureText: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) => _onPinChanged(value, index),
          onSubmitted: (value) {
            if (index < _pinControllers.length - 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }
}