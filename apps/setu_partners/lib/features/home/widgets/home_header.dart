import 'package:flutter/material.dart';
import 'package:setu_partners/features/home/widgets/location_bar.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int notificationCount;
  final String locationCity;
  final String locationCountry;
  final bool locationLoading;
  final VoidCallback onAvatarTap;
  final VoidCallback onLocationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.notificationCount,
    required this.locationCity,
    required this.locationCountry,
    required this.locationLoading,
    required this.onAvatarTap,
    required this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              locationLoading
                  ? Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ],
                    )
                  : LocationBar(
                      city: locationCity,
                      country: locationCountry,
                      onTap: onLocationTap,
                    ),
              // Profile icon button — replaces avatar image
              GestureDetector(
                onTap: onAvatarTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEEEBFF),
                        border: Border.all(
                          color: const Color(0xFF6B4EFF),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 22,
                        color: Color(0xFF6B4EFF),
                      ),
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            notificationCount > 9 ? '9+' : '$notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Hi, $userName! 👋',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0D0D0D),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Find opportunities. Make an impact.',
            style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
          ),
        ],
      ),
    );
  }
}