import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart'; // Import pour générer des ID uniques
import '../models/fish_catch.dart'; // Importer FishCatch depuis models/fish_catch.dart
import '../providers/fish_catch_provider.dart';

class NewCatchScreen extends StatefulWidget {
  const NewCatchScreen({super.key});

  @override
  _NewCatchScreenState createState() => _NewCatchScreenState();
}

class _NewCatchScreenState extends State<NewCatchScreen> {
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _nicknameController = TextEditingController();
  File? _selectedImage;
  String? _selectedSpecies;

  final List<String> _fishSpecies = [
    'Achigan à grande bouche',
    'Achigan à petite bouche',
    'Aiglefin',
    'Anguille',
    'Bar commun (ou Loup de mer)',
    'Bar rayé',
    'Barbotte',
    'Barbue de rivière',
    'Barracuda',
    'Barre grise',
    'Brochet',
    'Carpe',
    'Carpe commune',
    'Carpe miroir',
    'Carpe herbivore',
    'Chabot',
    'Chinchard',
    'Colin (ou Merlu)',
    'Corb',
    'Dorade grise',
    'Dorade rose',
    'Dorade royale',
    'Esturgeon',
    'Flétan',
    'Gardon',
    'Gobie',
    'Grande alose',
    'Grondin',
    'Hareng',
    'Lieu jaune',
    'Lieu noir',
    'Maquereau',
    'Morue',
    'Mulet',
    'Perche',
    'Perche du Nil',
    'Perche truitée',
    'Plie',
    'Poisson-chat',
    'Rouget',
    'Sandre',
    'Saumon',
    'Saumon atlantique',
    'Saumon de fontaine',
    'Saumon quinnat',
    'Saumon sockeye',
    'Sole',
    'Tanche',
    'Thon albacore',
    'Thon rouge',
    'Truite arc-en-ciel',
    'Truite fario',
    'Truite de mer',
    'Truite mouchetée',
    'Truite steelhead',
    'Turbot',
    'Vivaneau'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _saveCatch() {
    if (_selectedSpecies == null ||
        _weightController.text.isEmpty ||
        _lengthController.text.isEmpty ||
        _selectedImage == null ||
        _nicknameController.text.isEmpty) {
      return;
    }

    final newCatch = FishCatch(
      id: const Uuid().v4(),
      nickname: _nicknameController.text,
      species: _selectedSpecies!,
      weight: double.parse(_weightController.text),
      length: double.parse(_lengthController.text),
      date: DateTime.now(),
      imagePath: _selectedImage!.path,
    );

    Provider.of<FishCatchProvider>(context, listen: false).addFishCatch(newCatch);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une prise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedSpecies,
              decoration: const InputDecoration(labelText: 'Espèce'),
              items: _fishSpecies.map((String species) {
                return DropdownMenuItem<String>(
                  value: species,
                  child: Text(species),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSpecies = newValue;
                });
              },
            ),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: 'Surnom \u{1F603}'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Poids (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _lengthController,
              decoration: const InputDecoration(labelText: 'Taille (cm)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _selectedImage == null
                  ? const Text('Aucune image sélectionnée')
                  : Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveCatch,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
