import 'package:favorites_place/models/place.dart';
import 'package:flutter/material.dart';

import '../screens/places_detail.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text("Không có địa điểm nào ",
            style: Theme.of(context)
                .textTheme
                .bodyLarge! //Thêm ! để ghi đè thêm màu lên
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 25,
          //Dùng FileImage là gì có kiểu trả về là ImageProvider
          backgroundImage: FileImage(places[index].image),
        ),
        title: Text(places[index].title,
            style: Theme.of(context)
                .textTheme
                .titleMedium! //Thêm ! để ghi đè thêm màu lên
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
        subtitle: Text(places[index].location.address,
            style: Theme.of(context)
                .textTheme
                .bodySmall! //Thêm ! để ghi đè thêm màu lên
                .copyWith(color: Theme.of(context).colorScheme.onBackground)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => PlacesDetailScreen(place: places[index])));
        },
      ),
      itemCount: places.length,
    );
  }
}
