import 'package:favorites_place/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      address: 'address',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting; // Kiểm tra xem đã chọn place hay chưa?

  @override
  State<MapScreen> createState() {
    // TODO: implement createState
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isSelecting ? "Chọn vị trí của bạn" : "Vị trí của bạn "),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting  ? null : (position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        // Không hiên thị điểm đánh dấu nào khi không chọn
        markers: (_pickedLocation == null && widget.isSelecting )? {} : {
          //Set chỉ lưu value không trùng lặp
          Marker(
            markerId: MarkerId('m1'),
            // position = _pickedPosition nếu khác null
            // nếu null sẽ bằng địa điểm mặc định
            position: _pickedLocation ?? LatLng(
                    widget.location.latitude,
                    widget.location.longitude,
                  ),
          )
        },
      ),
    );
  }
}
