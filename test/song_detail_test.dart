import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nymble_music_app/src/data/repositories/song_response.dart';
import 'package:nymble_music_app/src/presentation/providers/song_provider.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';
import 'package:nymble_music_app/src/presentation/views/song_detail/song_detail.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('SongDetail widget renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<SongProvider>(
            create: (context) => SongProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      child: MaterialApp(
        home: SongDetail(
          song: ChartItem(
            item: Item(title: "Starboy", artistNames: "The Weekend"),
          ),
          heroTagName: "TESTING_TAG",
        ),
      ),
    ));

    expect(find.text("Starboy"), findsOneWidget);

    expect(find.text("The Weekend"), findsOneWidget);

    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
}
