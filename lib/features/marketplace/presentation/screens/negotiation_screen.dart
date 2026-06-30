import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/message_model.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/message_bubble.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({super.key});

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _messages = [
      MessageModel(
        id: '1',
        senderName: 'Juan Pérez',
        senderRole: 'Productor',
        content: '¡Hola! Me interesa tu lote de café. ¿Podrías darme más información?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        isFromBuyer: false,
        isRead: true,
      ),
      MessageModel(
        id: '2',
        senderName: 'Coffee Export México',
        senderRole: 'Comprador',
        content: '¡Claro! Tenemos un lote Geisha Premium de 420 kg disponibles. ¿Te gustaría visitar la finca?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        type: MessageType.text,
        isFromBuyer: true,
        isRead: true,
      ),
      MessageModel(
        id: '3',
        senderName: 'Juan Pérez',
        senderRole: 'Productor',
        content: 'Sí, me encantaría. ¿Cuándo podría agendar una visita?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        type: MessageType.text,
        isFromBuyer: false,
        isRead: true,
      ),
      MessageModel(
        id: '4',
        senderName: 'Coffee Export México',
        senderRole: 'Comprador',
        content: 'Podemos coordinar para la próxima semana. ¿Qué día te acomoda mejor?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: MessageType.text,
        isFromBuyer: true,
        isRead: true,
      ),
      MessageModel(
        id: '5',
        senderName: 'Juan Pérez',
        senderRole: 'Productor',
        content: 'Excelente, el martes en la mañana me funciona perfecto. ¡Gracias!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
        isFromBuyer: false,
        isRead: true,
      ),
    ];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'Coffee Export México',
      senderRole: 'Comprador',
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      type: MessageType.text,
      isFromBuyer: true,
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            // Barra superior
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.arrow_back, color: textColor),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.coffee,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lote Geisha Premium',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Activo',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '👨‍🌾 Juan Pérez',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.phone, color: textColor, size: 20),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, color: textColor, size: 20),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Mensajes
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: _messages[index],
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ),

            // Caja de mensaje
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.attach_file, color: textColor.withOpacity(0.4), size: 20),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt, color: textColor.withOpacity(0.4), size: 20),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                        style: TextStyle(fontSize: 14, color: textColor),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}