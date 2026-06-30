import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart';

class MakeOfferScreen extends StatefulWidget {
  final MarketplaceLotModel lot;

  const MakeOfferScreen({super.key, required this.lot});

  @override
  State<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends State<MakeOfferScreen> {
  int _quantity = 100;
  double _price = 92;
  bool _isSaving = false;
  String _selectedPaymentMethod = 'Pago inmediato';
  String _selectedDeliveryMethod = 'Recoger en finca';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 15));
  final TextEditingController _observationsController = TextEditingController();

  final List<String> _paymentMethods = [
    'Pago inmediato',
    'Pago contra entrega',
    'Pago parcial',
    'Crédito autorizado',
  ];

  final List<String> _deliveryMethods = [
    'Recoger en finca',
    'Entrega en cooperativa',
    'Envío por transportista',
    'Entrega personalizada',
  ];

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  double get _total => _quantity * _price;
  double get _marketAveragePrice => 93;

  String get _competitivenessLabel {
    final diff = _price - _marketAveragePrice;
    if (diff < -5) return 'Muy competitiva';
    if (diff < -2) return 'Competitiva';
    if (diff < 2) return 'En rango';
    if (diff < 5) return 'Alta';
    return 'Muy alta';
  }

  Color get _competitivenessColor {
    final diff = _price - _marketAveragePrice;
    if (diff < -5) return Colors.green;
    if (diff < -2) return Colors.green.shade300;
    if (diff < 2) return AppTheme.goldCoffee;
    if (diff < 5) return Colors.orange;
    return Colors.red;
  }

  void _sendOffer() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de éxito
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              '¡Oferta enviada!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'El productor ha recibido tu propuesta y podrá responder desde Kaab Terra.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Botones en fila con mejor espaciado
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Ver negociación',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(RouteNames.explore);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con efecto glass
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.coffeeDeep.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeMedium.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: textColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Realizar Oferta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Envía una propuesta comercial',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.coffeeMedium.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.coffeeMedium.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.share,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Resumen del lote - Diseño moderno
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                              : [Colors.white, AppTheme.lightBeige],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryGreen.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.coffee,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.lot.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 12,
                                      color: textColor.withOpacity(0.4),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.lot.producerName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: textColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 10,
                                      color: textColor.withOpacity(0.3),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.lot.location,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: textColor.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${widget.lot.availableQuantity.toStringAsFixed(0)} kg',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Disponible',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Formulario de oferta con diseño moderno
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.1)
                                : Colors.black.withOpacity(0.02),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cantidad
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.height,
                                    size: 16,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cantidad solicitada (kg)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_quantity > 10) _quantity -= 10;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppTheme.coffeeMedium.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: AppTheme.primaryGreen,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _quantity = int.tryParse(value) ?? 0;
                                          if (_quantity > widget.lot.availableQuantity) {
                                            _quantity = widget.lot.availableQuantity.toInt();
                                          }
                                        });
                                      },
                                      controller: TextEditingController(
                                        text: _quantity.toString(),
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_quantity < widget.lot.availableQuantity) {
                                        _quantity += 10;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppTheme.coffeeMedium.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppTheme.primaryGreen,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _quantity / widget.lot.availableQuantity,
                                      backgroundColor: Colors.grey.withOpacity(0.2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(_quantity / widget.lot.availableQuantity * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Precio
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.goldCoffee.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.attach_money,
                                    size: 16,
                                    color: AppTheme.goldCoffee,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Precio ofrecido (MXN/kg)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.goldCoffee.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.goldCoffee,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _price = double.tryParse(value) ?? 0;
                                  });
                                },
                                controller: TextEditingController(
                                  text: _price.toStringAsFixed(2),
                                ),
                                decoration: InputDecoration(
                                  prefixText: '\$ ',
                                  hintText: '0.00',
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.3),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? AppTheme.coffeeDeep
                                      : Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 12,
                                  color: textColor.withOpacity(0.3),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Precio sugerido: \$${widget.lot.price.toStringAsFixed(0)} MXN/kg',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Monto estimado - Tarjeta destacada
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.coffeeMedium, AppTheme.coffeeDeep]
                              : [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calculate,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Monto estimado',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${_total.toStringAsFixed(0)} MXN',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_quantity} kg',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              Text(
                                '\$${_price.toStringAsFixed(2)}/kg',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Condiciones de compra
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  size: 18,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Condiciones de compra',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _paymentMethods.map((method) {
                                final isSelected = _selectedPaymentMethod == method;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPaymentMethod = method),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primaryGreen
                                          : (isDark
                                          ? AppTheme.coffeeMedium.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.05)),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.transparent
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      method,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        color: isSelected ? Colors.white : textColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Método de entrega
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  size: 18,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Método de entrega',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedDeliveryMethod,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? AppTheme.coffeeDeep
                                    : Colors.white,
                              ),
                              items: _deliveryMethods.map((method) {
                                return DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDeliveryMethod = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Comparación de precio
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.compare_arrows,
                                  size: 18,
                                  color: AppTheme.goldCoffee,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Comparación de precio',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mercado',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: textColor.withOpacity(0.4),
                                        ),
                                      ),
                                      Text(
                                        '\$${_marketAveragePrice.toStringAsFixed(0)}/kg',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tu oferta',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: textColor.withOpacity(0.4),
                                        ),
                                      ),
                                      Text(
                                        '\$${_price.toStringAsFixed(0)}/kg',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.goldCoffee,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estado',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: textColor.withOpacity(0.4),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _competitivenessColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          _competitivenessLabel,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _competitivenessColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _price / _marketAveragePrice,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(_competitivenessColor),
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Análisis IA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                              : [AppTheme.goldCoffee.withOpacity(0.05), AppTheme.primaryGreen.withOpacity(0.02)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.goldCoffee.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.psychology,
                              color: AppTheme.goldCoffee,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kaab AI',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Probabilidad de aceptación: 86%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textColor.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '86%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Observaciones
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  size: 18,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Observaciones',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: _observationsController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'Escribe condiciones adicionales...',
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.3),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppTheme.primaryGreen),
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? AppTheme.coffeeDeep
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón Enviar Oferta
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _sendOffer,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text(
                          'Enviar Oferta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}