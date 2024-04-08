import 'package:flutter/material.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppButton extends StatefulWidget {
  final String name;
  final double? minWidth;
  final double? height;
  final Future Function() onPressed;
  final TextStyle? nameTextStyle;
  final Color? progressColor;
  final bool? isLoading;
  const AppButton(
      {required this.name,
      required this.onPressed,
      this.minWidth,
      this.height,
      this.nameTextStyle,
      this.progressColor,
      this.isLoading,
      super.key});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeState, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: themeState.isDark
                        ? [
                            const Color.fromARGB(255, 100, 100, 100),
                            const Color.fromARGB(255, 80, 80, 80),
                            const Color.fromARGB(255, 63, 63, 63),
                          ]
                        : [
                            const Color(0xFF0059DD),
                            const Color(0xFF0059DD).withOpacity(0.8),
                            const Color(0xFF0059DD).withOpacity(0.8),
                            const Color(0xFF0059DD).withOpacity(0.8),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: MaterialButton(
                  elevation: 4,
                  onPressed: widget.onPressed,
                  minWidth: widget.minWidth,
                  height: widget.height ?? 55,
                  child: (widget.isLoading ?? false)
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: widget.progressColor ?? Colors.white,
                          ),
                        )
                      : Text(
                          widget.name,
                          style: widget.nameTextStyle ??
                              Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
