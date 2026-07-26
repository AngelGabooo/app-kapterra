// lib/features/buyer/presentation/widgets/assign_technician_dialog.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/technician_model.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class AssignTechnicianDialog extends StatefulWidget {
  final ProducerSummaryModel producer;
  final List<TechnicianModel> technicians;

  const AssignTechnicianDialog({
    super.key,
    required this.producer,
    required this.technicians,
  });

  @override
  State<AssignTechnicianDialog> createState() => _AssignTechnicianDialogState();
}

class _AssignTechnicianDialogState extends State<AssignTechnicianDialog> {
  String? _selectedTechnicianId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final availableTechnicians = widget.technicians
        .where((t) => t.status == 'Activo')
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.engineering,
                    color: AppTheme.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Asignar Técnico',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: textColor.withOpacity(0.5)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Productor: ${widget.producer.name}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona el técnico que dará seguimiento a este productor:',
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            if (availableTechnicians.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.engineering_outlined, size: 40, color: textColor.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    Text(
                      'No hay técnicos disponibles',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Abrir diálogo de registro de técnico
                      },
                      child: const Text('Registrar técnico'),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: availableTechnicians.map((tech) {
                  final isSelected = _selectedTechnicianId == tech.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTechnicianId = tech.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.grey.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                tech.fullName.split(' ').map((e) => e[0]).take(2).join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tech.fullName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  '${tech.specialty} • ${tech.activeClients} clientes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: AppTheme.primaryGreen),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LoginButton(
                    text: 'Asignar',
                    onPressed: _selectedTechnicianId != null
                        ? () {
                      Navigator.pop(context, _selectedTechnicianId);
                    }
                        : () {}, // ✅ En lugar de null, pasamos una función vacía
                    isLoading: false,
                    isEnabled: _selectedTechnicianId != null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}