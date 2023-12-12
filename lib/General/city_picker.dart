import 'package:flutter/material.dart';
/*
displays a dropdown button for selecting a city
 */
class CityPickerWidget extends StatefulWidget {
  final Function(String)? onCitySelected;

  const CityPickerWidget({super.key, this.onCitySelected});

  @override
  _CityPickerWidgetState createState() => _CityPickerWidgetState();
}

class _CityPickerWidgetState extends State<CityPickerWidget> {
  String _selectedCity = 'Riyadh';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      onChanged: (String? city) {
        setState(() {
          _selectedCity = city!;
        });

        if (widget.onCitySelected != null) {
          widget.onCitySelected!(_selectedCity);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a city';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'City',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem<String>(
          value: 'Riyadh',
          child: Text('Riyadh'),
        ),
        DropdownMenuItem<String>(
          value: 'Jeddah',
          child: Text('Jeddah'),
        ),
        DropdownMenuItem<String>(
          value: 'Mecca',
          child: Text('Mecca'),
        ),
        DropdownMenuItem<String>(
          value: 'Medina',
          child: Text('Medina'),
        ),
        DropdownMenuItem<String>(
          value: 'Dammam',
          child: Text('Dammam'),
        ),
        DropdownMenuItem<String>(
          value: 'Taif',
          child: Text('Taif'),
        ),
        DropdownMenuItem<String>(
          value: 'Tabuk',
          child: Text('Tabuk'),
        ),
        DropdownMenuItem<String>(
          value: 'Buraidah',
          child: Text('Buraidah'),
        ),
        DropdownMenuItem<String>(
          value: 'Khamis Mushait',
          child: Text('Khamis Mushait'),
        ),
        DropdownMenuItem<String>(
          value: 'Abha',
          child: Text('Abha'),
        ),
        DropdownMenuItem<String>(
          value: 'Al-Ahsa',
          child: Text('Al-Ahsa'),
        ),
        DropdownMenuItem<String>(
          value: 'Jubail',
          child: Text('Jubail'),
        ),
        DropdownMenuItem<String>(
          value: 'Hail',
          child: Text('Hail'),
        ),
        DropdownMenuItem<String>(
          value: 'Najran',
          child: Text('Najran'),
        ),
        DropdownMenuItem<String>(
          value: 'Al-Khobar',
          child: Text('Al-Khobar'),
        ),
        DropdownMenuItem<String>(
          value: 'Yanbu',
          child: Text('Yanbu'),
        ),
        // Add more cities as needed
      ],
    );
  }
}