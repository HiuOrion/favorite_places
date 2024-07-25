import 'package:favorites_place/providers/user_places.dart';
import 'package:favorites_place/screens/add_place.dart';
import 'package:favorites_place/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    // TODO: implement createState
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Tải data trong CSDL
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlace();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    void addPlaces() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const AddPlacesScreen()));
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Địa điểm ưa thích của bạn"),
        actions: [
          IconButton(onPressed: addPlaces, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator(),)
            : PlacesList(places: userPlaces),
      ),
    );
  }
}
