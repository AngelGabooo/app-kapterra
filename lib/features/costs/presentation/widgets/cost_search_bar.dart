import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CostSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final bool isDark;

  const CostSearchBar({
    super.key,
    required this.onSearchChanged,
    this.isDark = false,
  });

  @override
  State<CostSearchBar> createState() => _CostSearchBarState();
}

class _CostSearchBarState extends State<CostSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = widget.isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : const Color(0xFFE8E0D5).withOpacity(0.9);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: NeumorphicBox(
        isDark: widget.isDark,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: _controller,
          style: TextStyle(color: textColor),
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Buscar costo...',
            hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
            prefixIcon: Icon(Icons.search, color: AppTheme.primaryGreen),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: textColor.withOpacity(0.5)),
              onPressed: () {
                _controller.clear();
                widget.onSearchChanged('');
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}