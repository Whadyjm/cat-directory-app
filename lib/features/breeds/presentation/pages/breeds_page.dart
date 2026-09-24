import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/app_injector.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/breed_translator.dart';
import '../../../../core/localization/language_cubit.dart';
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

class _BreedsPageState extends State<BreedsPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  DateTime? _backgroundedAt;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final wasInBackgroundLong = _backgroundedAt != null &&
          DateTime.now().difference(_backgroundedAt!) >
              const Duration(minutes: 5);
      if (wasInBackgroundLong || AppInjector.breedsUsecase.isCacheStale()) {
        context.read<BreedsBloc>().add(const RefreshBreeds());
      }
      _backgroundedAt = null;
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= max * 0.92) {
      context.read<BreedsBloc>().add(const LoadMoreBreeds());
    }
    final shouldShow = current > 350;
    if (shouldShow != _showBackToTop) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
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
    final language = context.watch<LanguageCubit>().state;

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
              label: language.isSpanish ? 'Reintentar' : 'Retry',
              onPressed: () =>
                  context.read<BreedsBloc>().add(const LoadMoreBreeds()),
            ),
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            offset: _showBackToTop ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _showBackToTop ? 1.0 : 0.0,
              child: Semantics(
                button: true,
                label: language.isSpanish
                    ? 'Volver al inicio de la lista'
                    : 'Back to top of the list',
                child: FloatingActionButton.small(
                  onPressed: _showBackToTop ? _scrollToTop : null,
                  tooltip: language.isSpanish ? 'Volver al inicio' : 'Back to top',
                  elevation: 4,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: const Icon(Icons.keyboard_arrow_up_rounded, size: 24),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state, language),
                _buildSearchBar(context, state, language),
                Expanded(child: _buildBody(context, state, language)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    BreedsState state,
    AppLanguage language,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    final subtitle = state.isFromCache
        ? (language.isSpanish ? 'Mostrando datos en caché' : 'Showing cached data')
        : state.hasData
            ? (language.isSpanish
                ? '${state.allBreeds.length} razas encontradas'
                : '${state.allBreeds.length} breeds found')
            : (language.isSpanish
                ? 'Explorando razas de gatos'
                : 'Exploring cat breeds');

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
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: language.isSpanish
                ? 'Cambiar idioma a Inglés'
                : 'Switch language to Spanish',
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(
                Icons.translate_rounded,
                size: 16,
                color: colorScheme.primary,
              ),
              label: Text(
                language.code,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colorScheme.primary,
                ),
              ),
              onPressed: () => context.read<LanguageCubit>().toggleLanguage(),
            ),
          ),
          const SizedBox(width: 4),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final icon = switch (themeMode) {
                ThemeMode.light => Icons.light_mode_rounded,
                ThemeMode.dark => Icons.dark_mode_rounded,
                ThemeMode.system => Icons.brightness_auto_rounded,
              };
              final tooltip = switch (themeMode) {
                ThemeMode.light => language.isSpanish ? 'Modo Claro' : 'Light Mode',
                ThemeMode.dark => language.isSpanish ? 'Modo Oscuro' : 'Dark Mode',
                ThemeMode.system => language.isSpanish ? 'Modo Sistema' : 'System Mode',
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

  Widget _buildSearchBar(
    BuildContext context,
    BreedsState state,
    AppLanguage language,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Semantics(
        label: language.isSpanish ? 'Buscador de razas de gatos' : 'Cat breeds search',
        textField: true,
        child: TextField(
          controller: _searchController,
          onChanged: (q) =>
              context.read<BreedsBloc>().add(SearchBreeds(q)),
          decoration: InputDecoration(
            hintText: language.isSpanish ? 'Buscar raza...' : 'Search breed...',
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

  Widget _buildBody(
    BuildContext context,
    BreedsState state,
    AppLanguage language,
  ) {
    if (state.isLoadingInitial && !state.hasData) {
      return const BreedSkeletonList();
    }

    if (state.hasError) {
      return _buildErrorState(context, state, language);
    }

    if (state.hasData && state.filteredBreeds.isEmpty) {
      return _buildEmptySearch(context, language);
    }

    return _buildList(context, state, language);
  }

  Widget _buildList(
    BuildContext context,
    BreedsState state,
    AppLanguage language,
  ) {
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
              label: language.isSpanish ? 'Cargando más razas' : 'Loading more breeds',
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          final translated = BreedTranslator.translateBreed(breeds[index], language);
          return BreedListItem(
            breed: translated,
            onTap: () => _navigateToDetail(breeds[index]),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    BreedsState state,
    AppLanguage language,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: '${language.isSpanish ? "Error al cargar razas:" : "Error loading breeds:"} ${state.failure?.message}',
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
                state.failure?.message ??
                    (language.isSpanish ? 'Error desconocido' : 'Unknown error'),
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
                label: Text(language.isSpanish ? 'Reintentar' : 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearch(BuildContext context, AppLanguage language) {
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
            language.isSpanish
                ? 'Sin resultados para tu búsqueda'
                : 'No results found for your search',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
          ),
        ],
      ),
    );
  }
}
