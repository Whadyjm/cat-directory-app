import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/cat_fact_cubit.dart';
import '../cubit/cat_fact_state.dart';

class CatFactCard extends StatelessWidget {
  const CatFactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dato Curioso Aleatorio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
              BlocBuilder<CatFactCubit, CatFactState>(
                builder: (context, state) {
                  final isLoading = state is CatFactLoading;
                  return IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            color: colorScheme.primary,
                          ),
                    tooltip: 'Cargar otro dato',
                    onPressed: isLoading
                        ? null
                        : () => context.read<CatFactCubit>().fetchRandomFact(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<CatFactCubit, CatFactState>(
            builder: (context, state) {
              return switch (state) {
                CatFactInitial() || CatFactLoading() => _buildLoadingState(context),
                CatFactLoaded(:final fact) => _buildLoadedState(context, fact.fact),
                CatFactError(:final message) => _buildErrorState(context, message),
              };
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    return Semantics(
      label: 'Cargando dato curioso...',
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 14,
              width: 160,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, String fact) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Dato curioso: $fact',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: colorScheme.primary.withValues(alpha: 0.35),
            size: 28,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fact,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.85),
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Error al cargar dato curioso: $message',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => context.read<CatFactCubit>().fetchRandomFact(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
