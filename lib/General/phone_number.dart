import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInputWidget extends StatefulWidget {
  final Function(String)? onPhoneNumberChanged;

  const PhoneNumberInputWidget({super.key, this.onPhoneNumberChanged});

  @override
  _PhoneNumberInputWidgetState createState() => _PhoneNumberInputWidgetState();
}

class _PhoneNumberInputWidgetState extends State<PhoneNumberInputWidget> {
  final TextEditingController _phoneNumberController = TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber? number) {
        setState(() {
          _phoneNumber = number;
        });

        if (widget.onPhoneNumberChanged != null) {
          widget.onPhoneNumberChanged!(_phoneNumber?.phoneNumber ?? '');
        }
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      textFieldController: _phoneNumberController,
      formatInput: true,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputDecoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
      countries: const ['SA'],

    );
  }
}