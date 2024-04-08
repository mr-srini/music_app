import 'package:flutter_test/flutter_test.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';

void main() {
  test('Test theme mode toggling', () {
    // Create an instance of the ThemeProvider
    final themeProvider = ThemeProvider();

    // Initial theme mode should be light
    expect(themeProvider.isDark, false);

    // Toggle the theme mode
    themeProvider.changeAppThemeMode();

    // After toggling, theme mode should be dark
    expect(themeProvider.isDark, true);

    // Toggle again
    themeProvider.changeAppThemeMode();

    // After toggling again, theme mode should be light again
    expect(themeProvider.isDark, false);
  });
}
