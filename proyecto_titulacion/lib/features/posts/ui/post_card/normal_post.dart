import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
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

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  post.description
                )
              ],
            ),
          ),
          SizedBox( 
            width: double.infinity,
            
            child: (post.images != null && post.images!.isNotEmpty)
              ? StorageImage(
                  key:  ValueKey(post.images!.first),
                  imageKey: post.images!.first,
                  fit: BoxFit.cover,
              ) : Container(color: Colors.grey,),
          ),
          if (post.dates?.isNotEmpty == true)
            Padding(
              padding:const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: post.dates!.map((d) => Chip(label: Text(d.format()))).toList(),
              )
            ),
          Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                  },
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  label: const Text('Agendar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}