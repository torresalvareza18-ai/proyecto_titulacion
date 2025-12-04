import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Tarjeta 1: Guardados
          _StatCard(
            count: '2',
            label: 'Guardados',
          ),
          
          SizedBox(width: 16), // Espacio central
          
          // Tarjeta 2: Me Gusta
          _StatCard(
            count: '1',
            label: 'Me Gusta',
          ),
        ],
      ),
    );
  }
}

// Widget privado (_StatCard) porque solo se usa aquí.
// Si planeas usarlo en otras pantallas, quítale el guion bajo.
class _StatCard extends StatelessWidget {
  final String count;
  final String label;

  const _StatCard({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8E9), // Verde claro
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}