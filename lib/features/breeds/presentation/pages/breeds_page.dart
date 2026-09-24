import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../domain/entities/breed.dart';
import '../bloc/breeds_bloc.dart';
import '../bloc/breeds_event.dart';
import '../bloc/breeds_state.dart';
import '../widgets/breed_list_item.dart';
import '../widgets/breed_skeleton_item.dart';

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= max * 0.92) {
      context.read<BreedsBloc>().add(const LoadMoreBreeds());
    }
  }

  Future<void> _onRefresh() async {
    context.read<BreedsBloc>().add(const RefreshBreeds());
    _searchController.clear();
    await context.read<BreedsBloc>().stream.firstWhere(
          (s) => !s.isRefreshing,
        );
  }

  void _navigateToDetail(Breed breed) {
    context.go(
      AppRouter.breedDetail.replaceFirst(':name', Uri.encodeComponent(breed.breed)),
      extra: breed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BreedsBloc, BreedsState>(
      listenWhen: (prev, curr) =>
          curr.hasPaginationError && prev.failure != curr.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.failure!.message),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Reintentar',
              onPressed: () =>
                  context.read<BreedsBloc>().add(const LoadMoreBreeds()),
            ),
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                _buildSearchBar(context, state),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, BreedsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cat Directory',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                ),
                Text(
                  state.isFromCache
                      ? 'Mostrando datos en caché'
                      : state.hasData
                          ? '${state.allBreeds.length} razas encontradas'
                          : 'Explorando razas de gatos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                ),
              ],
            ),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final icon = switch (themeMode) {
                ThemeMode.light => Icons.light_mode_rounded,
                ThemeMode.dark => Icons.dark_mode_rounded,
                ThemeMode.system => Icons.brightness_auto_rounded,
              };
              final tooltip = switch (themeMode) {
                ThemeMode.light => 'Modo Claro (tocar para cambiar)',
                ThemeMode.dark => 'Modo Oscuro (tocar para cambiar)',
                ThemeMode.system => 'Modo Sistema (tocar para cambiar)',
              };
              return Semantics(
                button: true,
                label: tooltip,
                child: IconButton(
                  icon: Icon(icon, color: colorScheme.primary),
                  tooltip: tooltip,
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, BreedsState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Semantics(
        label: 'Buscador de razas de gatos',
        textField: true,
        child: TextField(
          controller: _searchController,
          onChanged: (q) =>
              context.read<BreedsBloc>().add(SearchBreeds(q)),
          decoration: InputDecoration(
            hintText: 'Buscar raza...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: state.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      context.read<BreedsBloc>().add(const SearchBreeds(''));
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BreedsState state) {
    if (state.isLoadingInitial && !state.hasData) {
      return const BreedSkeletonList();
    }

    if (state.hasError) {
      return _buildErrorState(context, state);
    }

    if (state.hasData && state.filteredBreeds.isEmpty) {
      return _buildEmptySearch(context);
    }

    return _buildList(context, state);
  }

  Widget _buildList(BuildContext context, BreedsState state) {
    final breeds = state.filteredBreeds;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: breeds.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= breeds.length) {
            return Semantics(
              label: 'Cargando más razas',
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          return BreedListItem(
            breed: breeds[index],
            onTap: () => _navigateToDetail(breeds[index]),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, BreedsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Error al cargar razas: ${state.failure?.message}',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 72,
                color: colorScheme.onSurface.withValues(alpha: 0.25),
              ),
              const SizedBox(height: 20),
              Text(
                state.failure?.message ?? 'Error desconocido',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    context.read<BreedsBloc>().add(const LoadBreeds()),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearch(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados para tu búsqueda',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
          ),
        ],
      ),
    );
  }
}
