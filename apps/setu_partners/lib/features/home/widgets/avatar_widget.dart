// lib/features/home/widgets/avatar_widget.dart

import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final VoidCallback? onTap;
  final int notificationCount;

  const AvatarWidget({
    super.key,
    required this.imageUrl,
    this.radius = 22,
    this.onTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1.5),
                ),
                child: Text(
                  notificationCount > 9 ? '9+' : '$notificationCount',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}