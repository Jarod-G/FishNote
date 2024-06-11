import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../models/fish_catch.dart';
import '../providers/fish_catch_provider.dart';
import 'dart:io';


class NewCatchScreen extends StatefulWidget {
  const NewCatchScreen({super.key});

  void initState() {
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statusMap = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();


    // Ouvrir les paramètres de l'application si une permission est définitivement refusée
    if (statusMap.values.any((status) => status.isPermanentlyDenied)) {
      openAppSettings();
    }
  }

  @override
  _NewCatchScreenState createState() => _NewCatchScreenState();
}

class _NewCatchScreenState extends State<NewCatchScreen> {
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _nicknameController = TextEditingController();
  File? _selectedImage;
  String? _selectedSpecies;
  String? _selectedWeather;

  final List<String> _fishSpecies = [
    'Able de Heckel',
    'Ablette',
    'Achigan à grande bouche',
    'Achigan à petite bouche',
    'Aiglefin',
    'Alose',
    'Alose feinte',
    'Anguille',
    'Bar commun (ou Loup de mer)',
    'Bar rayé',
    'Barbeau fluviatile',
    'Barbeau méridional',
    'Barbeau tacheté',
    'Barbotte',
    'Barbue de rivière',
    'Barracuda',
    'Barre grise',
    'Blageon',
    'Bouvière',
    'Brème bordelière',
    'Brème commune',
    'Brochet',
    'Carpe',
    'Carpe herbivore',
    'Carpe miroir',
    'Chevaine',
    'Chabot',
    'Chévesne',
    'Chien de mer',
    'Chinchard',
    'Colin (ou Merlu)',
    'Corb',
    'Dorade grise',
    'Dorade rose',
    'Dorade royale',
    'Épinoche',
    'Esturgeon',
    'Flet',
    'Flétan',
    'Gardon',
    'Gobie',
    'Goujon',
    'Grande alose',
    'Grondin',
    'Hareng',
    'Lieu jaune',
    'Lieu noir',
    'Lotte',
    'Maquereau',
    'Morue',
    'Mulet',
    'Omble chevalier',
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
    'Silure',
    'Sole',
    'Spirlin',
    'Tanche',
    'Thon albacore',
    'Thon rouge',
    'Truite arc-en-ciel',
    'Truite de mer',
    'Truite fario',
    'Truite mouchetée',
    'Truite steelhead',
    'Turbot',
    'Vairon',
    'Vandoise',
    'Véronic',
    'Verron',
    'Vivaneau',
    'Zébrine'
  ];

  final List<String> _weatherOptions = [
    'Soleil',
    'Nuageux',
    'Pluvieux',
    'Orageux',
    'Neigeux',
  ];

  Future<void> _pickImageCamera() async {
    //await _requestPermissions();
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageGallery() async {
    //await _requestPermissions();
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _saveCatch() {
    if (_selectedSpecies == null ||
        _selectedWeather == null ||
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
      weather: _selectedWeather!,
    );

    Provider.of<FishCatchProvider>(context, listen: false).addFishCatch(newCatch);

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un FISH'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children:
          [
            DropdownButtonFormField<String>(
              value: _selectedSpecies,
              decoration: InputDecoration(
                labelText: 'Espèce',
                labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              items: _fishSpecies.map((String species) {
                return DropdownMenuItem<String>(
                  value: species,
                  child: Text(
                    species,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSpecies = newValue;
                });
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
              iconSize: 30,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: 'Surnom \u{1F603}',
                labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Poids (kg)',
                labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _lengthController,
              decoration: InputDecoration(
                labelText: 'Taille (cm)',
                labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // WEATHER
            DropdownButtonFormField<String>(
              value: _selectedWeather,
              decoration: InputDecoration(
                labelText: 'Météo',
                labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              items: _weatherOptions.map((String weather) {
                return DropdownMenuItem<String>(
                  value: weather,
                  child: Text(
                    weather,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedWeather = newValue;
                });
              },
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
              iconSize: 30,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _selectedImage == null
                  ? const Text('Aucune image sélectionnée')
                  : Image.file(
                _selectedImage!,
                fit: BoxFit.fill,
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImageCamera,
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              label: const Text('Prendre une photo',style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade300),
            ),
            ElevatedButton.icon(
              onPressed: _pickImageGallery,
              icon: const Icon(Icons.folder,color: Colors.black),
              label: const Text('Importer une photo',style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade300),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveCatch,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shadowColor: Colors.green, elevation: 8,padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),),
              child: const Text('ENREGISTRER', style: TextStyle(color: Colors.white, fontSize: 25))
            ),
          ],
        ),
      ),
    );
  }
}
