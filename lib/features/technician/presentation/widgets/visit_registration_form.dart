// lib/features/technician/presentation/widgets/visit_registration_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class VisitRegistrationForm extends StatefulWidget {
  final bool isDark;
  final String producerName;
  final String farmName;
  final String lotName;
  final String location;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onSaveDraft;

  const VisitRegistrationForm({
    super.key,
    required this.isDark,
    required this.producerName,
    required this.farmName,
    required this.lotName,
    required this.location,
    required this.onSave,
    required this.onSaveDraft,
  });

  @override
  State<VisitRegistrationForm> createState() => _VisitRegistrationFormState();
}

class _VisitRegistrationFormState extends State<VisitRegistrationForm> {
  final _objectiveController = TextEditingController();
  final _observationsController = TextEditingController();
  final _followUpController = TextEditingController();

  String? _selectedObjective;
  int _cropHealth = 2;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _nextVisitDate;
  TimeOfDay? _nextVisitTime;
  String _nextVisitReason = '';
  double _checklistProgress = 0.0;

  final List<Map<String, dynamic>> _checklistItems = [
    {'label': 'Productor presente', 'checked': false},
    {'label': 'Se inspeccionó el lote', 'checked': false},
    {'label': 'Se tomaron fotografías', 'checked': false},
    {'label': 'Se revisó la humedad', 'checked': false},
    {'label': 'Se revisó el estado sanitario', 'checked': false},
    {'label': 'Se entregaron recomendaciones', 'checked': false},
  ];

  final List<String> _photos = [];
  final List<String> _attachments = [];

  final List<String> _objectiveOptions = [
    'Inspección general',
    'Seguimiento de plagas',
    'Certificación',
    'Seguimiento de recomendación',
    'Revisión de cosecha',
    'Acopio',
    'Otro',
  ];

  final List<Map<String, dynamic>> _cropHealthOptions = [
    {'label': 'Excelente', 'color': AppTheme.primaryGreen, 'emoji': '🌟'},
    {'label': 'Bueno', 'color': AppTheme.secondaryGreen, 'emoji': '👍'},
    {'label': 'Regular', 'color': AppTheme.goldCoffee, 'emoji': '😐'},
    {'label': 'Requiere atención', 'color': AppTheme.alertOrange, 'emoji': '⚠️'},
    {'label': 'Crítico', 'color': AppTheme.berryRed, 'emoji': '🚨'},
  ];

