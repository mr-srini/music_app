import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/views/search_song.dart';
import '../../presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      name: Home.name,
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      name: Login.name,
      path: '/${Login.name}',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      name: SongDetail.name,
      path: '/${SongDetail.name}:tagName',
      builder: (context, state) {
        final song = state.extra as ChartItem;
        final String heroTagName = state.pathParameters["tagName"] ?? "";
        return SongDetail(
          song: song,
          heroTagName: heroTagName,
        );
      },
    ),
    GoRoute(
      name: SearchSong.name,
      path: '/searchSong',
      builder: (context, state) => const SearchSong(),
    ),
  ],
  redirect: (context, GoRouterState state) async {
    final bool isloggedIn = FirebaseAuth.instance.currentUser != null;
    final bool atLoginPage = state.matchedLocation == "/${Login.name}";
    if (!isloggedIn) return "/${Login.name}";
    if (atLoginPage) return "/";
    return null;
  },
);
