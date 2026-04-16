import 'package:flutter/material.dart';
import 'package:smart_utillity_toolkit/features/currency_converter/presentation/currency_converter_screen.dart';
import 'package:smart_utillity_toolkit/features/length_converter/presentation/length_converter_screen.dart';
import 'package:smart_utillity_toolkit/features/task_manager/presentation/task_manager_screen.dart';
import 'package:smart_utillity_toolkit/shared/widgets/tool_card.dart';
import 'package:smart_utillity_toolkit/features/temperature_converter/presentation/temperature_converter_screen.dart';
import 'package:smart_utillity_toolkit/features/weight_converter/presentation/weight_converter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Utility Toolkit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All-in-one Utility Tools',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Convert values and manage tasks, all in one simple-offline friendly app.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Available tools',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Choose a tool to get started',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  ToolCard(
                    title: 'Length Converter',
                    icon: Icons.straighten,
                    color: Colors.blue,
                    onTap: () =>
                        _navigateTo(context, const LengthConverterScreen()),
                  ),
                  ToolCard(
                    title: 'Temperature Converter',
                    icon: Icons.thermostat,
                    color: Colors.red,
                    onTap: () => _navigateTo(
                      context,
                      const TemperatureConverterScreen(),
                    ),
                  ),
                  ToolCard(
                    title: 'Weight Converter',
                    icon: Icons.monitor_weight_outlined,
                    color: Colors.orange,
                    onTap: () =>
                        _navigateTo(context, const WeightConverterScreen()),
                  ),
                  ToolCard(
                    title: 'Currency Converter',
                    icon: Icons.currency_exchange,
                    color: Colors.green,
                    onTap: () =>
                        _navigateTo(context, const CurrencyConverterScreen()),
                  ),
                  ToolCard(
                    color: Colors.deepPurple,
                    title: 'Task Manager',
                    icon: Icons.check_circle_outline,
                    onTap: () =>
                        _navigateTo(context, const TaskManagerScreen()),
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