  @override
  void dispose() {
    _objectiveController.dispose();
    _observationsController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  void _updateChecklistProgress() {
    final checked = _checklistItems.where((item) => item['checked'] == true).length;
    setState(() {
      _checklistProgress = checked / _checklistItems.length;
    });
  }

  void _toggleChecklist(int index) {
    setState(() {
      _checklistItems[index]['checked'] = !_checklistItems[index]['checked'];
    });
    _updateChecklistProgress();
  }

  void _submitForm() {
    final data = {
      'producerName': widget.producerName,
      'farmName': widget.farmName,
      'lotName': widget.lotName,
      'location': widget.location,
      'objective': _selectedObjective,
      'cropHealth': _cropHealthOptions[_cropHealth]['label'],
      'observations': _observationsController.text,
      'photos': _photos,
      'attachments': _attachments,
      'checklist': _checklistItems,
      'followUp': _followUpController.text,
      'nextVisitDate': _nextVisitDate,
      'nextVisitTime': _nextVisitTime,
      'nextVisitReason': _nextVisitReason,
    };
    widget.onSave(data);
  }

  void _navigateToLotInspection() {
    // ✅ CONEXIÓN: Navegar a la inspección del lote
    context.push(
      RouteNames.technicianLotInspection,
      extra: {
        'lotName': widget.lotName,
        'farmName': widget.farmName,
        'producerName': widget.producerName,
        'location': widget.location,
      },
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '¿Finalizar visita?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'La información quedará registrada en el historial técnico del productor.',
                style: TextStyle(
                  fontSize: 14,
                  color: (widget.isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: (widget.isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _submitForm();
                        // ✅ Después de guardar, navegar a la inspección
                        _navigateToLotInspection();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Finalizar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextVisitDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
              onSurface: widget.isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _nextVisitDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _nextVisitTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
              onSurface: widget.isDark ? Colors.white : AppTheme.darkCoffee,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _nextVisitTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = widget.isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : const Color(0xFFE8E0D5).withOpacity(0.9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Información del productor ──────────────────────────
        _buildSectionTitle('Información del productor', textColor),
        const SizedBox(height: 8),
        _buildProducerCard(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Información automática ──────────────────────────────
        _buildSectionTitle('Información automática', textColor),
        const SizedBox(height: 8),
        _buildAutoInfoCard(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Objetivo de la visita ────────────────────────────────
        _buildSectionTitle('Objetivo de la visita', textColor),
        const SizedBox(height: 8),
        _buildObjectiveDropdown(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Estado general del cultivo ────────────────────────────
        _buildSectionTitle('Estado general del cultivo', textColor),
        const SizedBox(height: 8),
        _buildCropHealthSelector(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Observaciones ────────────────────────────────────────
        _buildSectionTitle('Observaciones', textColor),
        const SizedBox(height: 8),
        _buildObservationsField(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Evidencias fotográficas ──────────────────────────────
        _buildSectionTitle('Evidencias fotográficas', textColor),
        const SizedBox(height: 8),
        _buildPhotoGallery(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Checklist de visita ──────────────────────────────────
        _buildSectionTitle('Checklist de visita', textColor),
        const SizedBox(height: 8),
        _buildChecklist(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Notas de seguimiento ──────────────────────────────────
        _buildSectionTitle('Notas de seguimiento', textColor),
        const SizedBox(height: 8),
        _buildFollowUpField(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Programar próxima visita ──────────────────────────────
        _buildSectionTitle('Programar próxima visita', textColor),
        const SizedBox(height: 8),
        _buildNextVisitCard(cardColor, textColor),
        const SizedBox(height: 20),

        // ── Resumen de la visita ──────────────────────────────────
        _buildSectionTitle('Resumen de la visita', textColor),
        const SizedBox(height: 8),
        _buildSummaryCard(cardColor, textColor),
        const SizedBox(height: 24),

        // ── Botones de acción ────────────────────────────────────
        _buildActionButtons(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryGreen, AppTheme.goldCoffee],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProducerCard(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                widget.producerName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  widget.producerName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '🌱 ${widget.farmName}  •  ☕ ${widget.lotName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: textColor.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoInfoCard(Color cardColor, Color textColor) {
    final now = DateTime.now();
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAutoInfoRow(Icons.calendar_today, 'Fecha', '${now.day}/${now.month}/${now.year}', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(
            Icons.access_time,
            'Hora de inicio',
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            textColor,
          ),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.location_on, 'Coordenadas GPS', '15.1234° N, 92.5678° W', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.wb_sunny, 'Condiciones climáticas', 'Soleado, 28°C', textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.person, 'Responsable', 'Carlos Técnico', textColor),
        ],
      ),
    );
  }

  Widget _buildAutoInfoRow(IconData icon, String label, String value, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveDropdown(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedObjective,
        isExpanded: true,
        dropdownColor: widget.isDark ? AppTheme.coffeeDeep : Colors.white,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Selecciona el objetivo',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.flag_outlined, color: AppTheme.primaryGreen),
        ),
        items: _objectiveOptions.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) => setState(() => _selectedObjective = value),
      ),
    );
  }

  Widget _buildCropHealthSelector(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(_cropHealthOptions.length, (index) {
          final option = _cropHealthOptions[index];
          final isSelected = _cropHealth == index;
          return GestureDetector(
            onTap: () => setState(() => _cropHealth = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (option['color'] as Color).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : textColor.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    option['emoji'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    option['label'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? (option['color'] as Color) : textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildObservationsField(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: TextFormField(
        controller: _observationsController,
        maxLines: 4,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Describe las condiciones observadas durante la visita...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          counterText: '',
        ),
        maxLength: 500,
      ),
    );
  }

  Widget _buildPhotoGallery(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _photos.add('📷 Foto ${_photos.length + 1}'));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.camera_alt, size: 24, color: AppTheme.primaryGreen),
                        const SizedBox(height: 4),
                        Text(
                          'Tomar foto',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _photos.add('🖼 Imagen ${_photos.length + 1}'));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: textColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image, size: 24, color: AppTheme.goldCoffee),
                        const SizedBox(height: 4),
                        Text(
                          'Seleccionar',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            '📷',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => _photos.removeAt(index)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppTheme.berryRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChecklist(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          ..._checklistItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => _toggleChecklist(index),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['checked']
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: item['checked']
                              ? AppTheme.primaryGreen
                              : textColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: item['checked']
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 13,
                          color: item['checked']
                              ? textColor.withOpacity(0.7)
                              : textColor,
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _checklistProgress,
                    minHeight: 5,
                    backgroundColor: textColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(_checklistProgress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpField(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: TextFormField(
        controller: _followUpController,
        maxLines: 3,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Registrar acciones pendientes para la siguiente visita...',
          hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 14),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildNextVisitCard(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          _nextVisitDate != null
                              ? '${_nextVisitDate!.day}/${_nextVisitDate!.month}/${_nextVisitDate!.year}'
                              : 'Fecha',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 16, color: AppTheme.primaryGreen),
                        const SizedBox(width: 6),
                        Text(
                          _nextVisitTime != null
                              ? _nextVisitTime!.format(context)
                              : 'Hora',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            style: TextStyle(color: textColor, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Motivo de la próxima visita',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.primaryGreen),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (value) => _nextVisitReason = value,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Color cardColor, Color textColor) {
    final totalPhotos = _photos.length;
    final totalChecklist = _checklistItems.where((item) => item['checked'] == true).length;

    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildSummaryRow('👨‍🌾 Productor', widget.producerName, textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('🌱 Finca', widget.farmName, textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('☕ Lote', widget.lotName, textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📷 Fotografías', '$_photos tomadas', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📋 Checklist', '$totalChecklist/${_checklistItems.length} completados', textColor),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color textColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onSaveDraft,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.goldCoffee,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color: AppTheme.goldCoffee.withOpacity(0.4),
                width: 1.5,
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save_outlined, size: 16),
                SizedBox(width: 6),
                Text(
                  'Guardar borrador',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _showConfirmDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 16),
                SizedBox(width: 6),
                Text(
                  'Finalizar Visita',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}