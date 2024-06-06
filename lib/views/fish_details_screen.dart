import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importer le package intl
import '../models/fish_catch.dart';

class FishDetailsScreen extends StatelessWidget {
  final FishCatch fishCatch;

  const FishDetailsScreen(this.fishCatch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy à HH:mm'); // Définir le format de date

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du poisson'), // Titre plus descriptif
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBox(
              title: fishCatch.nickname.toUpperCase(), // Nom de l'espèce en majuscules et en gros
              subtitle: '${fishCatch.species} \nPoids: ${fishCatch.weight} kg \nTaille: ${fishCatch.length} cm\nDate: ${dateFormat.format(fishCatch.date)}',
            ),
            const SizedBox(height: 20), // Espacement accru pour une meilleure séparation visuelle
            if (fishCatch.imagePath != null) // Gérer un chemin d'image potentiellement nul
              _buildImageBox(
                imagePath: fishCatch.imagePath!,
              ),
          ],
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
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24, // Taille de police plus grande pour le nom de l'espèce
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
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
            offset: const Offset(0, 3), // changes position of shadow
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
