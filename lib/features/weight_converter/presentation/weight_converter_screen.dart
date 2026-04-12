import 'package:flutter/material.dart';

class WeightConverterScreen extends StatefulWidget {
  const WeightConverterScreen({super.key});

  @override
  State<WeightConverterScreen> createState() => _WeightConverterScreenState();
}

class _WeightConverterScreenState extends State<WeightConverterScreen> {
  final TextEditingController valueController = TextEditingController();
  final List<String> units = ['Kilogram', 'Gram', 'Pound', 'Ton'];
  final Map<String, double> weightToKg = {
    'Kilogram': 1.0,
    'Gram': 0.001,
    'Pound': 0.453592,
    'Ton': 1000.0,
  };

  String fromUnit = 'Kilogram';
  String toUnit = 'Gram';
  String result = '0';

  void convertWeight() {
    if (valueController.text.trim().isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }
    final double inputValue = double.tryParse(valueController.text) ?? 0;
    final double valueInKg = inputValue * weightToKg[fromUnit]!;
    final double convertedValue = valueInKg / weightToKg[toUnit]!;

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
    convertWeight();
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
      appBar: AppBar(title: const Text('Weight Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Convert Weight Units',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Quickly convert between kilogram, gram, pound and ton.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: valueController,
              decoration: _inputDecoration('Enter weight'),
              onChanged: (_) => convertWeight(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                convertWeight();
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
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toUnit = value!;
                });
                convertWeight();
              },
            ),

            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
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
