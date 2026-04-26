import 'package:flutter/material.dart';
import '../models/state_item.dart';

class StateRow extends StatelessWidget {
  final List<StateItem> states;

  /// Called when the user taps a state circle.
  final void Function(StateItem state) onStateTap;

  /// Called when "See All" is tapped.
  final VoidCallback onSeeAll;

  const StateRow({
    super.key,
    required this.states,
    required this.onStateTap,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore by State',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D0D0D),
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B4EFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: states.length,
            itemBuilder: (_, index) {
              final state = states[index];
              return GestureDetector(
                onTap: () => onStateTap(state),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(state.imageUrl),
                        backgroundColor: Colors.grey.shade200,
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(height: 6),
                      Text(
                        state.name,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0D0D0D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}