import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:proyecto_titulacion/models/Post.dart';
import 'package:proyecto_titulacion/common/ui/widgets/storage_image.dart';
import 'package:proyecto_titulacion/common/ui/widgets/amplify_video_player.dart';
import 'package:timezone/timezone.dart' as tz;

class Normal_post extends ConsumerWidget {
  final Post post;
  final int index;

  const Normal_post({
    super.key,
    required this.post,
    required this.index,
  });

  static const Color _cardBackgroundColor = Color(0xFFE8F5E9);
  static const Color _chipBackgroundColor = Color(0xFFFFF9C4);
  static final Color _textColor = Colors.green[800]!;

  bool _isVideo(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);
  }

  Widget _buildMediaContent(String mediaKey) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: _isVideo(mediaKey)
          ? Container(
              color: Colors.black,
              constraints: const BoxConstraints(maxHeight: 400),
              child: AmplifyVideoPlayer(storageKey: mediaKey),
            )
          : Container(
              color: Colors.grey[200],
              constraints: const BoxConstraints(maxHeight: 400),
              width: double.infinity,
              child: StorageImage(
                key:  ValueKey(post.images!.first),
                    imageKey: post.images!.first,
                    fit: BoxFit.cover,
              ),
            ),
    );
  }

  String _getFormattedDate() {
    if (post.dates == null || post.dates!.isEmpty) return "Próximamente";
    try {
      final dynamic decoded = jsonDecode(post.dates!);
      String dateStr;
      if (decoded is List && decoded.isNotEmpty) {
        dateStr = decoded.first.toString();
      } else if (decoded is String) {
         dateStr = decoded;
      } else {
         return "Próximamente";
      }

      final DateTime? date = DateTime.tryParse(dateStr);
      if (date != null) {
        return DateFormat('EEEE d \'de\' MMMM', 'es_ES').format(date); 
      }
      return dateStr;
    } catch (e) {
      return post.dates!;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? mediaKey = (post.images != null && post.images!.isNotEmpty)
        ? post.images![0]
        : null;
    

    return Card(
      color: _cardBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/icon_placeholder.png'),
                        fit: BoxFit.cover
                    )
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Facebook: UPIICSA",
                      style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 16),
                    ),
                    Text(
                      "Eventos",
                      style: TextStyle(color: _textColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
            if (post.description != null && post.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                post.description!,
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.3),
              ),
            ],
            const SizedBox(height: 16),

            _buildInfoChip(Icons.calendar_today, _getFormattedDate()),
            _buildInfoChip(Icons.access_time, "09:00 AM - 09:00AM"),
            _buildInfoChip(Icons.location_on, "Edificio Culturales, Auditorio A"),
            _buildInfoChip(Icons.people, "189 Interesados"),
            const SizedBox(height: 16),

            if (mediaKey != null)
              _buildMediaContent(mediaKey),

            const SizedBox(height: 12),

            Text(
              "234 Me Gusta",
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.favorite_border, "Me Gusta", () {}),
                _buildActionButton(Icons.bookmark_border, "Guardar", () {}),
                _buildActionButton(Icons.calendar_today, "Agendar", () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _chipBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: _textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: _textColor,
        side: BorderSide(color: _textColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: Icon(icon, size: 20, color: _textColor),
      label: Text(label, style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
    );
  }
}