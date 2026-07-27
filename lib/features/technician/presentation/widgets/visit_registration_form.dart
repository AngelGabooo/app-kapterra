// lib/features/technician/presentation/widgets/visit_registration_form.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class VisitRegistrationForm extends StatefulWidget {
  final bool isDark;
  final String? producerName;
  final String? farmName;
  final String? lotName;
  final String? location;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onSaveDraft;

  const VisitRegistrationForm({
    super.key,
    required this.isDark,
    this.producerName,
    this.farmName,
    this.lotName,
    this.location,
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

  // Controladores para los campos con validación
  final _producerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedObjective;
  int _cropHealth = 2;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _nextVisitDate;
  TimeOfDay? _nextVisitTime;
  String _nextVisitReason = '';
  double _checklistProgress = 0.0;

  // Datos del técnico (se llenarán desde el provider)
  String _technicianName = '';
  String _technicianEmail = '';

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
  void initState() {
    super.initState();
    // Cargar datos del técnico desde el provider
    _loadTechnicianData();

    // Inicializar campos con los datos recibidos (pueden estar vacíos)
    _producerNameController.text = widget.producerName ?? '';
    _phoneController.text = '';
    _emailController.text = '';
  }

  void _loadTechnicianData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userName != null) {
      _technicianName = userProvider.userName!;
    }
    if (userProvider.userEmail != null) {
      _technicianEmail = userProvider.userEmail!;
    }
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    _observationsController.dispose();
    _followUpController.dispose();
    _producerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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

  // VALIDACIONES
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    final RegExp nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solo debe contener letras y espacios';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de celular es obligatorio';
    }
    final RegExp phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'El número de celular solo debe contener números';
    }
    if (value.length > 10) {
      return 'El número de celular no debe tener más de 10 dígitos';
    }
    if (value.length < 7) {
      return 'El número de celular debe tener al menos 7 dígitos';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'El correo debe contener "@" y un dominio válido';
    }
    return null;
  }

  bool _isFormComplete() {
    final nameError = _validateName(_producerNameController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final emailError = _validateEmail(_emailController.text);

    if (nameError != null || phoneError != null || emailError != null) {
      return false;
    }

    if (_selectedObjective == null) return false;
    if (_observationsController.text.trim().isEmpty) return false;

    return true;
  }

  void _submitForm() {
    // Validar todos los campos antes de enviar
    final nameError = _validateName(_producerNameController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final emailError = _validateEmail(_emailController.text);

    if (nameError != null || phoneError != null || emailError != null) {
      _showValidationDialog();
      return;
    }

    final data = {
      'producerName': _producerNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'farmName': widget.farmName ?? '',
      'lotName': widget.lotName ?? '',
      'location': widget.location ?? '',
      'objective': _selectedObjective,
      'cropHealth': _cropHealthOptions[_cropHealth]['label'],
      'observations': _observationsController.text.trim(),
      'photos': _photos,
      'attachments': _attachments,
      'checklist': _checklistItems,
      'followUp': _followUpController.text.trim(),
      'nextVisitDate': _nextVisitDate,
      'nextVisitTime': _nextVisitTime,
      'nextVisitReason': _nextVisitReason,
      'technicianName': _technicianName,
      'technicianEmail': _technicianEmail,
    };
    widget.onSave(data);
  }

  void _navigateToLotInspection() {
    context.push(
      RouteNames.technicianLotInspection,
      extra: {
        'lotName': widget.lotName ?? '',
        'farmName': widget.farmName ?? '',
        'producerName': _producerNameController.text.trim(),
        'location': widget.location ?? '',
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      },
    );
  }

  void _showValidationDialog() {
    final nameError = _validateName(_producerNameController.text);
    final phoneError = _validatePhone(_phoneController.text);
    final emailError = _validateEmail(_emailController.text);
    List<String> errors = [];

    if (nameError != null) errors.add('• $nameError');
    if (phoneError != null) errors.add('• $phoneError');
    if (emailError != null) errors.add('• $emailError');
    if (_selectedObjective == null) errors.add('• Selecciona un objetivo para la visita');
    if (_observationsController.text.trim().isEmpty) errors.add('• Agrega observaciones de la visita');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '⚠️ Información incompleta',
          style: TextStyle(
            color: widget.isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              error,
              style: TextStyle(
                color: widget.isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee.withOpacity(0.8),
              ),
            ),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    // Validar antes de mostrar el diálogo
    if (!_isFormComplete()) {
      _showValidationDialog();
      return;
    }

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Información del productor ──────────────────────────
          _buildSectionTitle('Información del productor', textColor),
          const SizedBox(height: 8),
          _buildProducerForm(cardColor, textColor),
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
      ),
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

  // Formulario de productor con validaciones
  Widget _buildProducerForm(Color cardColor, Color textColor) {
    return NeumorphicBox(
      isDark: widget.isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Nombre del productor
          TextFormField(
            controller: _producerNameController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Nombre del productor *',
              labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13),
              hintText: 'Ingresa el nombre completo',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
              prefixIcon: Icon(Icons.person, color: AppTheme.primaryGreen, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGreen),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: _validateName,
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Número de celular
          TextFormField(
            controller: _phoneController,
            style: TextStyle(color: textColor, fontSize: 14),
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'Número de celular *',
              labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13),
              hintText: 'Ingresa 10 dígitos',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
              prefixIcon: Icon(Icons.phone, color: AppTheme.primaryGreen, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGreen),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              counterText: '',
            ),
            validator: _validatePhone,
            onChanged: (value) {
              if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
                _phoneController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                _phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phoneController.text.length),
                );
              }
              setState(() {});
            },
          ),
          const SizedBox(height: 12),

          // Correo electrónico
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: textColor, fontSize: 14),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo electrónico *',
              labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13),
              hintText: 'ejemplo@dominio.com',
              hintStyle: TextStyle(color: textColor.withOpacity(0.4), fontSize: 13),
              prefixIcon: Icon(Icons.email, color: AppTheme.primaryGreen, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryGreen),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.berryRed),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: _validateEmail,
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoInfoCard(Color cardColor, Color textColor) {
    final now = DateTime.now();

    // Usar el nombre del técnico desde el provider o un placeholder
    final technicianName = _technicianName.isNotEmpty ? _technicianName : 'Cargando...';

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
          _buildAutoInfoRow(
            Icons.location_on,
            'Ubicación',
            widget.location?.isNotEmpty == true ? widget.location! : 'No especificada',
            textColor,
          ),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.person, 'Responsable', technicianName, textColor),
          const SizedBox(height: 8),
          _buildAutoInfoRow(Icons.email, 'Correo técnico', _technicianEmail.isNotEmpty ? _technicianEmail : 'No disponible', textColor),
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
          hintText: 'Selecciona el objetivo *',
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
        validator: (value) => value == null ? 'Selecciona un objetivo' : null,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Observaciones *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(requerido)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.berryRed.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
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
            onChanged: (_) => setState(() {}),
          ),
        ],
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
          _buildSummaryRow('👨‍🌾 Productor', _producerNameController.text.isNotEmpty ? _producerNameController.text : 'No registrado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📱 Celular', _phoneController.text.isNotEmpty ? _phoneController.text : 'No registrado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('✉️ Email', _emailController.text.isNotEmpty ? _emailController.text : 'No registrado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('🌱 Finca', widget.farmName?.isNotEmpty == true ? widget.farmName! : 'No registrada', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('☕ Lote', widget.lotName?.isNotEmpty == true ? widget.lotName! : 'No registrado', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📍 Ubicación', widget.location?.isNotEmpty == true ? widget.location! : 'No especificada', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📷 Fotografías', '$_photos tomadas', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📋 Checklist', '$totalChecklist/${_checklistItems.length} completados', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('👤 Responsable', _technicianName.isNotEmpty ? _technicianName : 'No asignado', textColor),
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