import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ngo_profile_model.dart';
import '../services/profile_service.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final NgoProfile profile;
  final VoidCallback onImageUpdated;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.onImageUpdated,
  });

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  final ProfileService _profileService = ProfileService();
  bool _isUploadingImage = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() => _isUploadingImage = true);

    try {
      await _profileService.uploadProfileImage(File(pickedFile.path));
      widget.onImageUpdated();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B5ECD).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with camera icon
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6B5ECD).withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _isUploadingImage
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF6B5ECD),
                            strokeWidth: 2,
                          ),
                        )
                      : widget.profile.profileImageUrl != null
                          ? Image.network(
                              widget.profile.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildDefaultAvatar(),
                            )
                          : _buildDefaultAvatar(),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B5ECD),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // NGO info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.profile.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    if (widget.profile.isVerified) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF6B5ECD),
                        size: 18,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (widget.profile.isVerified)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B5ECD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF6B5ECD).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Verified NGO',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B5ECD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.mail_outline,
                  text: widget.profile.email,
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.language,
                  text: widget.profile.website,
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: widget.profile.location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFF6B5ECD).withOpacity(0.1),
      child: const Icon(
        Icons.account_balance,
        size: 36,
        color: Color(0xFF6B5ECD),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF888888)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}