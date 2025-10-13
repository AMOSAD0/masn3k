// lib/features/production/presentation/widgets/machine_actions_bar.dart
import 'package:flutter/material.dart';
import '../../../../core/constants.dart';

class MachineActionsBar extends StatelessWidget {
  final VoidCallback onAddMachine;
  final VoidCallback onLogBreakdown;
  final VoidCallback onLogMaintenance;

  const MachineActionsBar({
    super.key,
    required this.onAddMachine,
    required this.onLogBreakdown,
    required this.onLogMaintenance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      child: SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ElevatedButton.icon(
              onPressed: onAddMachine,
              icon: const Icon(Icons.add),
              label: const Text('إضافة آلة'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onLogBreakdown,
              icon: const Icon(Icons.report),
              label: const Text('تسجيل عطل'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onLogMaintenance,
              icon: const Icon(Icons.build),
              label: const Text('تسجيل صيانة'),
            ),
          ],
        ),
      ),
    );
  }
}
