import 'package:flutter/material.dart';

class LengthConverterScreen extends StatefulWidget {
  const LengthConverterScreen({super.key});

  @override
  State<LengthConverterScreen> createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  final TextEditingController valueController = TextEditingController();
  final List<String> units = ['Meter', 'Kilometer', 'Centimeter', 'Mile'];
  final Map<String, double> lengthToMeter = {
    'Meter': 1.0,
    'Kilometer': 1000.0,
    'Centimeter': 0.01,
    'Mile': 1609.34,
  };

  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  String result = '0';

  void convertLength() {
    if (valueController.text.trim().isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }

    final double inputValue = double.tryParse(valueController.text) ?? 0;

    final double valueInMeters = inputValue * lengthToMeter[fromUnit]!;
    final double convertedValue = valueInMeters / lengthToMeter[toUnit]!;

    setState(() {
      result = convertedValue.toStringAsFixed(2);
    });
  }

  void swapUnits() {
    setState(() {
      final temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
    });
    convertLength();
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
      appBar: AppBar(title: const Text('Length Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Convert Length Units',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Quickly convert between meter, kilometer, centimeter and mile',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _inputDecoration('Enter value'),
              onChanged: (_) => convertLength(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(fromUnit),
              initialValue: fromUnit,
              decoration: _inputDecoration('From'),
              items: units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromUnit = value!;
                });
                convertLength();
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

              items: units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toUnit = value!;
                });
                convertLength();
              },
            ),
            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    'Converted result',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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
