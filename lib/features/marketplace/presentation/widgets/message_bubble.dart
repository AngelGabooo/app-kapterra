import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isDark;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isFromBuyer = message.isFromBuyer;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromBuyer ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isFromBuyer)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.senderName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromBuyer
                    ? AppTheme.primaryGreen
                    : (isDark ? AppTheme.coffeeDeep : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isFromBuyer ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isFromBuyer ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFromBuyer)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.goldCoffee,
                      ),
                    ),
                  if (message.type == MessageType.text) ...[
                    const SizedBox(height: 4),
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: isFromBuyer ? Colors.white : textColor,
                      ),
                    ),
                  ] else if (message.type == MessageType.offer) ...[
                    const SizedBox(height: 4),
                    _buildOfferMessage(textColor, isFromBuyer),
                  ] else if (message.type == MessageType.document) ...[
                    _buildDocumentMessage(textColor, isFromBuyer),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isFromBuyer
                              ? Colors.white.withOpacity(0.6)
                              : textColor.withOpacity(0.4),
                        ),
                      ),
                      if (message.isRead && isFromBuyer) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFromBuyer)
            const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildOfferMessage(Color textColor, bool isFromBuyer) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.goldCoffee.withOpacity(isFromBuyer ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.goldCoffee.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💰 Oferta',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.goldCoffee,
            ),
          ),
          const SizedBox(height: 8),
          ...message.metadata?.entries.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 11,
                    color: isFromBuyer ? Colors.white.withOpacity(0.7) : textColor.withOpacity(0.6),
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFromBuyer ? Colors.white : textColor,
                  ),
                ),
              ],
            ),
          )).toList() ?? [],
        ],
      ),
    );
  }

  Widget _buildDocumentMessage(Color textColor, bool isFromBuyer) {
    return Row(
      children: [
        Icon(
          Icons.description,
          size: 20,
          color: isFromBuyer ? Colors.white : AppTheme.goldCoffee,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 13,
              color: isFromBuyer ? Colors.white : textColor,
            ),
          ),
        ),
      ],
    );
  }
}