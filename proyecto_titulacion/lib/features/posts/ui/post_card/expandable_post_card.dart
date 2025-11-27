import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_titulacion/features/posts/controller/posts_list_controller.dart';
import 'package:proyecto_titulacion/features/posts/service/posts_api_service.dart';
import 'package:proyecto_titulacion/models/Post.dart';
import 'package:proyecto_titulacion/common/ui/widgets/storage_image.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandablePostCard extends ConsumerStatefulWidget {
  final Post post;
  const ExpandablePostCard({super.key, required this.post, required int index});

  @override
  ConsumerState<ExpandablePostCard> createState() => _ExpandablePostCardState();
}



class _ExpandablePostCardState extends ConsumerState<ExpandablePostCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    
    Future<void> _guardarEnCalendarioNativo(Post post) async {
      if (post.dates == null || post.dates!.isEmpty) return;

      final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

      // 1. PEDIR PERMISOS
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          print(" El usuario denegó el permiso");
          return;
        }
      }

      // 2. BUSCAR EL CALENDARIO POR DEFECTO
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      final calendar = calendarsResult.data?.firstWhere(
        (c) => c.isDefault == true && c.isReadOnly == false,
        orElse: () => calendarsResult.data!.first,
      );

      if (calendar == null) {
        print("No se encontró ningún calendario en el celular");
        return;
      }

      // 3. GUARDAR LAS FECHAS
      for (var dateTemporal in post.dates!) {
        final fecha = DateTime.parse(dateTemporal.toString());
        
        final event = Event(
          calendar.id,
          title: "Evento: ${post.title}",
          description: post.description ?? "Guardado desde TripsPlanner",
          start: tz.TZDateTime.from(fecha, tz.local),
          end: tz.TZDateTime.from(fecha.add(const Duration(hours: 2)), tz.local),
          allDay: true,
        );

        final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
        
        if (result!.isSuccess && result.data != null) {
          print("Fecha $fecha guardada con éxito en calendario ${calendar.name}");
        } else {
          print("Error guardando fecha: ${result.errors}");
        }
      }
      
      // Avisar al usuario al final
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Fechas guardadas en tu calendario!'))
        );
      }
    }

    return Card(
      elevation: 0, 
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 55, height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  image: DecorationImage(
                    image: ResizeImage(
                      NetworkImage('https://picsum.photos/seed/${post.id}/200'),
                      width: 200,
                    ),
                  ),
                ),
              ),
              // Textos
              title: Text(
                isExpanded ? 
                [
                  post.authorName, 
                  post.authorMiddle, 
                  post.authorFamily].where((text) => text != null && text.isNotEmpty).join(' ') 
                : post.title , 
                style: const TextStyle(fontWeight: FontWeight.bold) ),
                subtitle: Text(isExpanded ? post.createdAt.toString() : "Toca para expandir"),
                trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,                          
              alignment: Alignment.topCenter,
              child: isExpanded 
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: (post.images != null && post.images!.isNotEmpty)
                          ? StorageImage(
                            imageKey: post.images!.first,
                          
                            fit: BoxFit.cover,
                          ) : Container(color: Colors.grey,),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title
                                ,style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                post.description
                              )
                            ],
                          )
                      ),
                      //Fechas
                      if (post.dates?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Wrap(
                              spacing: 8,
                              children: post.dates!
                                  .map((d) => Chip(label: Text(d.format())))
                                  .toList(),
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                               showModalBottomSheet(
                                context: context, 
                                isScrollControlled: true,
                                useSafeArea: true,
                                showDragHandle: true,
                                builder: (context) => SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.9,
                                  //child: EditPostSheet(post: post), 
                                ),
                               );
                              }, 
                              icon: const Icon(Icons.update_outlined, size: 18),
                              label: const Text('Modificar'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.amber,  
                              ),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                               _guardarEnCalendarioNativo(post);
                              }, 
                              icon: const Icon(Icons.calendar_month_outlined, size: 18),
                              label: const Text('Agendar'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.amber,  
                              ),
                            ),
                          ],
                        )
                      ),
                      
                    ],
                  ) 
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}