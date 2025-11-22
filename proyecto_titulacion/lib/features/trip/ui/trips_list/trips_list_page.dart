import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_titulacion/common/utils/colors.dart' as constants; 
import 'package:proyecto_titulacion/features/trip/controller/trips_list_controller.dart';
import 'package:proyecto_titulacion/features/trip/ui/trips_gridview/trips_list_gridview.dart';
import 'package:proyecto_titulacion/features/trip/ui/trips_list/add_trip_bottomsheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripsListPage extends ConsumerWidget {
 const TripsListPage({
   super.key,
 });

 Future<void> showAddTripDialog(BuildContext context) =>
     showModalBottomSheet<void>(
       isScrollControlled: true,
       elevation: 5,
       context: context,
       builder: (sheetContext) {
         return const AddTripBottomSheet();
       },
     );

 @override
 Widget build(BuildContext context, WidgetRef ref) {
   final tripsListValue = ref.watch(tripsListControllerProvider);
   return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Viajes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Amplify.Auth.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          )
        ],
      ),
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         showAddTripDialog(context);
       },
       backgroundColor: const Color(constants.primaryColorDark),
       child: const Icon(Icons.add),
     ),
     body: TripsListGridView(
       tripsList: tripsListValue,
     ),
   );
 }
}