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
import 'package:proyecto_titulacion/features/bookmarkPost/controller/bookmark_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Normal_post extends ConsumerStatefulWidget {
  final Post post;
  final int index;

  const Normal_post({
    super.key,
    required this.post,
    required this.index,
  });

  @override
  ConsumerState<Normal_post> createState() => _NormalPostState();
}

class _NormalPostState extends ConsumerState<Normal_post> {
  bool? _localSaved;

  static const Color _cardBackgroundColor = Color(0xFFE8F5E9);
  static const Color _chipBackgroundColor = Color(0xFFFFF9C4);
  static final Color _textColor = Colors.green[800]!;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
  }

  bool _isVideo(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);
  }

  Future<void> _guardarEnCalendarioNativo(Post post) async {
    if (post.dates == null || post.dates!.isEmpty) return;

    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

    var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        return;
      }
    }

    final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
    final calendar = calendarsResult.data?.firstWhere(
      (c) => c.isDefault == true && c.isReadOnly == false,
      orElse: () => calendarsResult.data!.first,
    );

    if (calendar == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Calendario no encontrado")));
      return;
    }

    List<dynamic> dateList = [];
    try {
      final dynamic decoded = jsonDecode(post.dates!);
      if (decoded is List) {
        dateList = decoded;
      } else if (decoded is String) dateList = [decoded];
    } catch (e) {
      dateList = [post.dates!]; 
    }

    for (var dateString in dateList) {
      final DateTime? fecha = DateTime.tryParse(dateString.toString());
      if (fecha != null) {
        final event = Event(
          calendar.id,
          title: "Evento: ${post.title}",
          description: post.description,
          start: tz.TZDateTime.from(fecha, tz.local),
          end: tz.TZDateTime.from(fecha.add(const Duration(hours: 2)), tz.local),
          allDay: true,
        );
        await deviceCalendarPlugin.createOrUpdateEvent(event);
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fechas guardadas en tu calendario"))
      );
    }
  }

  String _getFormattedDate() {
    if (widget.post.dates == null || widget.post.dates!.isEmpty) return "Próximamente";
    try {
      final dynamic decoded = jsonDecode(widget.post.dates!);
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
      return widget.post.dates!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    final logo = post.authorFamily;

    final socialStyles = <String, ({IconData icon, Color color})>{
      'Facebook': (icon: FontAwesomeIcons.facebookF, color: const Color(0xFF1877F2)),
      'Instagram': (icon: FontAwesomeIcons.instagram, color: const Color(0xFFE1306C)),
      'Pagina Administrador': (icon: FontAwesomeIcons.envelope, color: Colors.black),
    };

    final style = socialStyles[post.authorFamily];
    
    final bookmarkAsync = ref.watch(myBookmarksListProvider);
    bool backendSaved = bookmarkAsync.maybeWhen(
      data: (lista) => lista.any((item) => item?.postId == post.id),
      orElse: () => false, 
    );

    bool isSaved = _localSaved ?? backendSaved;

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
                    color: style?.color ?? Colors.grey,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: style != null 
                      ? FaIcon(style.icon, color: Colors.white, size: 20)
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            image: const DecorationImage(
                              image: AssetImage('images/amplify.png'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      '${post.authorFamily} : ${post.authorName}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 16),
                    ),
                    Text(
                      "${post.tags}",
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
            const SizedBox(height: 16),

            if (mediaKey != null)
              _buildMediaContent(mediaKey),

            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildActionButton(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    isSaved ? 'Guardado' : 'Guardar',
                    () {
                      setState(() {
                        _localSaved = !isSaved;
                      });

                      final notifier = ref.read(bookmarkSaveControllerProvider.notifier);
                      if (isSaved) {
                        notifier.removeBookmark(postId: post.id);
                      } else {
                        notifier.saveBookmark(postId: post.id);
                      }
                    },
                    isActive: isSaved,
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: _buildActionButton(
                    Icons.calendar_month, 
                    'Agendar', 
                    () => _guardarEnCalendarioNativo(post),
                    isActive: false
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                key: ValueKey(mediaKey),
                imageKey: mediaKey,
                fit: BoxFit.cover,
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

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, {bool isActive = false}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? Colors.white : _textColor,
        backgroundColor: isActive ? _textColor : Colors.transparent,
        side: BorderSide(color: _textColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      icon: Icon(icon, size: 20, color: isActive ? Colors.white : _textColor),
      label: Text(
        label, 
        style: TextStyle(
          color: isActive ? Colors.white : _textColor, 
          fontWeight: FontWeight.bold,
          fontSize: 13
        )
      ),
    );
  }
}