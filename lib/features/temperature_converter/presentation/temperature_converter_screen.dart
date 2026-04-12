import 'package:flutter/material.dart';

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController valueController = TextEditingController();
  final List<String> units = ['Celsius', 'Fahrenheit', 'Kelvin'];
  String fromUnit = 'Celsius';
  String toUnit = 'Fahrenheit';
  String result = '0';

  void convertTemperature() {
    if (valueController.text.trim().isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }

    final double inputValue = double.tryParse(valueController.text) ?? 0;

    final double valueInCelsius;

    if (fromUnit == 'Celsius') {
      valueInCelsius = inputValue;
    } else if (fromUnit == 'Fahrenheit') {
      valueInCelsius = (inputValue - 32) * 5 / 9;
    } else {
      valueInCelsius = inputValue - 273.15;
    }
    double convertedValue;
    if (toUnit == 'Celsius') {
      convertedValue = valueInCelsius;
    } else if (toUnit == 'Fahrenheit') {
      convertedValue = (valueInCelsius * 9 / 5) + 32;
    } else {
      convertedValue = valueInCelsius + 273.15;
    }
    setState(() {
      result = convertedValue.toStringAsFixed(2);
    });
  }

  void swapUnits() {
    setState(() {
      final String temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
    });
    convertTemperature();
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Convert Temperature Units',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Quickly convert between Celcius, Fahrenheit and kelvin',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _inputDecoration('Enter temperature'),
              onChanged: (_) => convertTemperature(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(fromUnit),
              decoration: _inputDecoration('From'),
              initialValue: fromUnit,
              items: units.map((unit) {
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromUnit = value!;
                });
                convertTemperature();
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: IconButton(
                onPressed: swapUnits,
                icon: const Icon(Icons.swap_vert_circle_outlined),
                iconSize: 36,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(toUnit),
              initialValue: toUnit,
              decoration: _inputDecoration('To'),
              items: units.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toUnit = value!;
                });
                convertTemperature();
              },
            ),
            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text(
                    'Converted result',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$result $toUnit',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
