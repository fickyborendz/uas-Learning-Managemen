import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? profileImage;
  final double size;
  final String? name;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.profileImage,
    this.size = 60,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      child: _buildAvatarContent(context),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    // Priority: profileImage > imageUrl > initials
    if (profileImage != null) {
      return ClipOval(
        child: Image.file(
          profileImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildInitials(),
          errorWidget: (context, url, error) => _buildInitials(),
        ),
      );
    }
    
    return _buildInitials();
  }

  Widget _buildInitials() {
    String initials = 'U';
    
    if (name != null && name!.isNotEmpty) {
      final nameParts = name!.split(' ');
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty) {
        initials = nameParts[0][0].toUpperCase();
      }
    }
    
    return Text(
      initials,
      style: TextStyle(
        fontSize: size * 0.4,
        fontWeight: FontWeight.bold,
        color: Colors.blue, // Using a fixed color instead of context
      ),
    );
  }
}