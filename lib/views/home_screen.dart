import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fish_catch.dart';
import '../providers/fish_catch_provider.dart';
import 'new_catch_screen.dart';
import 'fish_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _selectedSpeciesFilter;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FishNote \u{1F3A3}',
          style: TextStyle(
            fontSize: 45,
            fontFamily: 'Bungee',
            color: Colors.lightGreen,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2, 4),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 90,
        surfaceTintColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher',
                      labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            _searchText = _searchController.text.toLowerCase();
                          });
                        },
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _searchText = text.toLowerCase();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list_sharp, color: Colors.blue,size: 40,),
                  onPressed: () {
                    _showSpeciesFilterDialog();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FishCatchProvider>(
              builder: (ctx, fishCatchProvider, _) {
                final filteredFishCatches = fishCatchProvider.fishCatches.where((fishCatch) {
                  final matchesSearchText = fishCatch.nickname.toLowerCase().contains(_searchText);
                  final matchesSpeciesFilter = _selectedSpeciesFilter == null || fishCatch.species == _selectedSpeciesFilter;
                  return matchesSearchText && matchesSpeciesFilter;
                }).toList();
                return ListView.builder(
                  itemCount: filteredFishCatches.length,
                  itemBuilder: (ctx, index) {
                    final fishCatch = filteredFishCatches[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      child: ListTile(
                        leading: fishCatch.imagePath.isNotEmpty
                            ? ClipOval(
                          child: Image.file(
                            File(fishCatch.imagePath),
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(
                          fishCatch.nickname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[900],
                          ),
                        ),
                        subtitle: Text(
                          '${fishCatch.weight} kg - ${fishCatch.length} cm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, fishCatchProvider, fishCatch);
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => FishDetailsScreen(fishCatch),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const NewCatchScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.lightGreen,
            elevation: 8,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),
          ),
          child: const Text(
            '\u{1F41F}',
            style: TextStyle(
              fontSize: 35,
              shadows: [
                Shadow(
                  color: Colors.blueGrey,
                  offset: Offset(4, 8),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, FishCatchProvider provider, FishCatch fishCatch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Supprimer le FISH \u{1F97A}', style: TextStyle(fontSize: 25)),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce FISH ? ', style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Supprimer'),
            onPressed: () {
              provider.removeFishCatch(fishCatch);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSpeciesFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Filtrer par espèce'),
          content: DropdownButtonFormField<String>(
            value: _selectedSpeciesFilter,
            items: _fishSpecies.map((String species) {
              return DropdownMenuItem<String>(
                value: species,
                child: Text(species),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedSpeciesFilter = newValue;
              });
              Navigator.of(ctx).pop();
            },
            decoration: const InputDecoration(labelText: 'Espèce'),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Réinitialiser'),
              onPressed: () {
                setState(() {
                  _selectedSpeciesFilter = null;
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}