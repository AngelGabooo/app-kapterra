// lib/features/dashboard/presentation/widgets/contact_producer/contact_producer_menu.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'schedule_appointment_dialog.dart'; // ✅ Importar el diálogo

class ContactProducerMenu extends StatelessWidget {
  const ContactProducerMenu({super.key});

  Future<void> _makeDirectCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'No se puede realizar la llamada';
      }
    } catch (e) {
      print('Error al llamar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    // Número del productor
    final String producerPhone = '+528144384806';

    // ✅ Obtener el nombre del productor (por ahora fijo, luego del backend)
    final String producerName = 'Productor';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: textColor.withOpacity(0.06),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Título
          Row(
            children: [
              Icon(Icons.menu, color: AppTheme.primaryGreen),
              const SizedBox(width: 10),
              Text(
                'Opciones de Contacto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Opción 1: Llamar directamente
          _buildMenuItem(
            context,
            icon: Icons.phone,
            title: 'Llamar al Productor',
            subtitle: 'Llamada directa desde tu teléfono',
            color: AppTheme.primaryGreen,
            onTap: () {
              Navigator.pop(context);
              _makeDirectCall(producerPhone);
            },
          ),

          // ✅ Opción 2: Agendar cita (con diálogo completo)
          _buildMenuItem(
            context,
            icon: Icons.calendar_today,
            title: 'Agendar Cita',
            subtitle: 'Programar una visita',
            color: AppTheme.goldCoffee,
            onTap: () {
              Navigator.pop(context);
              _showScheduleAppointmentDialog(context, producerName);
            },
          ),

          // Opción 3: Revisar citas
          _buildMenuItem(
            context,
            icon: Icons.list_alt,
            title: 'Revisar Citas',
            subtitle: 'Ver citas programadas',
            color: AppTheme.secondaryGreen,
            onTap: () {
              Navigator.pop(context);
              _showAppointmentsDialog(context);
            },
          ),

          // Opción 4: Cambiar cita
          _buildMenuItem(
            context,
            icon: Icons.edit_calendar,
            title: 'Cambiar Cita',
            subtitle: 'Modificar fecha u hora',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              _showRescheduleDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.5),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: textColor.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  // ✅ Nuevo método para mostrar el diálogo de agendar cita
  void _showScheduleAppointmentDialog(BuildContext context, String producerName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ScheduleAppointmentDialog(
        producerId: 'producer_default', // En el futuro, esto vendrá del backend
        producerName: producerName,
      ),
    );
  }

  void _showAppointmentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Citas Programadas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy,
              size: 48,
              color: AppTheme.darkCoffee,
            ),
            const SizedBox(height: 12),
            const Text(
              'No tienes citas programadas',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agenda tu primera cita con un productor',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkCoffee.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Cambiar Cita'),
        content: const Text(
          'Función en desarrollo. Próximamente podrás modificar la fecha y hora de tus citas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}