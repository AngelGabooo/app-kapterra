// lib/features/buyer/presentation/widgets/register_technician_dialog.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/technician_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class RegisterTechnicianDialog extends StatefulWidget {
  final Function(TechnicianModel) onSave;

  const RegisterTechnicianDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<RegisterTechnicianDialog> createState() => _RegisterTechnicianDialogState();
}

class _RegisterTechnicianDialogState extends State<RegisterTechnicianDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedSpecialty = 'Agronomía';
  String _selectedStatus = 'Activo';

  final List<String> _specialties = [
    'Agronomía',
    'Fitopatología',
    'Suelos',
    'General',
  ];

  final List<String> _statuses = [
    'Activo',
    'Pendiente',
    'Inactivo',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                      'Registrar Técnico',
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
              const SizedBox(height: 20),

              // Nombre
              Text(
                'Nombre completo *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nombre del técnico',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
                validator: (value) => value?.isEmpty == true ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 16),

              // Email
              Text(
                'Correo electrónico *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'correo@ejemplo.com',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Ingresa el correo';
                  if (!value!.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Teléfono
              Text(
                'Número telefónico *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+52 123 456 7890',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
                validator: (value) => value?.isEmpty == true ? 'Ingresa el teléfono' : null,
              ),
              const SizedBox(height: 16),

              // Ubicación
              Text(
                'Ubicación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Ciudad, Estado',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
              ),
              const SizedBox(height: 16),

              // Especialidad
              Text(
                'Especialidad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.science, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
                items: _specialties.map((specialty) {
                  return DropdownMenuItem(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSpecialty = value!),
              ),
              const SizedBox(height: 16),

              // Estado
              Text(
                'Estado',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.circle_outlined, color: AppTheme.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                  ),
                  filled: true,
                  fillColor: isDark ? AppTheme.coffeeDark : Colors.grey.withOpacity(0.03),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: status == 'Activo'
                                ? Colors.green
                                : status == 'Pendiente'
                                ? Colors.orange
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(status),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              const SizedBox(height: 24),

              // Botones
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
                      text: 'Registrar',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final technician = TechnicianModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            fullName: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            specialty: _selectedSpecialty,
                            status: _selectedStatus,
                            registeredAt: DateTime.now(),
                            location: _locationController.text.isNotEmpty ? _locationController.text : null,
                          );
                          widget.onSave(technician);
                          Navigator.pop(context);
                        }
                      },
                      isLoading: false,
                      isEnabled: true,
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
}