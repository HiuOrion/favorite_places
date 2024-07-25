import 'dart:io';

import 'package:favorites_place/models/place.dart';
import 'package:favorites_place/widgets/image_input.dart';
import 'package:favorites_place/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_places.dart';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<AddPlacesScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;
    if (_selectedImage == null || enteredTitle.isEmpty || _selectedLocation == null) {
      return;
    }
    //kêt nối với consumer của provider
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm địa điểm mới "),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Expanded(
          child: Column(
            key: _formKey,
            children: [
              Form(
                child: TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 0 ||
                        value.length > 50) {
                      return "Vui lòng nhập lại kí tự";
                    }
                    return null;
                  },
                  controller: _titleController,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              LocationInput(onSelectLocation: (location) {
                _selectedLocation = location;
              }),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: _savePlace,
                child: const Center(
                  child: Text("Thêm mới"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
