import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ResetPin extends StatefulWidget {
  const ResetPin({super.key});

  @override
  State<ResetPin> createState() => _ResetPinState();
}

class _ResetPinState extends State<ResetPin> {
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
        title: const Text(
          'Reset Pin',
          style: TextStyle(
            color: Color(0xFFFCFCFC),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 24 / 16,
            letterSpacing: 0,
          ),
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
              child: Text(
                'Reset your 4-digit pin',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  height: 30 / 20,
                  letterSpacing: 0,
                  color: Color(0xFFFCFCFC),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: _buildPinInputBox(index),
                  );
                }),
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
                // Add reset pin logic here
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 32 / 16,
                  letterSpacing: 0,
                ),
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
