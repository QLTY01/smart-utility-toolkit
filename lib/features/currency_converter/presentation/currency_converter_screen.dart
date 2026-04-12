import 'package:flutter/material.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController valueController = TextEditingController();
  final List<String> currencies = ['USD', 'EUR', 'GBP', 'NGN'];

  final Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'NGN': 1500.0,
  };

  String fromCurrency = 'USD';
  String toCurrency = 'NGN';
  String result = '0';

  void convertCurrency() {
    if (valueController.text.trim().isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }

    final double inputValue = double.tryParse(valueController.text) ?? 0;

    final double amountInUsd = inputValue / rates[fromCurrency]!;
    final double convertedValue = amountInUsd * rates[toCurrency]!;

    setState(() {
      result = convertedValue.toStringAsFixed(2);
    });
  }

  void swapCurrencies() {
    setState(() {
      final String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
    convertCurrency();
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Convert Currency Values',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Quickly convert between USD, EUR, GBP, and NGN.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: valueController,
              decoration: _inputDecoration('Enter amount'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => convertCurrency(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: ValueKey(fromCurrency),
              initialValue: fromCurrency,
              decoration: _inputDecoration('From'),
              items: currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromCurrency = value!;
                });
                convertCurrency();
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: IconButton(
                onPressed: swapCurrencies,
                icon: const Icon(Icons.swap_vert_circle_outlined),
                iconSize: 36,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(toCurrency),
              initialValue: toCurrency,
              decoration: _inputDecoration('To'),
              items: currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toCurrency = value!;
                });
                convertCurrency();
              },
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
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
                    '$result $toCurrency',
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
