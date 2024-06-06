import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fish_catch.dart';
import '../providers/fish_catch_provider.dart';
import 'new_catch_screen.dart';
import 'fish_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FISHNOTE', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'BungeeInline')),
        centerTitle: true,
        toolbarHeight: 90, // Hauteur de la barre d'outils augmentée
      ),
      body: Consumer<FishCatchProvider>(
        builder: (ctx, fishCatchProvider, _) => ListView.builder(
          itemCount: fishCatchProvider.fishCatches.length,
          itemBuilder: (ctx, index) {
            final fishCatch = fishCatchProvider.fishCatches[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: ListTile(
                leading: fishCatch.imagePath.isNotEmpty
                    ? Image.file(
                  File(fishCatch.imagePath),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
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
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,20.0), // Ajouter de l'espace autour du bouton
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const NewCatchScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), backgroundColor: Colors.white, // Couleur de fond du bouton
            elevation: 8, // Élévation pour donner une ombre
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15.0),// Aligner le contenu au centre du bouton
          ),
          child: Text('\u{1F41F}', style: TextStyle(fontSize: 30)), // Emoji poisson
        ),
      ),

    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, FishCatchProvider provider, FishCatch fishCatch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la prise'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette prise ?'),
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
}
