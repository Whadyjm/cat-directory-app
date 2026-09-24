import 'package:flutter/material.dart';

class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({
    super.key,
    required this.breedName,
    this.extra,
  });

  final String breedName;
  final Object? extra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breedName)),
      body: const Center(child: Text('Breed Detail — coming soon')),
    );
  }
}
