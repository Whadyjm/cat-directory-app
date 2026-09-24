import 'package:go_router/go_router.dart';

import '../../features/breeds/presentation/pages/breeds_page.dart';
import '../../features/breeds/presentation/pages/breed_detail_page.dart';

abstract final class AppRouter {
  static const String home = '/';
  static const String breedDetail = '/breed/:name';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const BreedsPage(),
      ),
      GoRoute(
        path: breedDetail,
        builder: (context, state) {
          final name = state.pathParameters['name'] ?? '';
          final extra = state.extra;
          return BreedDetailPage(breedName: name, extra: extra);
        },
      ),
    ],
  );
}
