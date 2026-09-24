import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/app_injector.dart';
import '../../domain/entities/breed.dart';
import '../bloc/breeds_bloc.dart';
import '../../../cat_fact/presentation/cubit/cat_fact_cubit.dart';
import '../../../cat_fact/presentation/widgets/cat_fact_card.dart';

class BreedDetailPage extends StatelessWidget {
  const BreedDetailPage({
    super.key,
    required this.breedName,
    this.extra,
  });

  final String breedName;
  final Object? extra;

  Breed _resolveBreed(BuildContext context) {
    if (extra is Breed) {
      return extra as Breed;
    }
    final breeds = context.read<BreedsBloc>().state.allBreeds;
    final decodedName = Uri.decodeComponent(breedName).trim();
    for (final b in breeds) {
      if (b.breed.toLowerCase() == decodedName.toLowerCase()) {
        return b;
      }
    }
    return Breed(
      breed: decodedName.isNotEmpty ? decodedName : breedName,
      country: 'Desconocido',
      origin: 'Desconocido',
      coat: 'Desconocido',
      pattern: 'Desconocido',
    );
  }

  @override
  Widget build(BuildContext context) {
    final breed = _resolveBreed(context);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => CatFactCubit(
        getRandomFactUsecase: AppInjector.getRandomFactUsecase,
      )..fetchRandomFact(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Volver a la lista',
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          title: Text(
            breed.breed,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderCard(context, breed, colorScheme),
              const SizedBox(height: 20),
              _buildAttributesSection(context, breed, colorScheme),
              const SizedBox(height: 24),
              const CatFactCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    Breed breed,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'breed-icon-${breed.breed}',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.2),
                    colorScheme.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.pets,
                color: colorScheme.primary,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Hero(
            tag: 'breed-name-${breed.breed}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                breed.breed,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  breed.country.isNotEmpty ? breed.country : 'Desconocido',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesSection(
    BuildContext context,
    Breed breed,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Características',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildAttributeTile(
                context,
                title: 'Origen',
                value: breed.origin,
                icon: Icons.public_rounded,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttributeTile(
                context,
                title: 'País',
                value: breed.country,
                icon: Icons.flag_outlined,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAttributeTile(
                context,
                title: 'Pelaje',
                value: breed.coat,
                icon: Icons.texture_rounded,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttributeTile(
                context,
                title: 'Patrón',
                value: breed.pattern,
                icon: Icons.grid_view_rounded,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttributeTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    final displayValue = value.trim().isNotEmpty ? value.trim() : 'No especificado';

    return Semantics(
      label: '$title: $displayValue',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              displayValue,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
