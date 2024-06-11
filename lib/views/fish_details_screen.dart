import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import '../models/fish_catch.dart';

class FishDetailsScreen extends StatelessWidget {
  final FishCatch fishCatch;

  const FishDetailsScreen(this.fishCatch, {super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du FISH'),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBox(
                title: fishCatch.nickname.toUpperCase(),
                subtitle: '${fishCatch.species} \nPoids: ${fishCatch.weight} kg \nTaille: ${fishCatch.length} cm\nDate: ${dateFormat.format(fishCatch.date)}\nMétéo: ${fishCatch.weather}',
              ),
              const SizedBox(height: 20),

              Stack(
                children: [

                  // IMAGE FISH
                  _buildImageBox(
                    imagePath: fishCatch.imagePath,
                  ),

                  // BUTTON DOWNLOAD ON GALLERY
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),

                    ),
                    onPressed: () async {
                      // SAVE IMAGE IN GALLERY
                      final bool? result = await GallerySaver.saveImage(fishCatch.imagePath);
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image enregistrée dans la galerie')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erreur lors de l\'enregistrement de l\'image')),
                        );
                      }
                    },
                    child: const Icon(Icons.download, color: Colors.black, size: 40,),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBox({required String imagePath}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
