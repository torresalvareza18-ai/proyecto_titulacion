import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:flutter/widgets.dart';
import 'package:proyecto_titulacion/common/ui/widgets/storage_image.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:proyecto_titulacion/models/Post.dart';
import 'package:timezone/timezone.dart' as tz;


class Normal_post extends StatefulWidget {
  final Post post;
  const Normal_post({super.key, required this.post, required int index});

  @override
  State<Normal_post> createState() => _normal_postState();
}

class _normal_postState extends State<Normal_post> {
  
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {

    final post = widget.post;

    Future<void> _guardarEnCalendarioNativo(Post post) async {
      if (post.dates == null || post.dates!.isEmpty) return;

      final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

      //Pedir permisos a don celular
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          print("El usuario denego el permiso");
          return;
        }
      }
    
      //Obtner el calendario por defecto
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      final calendar = calendarsResult.data?.firstWhere(
        (c) => c.isDefault == true && c.isReadOnly == false,
        orElse: () => calendarsResult.data!.first,
      );

      if (calendar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Calendario no encontrado"))
        );
      }

      //Guardar las fechas
      for (var dateTemporal in post.dates!) {
        final fecha = DateTime.parse(dateTemporal.toString());
        final event = Event(
          calendar?.id,
          title: "Evento: ${post.title}",
          description: post.description,
          start: tz.TZDateTime.from(fecha, tz.local),
          end: tz.TZDateTime.from(fecha.add(const Duration(hours: 2)), tz.local),
          allDay: true,
        );

        final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);

      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fechas guardadas en tu calendario"))
        );
      }

    }

    String formatDate(String dateString) {
      try {
        initializeDateFormatting('es'); 
        
        DateTime date = DateTime.parse(dateString);
        String formatted = DateFormat("EEEE d 'de' MMMM", 'es').format(date);
        
        return "${formatted[0].toUpperCase()}${formatted.substring(1)}";
      } catch (e) {
        return dateString; 
      }
    }

    final Color primaryGreen = Colors.green;
    final Color lightGreenBackground = const Color(0xFFE8F5E9);
    final Color detailItemColor = const Color(0xFFF1F8E9); 

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: lightGreenBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFDD835),
                radius: 24,
                child: Text(
                  'IMG',
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Facebook: UPIICSA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  Text(
                    'Eventos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            post.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          if (post.dates != null && post.dates!.isNotEmpty)
            _buildDetailRow(
              context, 
              Icons.calendar_today, 
              formatDate(post.dates!.first.toString()), 
            ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context, 
            Icons.access_time, 
            "09:00 AM - 09:00 PM" 
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context, 
            Icons.location_on, 
            "Edificio Culturales, Auditorio A" 
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context, 
            Icons.people, 
            "189 Interesados" 
          ),

          const SizedBox(height: 16),
          SizedBox( 
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: (post.images != null && post.images!.isNotEmpty)
                ? StorageImage(
                    key:  ValueKey(post.images!.first),
                    imageKey: post.images!.first,
                    fit: BoxFit.cover,
                ) : Container(color: Colors.grey,
              ),
            )
          ),
          const SizedBox(height: 12),

          Text(
            '234 Me Gusta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildActionButton(Icons.favorite_border, 'Me Gusta'),
                ),
                const SizedBox(width: 10), 
                Expanded(
                  child: _buildActionButton(Icons.bookmark_border, 'Guardar'),
                ),
                const SizedBox(width: 10), 
                Expanded(
                  child: _buildActionButton(Icons.calendar_today, 'Agendar'),
                ),
            ],
          ),
        ],
      ),
    );
  }
  

Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.green.shade700), 
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: textTheme.titleMedium?.copyWith(
              color: Colors.green.shade700, 
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildActionButton(IconData icon, String text) {
    final Color mainGreenColor = Colors.green.shade600; 
    final Color fillColor = Colors.green.shade100.withOpacity(0.5); 
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: mainGreenColor,
        backgroundColor: fillColor,
        side: BorderSide(color: mainGreenColor, width: 1.5),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 22),
      label: Flexible(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
  
