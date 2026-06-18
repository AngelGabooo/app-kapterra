// lib/features/activities/presentation/widgets/activity_search_bar.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ActivitySearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const ActivitySearchBar({super.key, required this.onSearchChanged});

  @override
  State<ActivitySearchBar> createState() => _ActivitySearchBarState();
}

class _ActivitySearchBarState extends State<ActivitySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Buscar actividad...',
            hintStyle: TextStyle(color: AppTheme.darkCoffee.withOpacity(0.4)),
            prefixIcon: Icon(Icons.search, color: AppTheme.primaryGreen),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: AppTheme.darkCoffee.withOpacity(0.5)),
              onPressed: () {
                _controller.clear();
                widget.onSearchChanged('');
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}