import 'package:flutter/material.dart';

class AcCard extends StatelessWidget {
  final String name;
  final double temperature;
  final bool isOn;
  final String mode;
  final bool isCelsius;
  final Function(bool) onToggle;

  const AcCard({
    super.key,
    required this.name,
    required this.temperature,
    required this.isOn,
    required this.mode,
    required this.isCelsius,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mode: $mode',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Switch(
                  value: isOn,
                  activeColor: const Color(0xFF2665B6),
                  onChanged: onToggle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thermostat, color: _getTempColor(), size: 28),
                    const SizedBox(width: 8),
                    Text(
                      '${temperature.toStringAsFixed(1)}°${isCelsius ? 'C' : 'F'}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getTempColor(),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isOn ? const Color(0xFF2665B6) : Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isOn ? 'ON' : 'OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTempColor() {
    double temp = temperature;
    if (!isCelsius) {
      temp = (temp - 32) * 5 / 9;
    }

    if (temp < 18) return Colors.blue;
    if (temp < 24) return const Color(0xFF2665B6);
    if (temp < 28) return Colors.orange;
    return Colors.red;
  }
}
