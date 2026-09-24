import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/breed_translator.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../breeds/presentation/widgets/breed_list_item.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: language.isSpanish ? 'Volver' : 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          language.isSpanish ? 'Razas Favoritas' : 'Favorite Breeds',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.favoriteBreeds.isEmpty) {
            return _buildEmptyState(context, language, colorScheme);
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: state.favoriteBreeds.length,
            itemBuilder: (context, index) {
              final rawBreed = state.favoriteBreeds[index];
              final translated = BreedTranslator.translateBreed(rawBreed, language);
              return BreedListItem(
                breed: translated,
                onTap: () {
                  final encoded = Uri.encodeComponent(rawBreed.breed);
                  context.push('/breed/$encoded', extra: rawBreed);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLanguage language,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              language.isSpanish ? 'Sin razas favoritas' : 'No favorite breeds',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              language.isSpanish
                  ? 'Explora el catálogo y presiona el corazón en cualquier raza para guardarla aquí.'
                  : 'Explore the catalog and tap the heart icon on any breed to save it here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
              icon: const Icon(Icons.pets, size: 18),
              label: Text(
                language.isSpanish ? 'Explorar catálogo' : 'Explore catalog',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
