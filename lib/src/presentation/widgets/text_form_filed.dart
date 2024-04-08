import 'package:flutter/material.dart';
import 'package:nymble_music_app/src/config/themes/app_themes.dart';

class AppTextFormField extends StatefulWidget {
  final IconData? suffixIcon;
  final IconData? perfixIcon;
  final Color? suffixIconColor;
  final Color? perfixIconColor;
  final Function()? onSuffixIconTap;
  final Function()? onEdittingComplete;
  final Function(String)? onChange;
  final bool? obscureText;
  final String name;
  final TextStyle? hintStyle;
  final bool? autofocus;
  final TextEditingController controller;

  const AppTextFormField({
    required this.controller,
    required this.name,
    this.onEdittingComplete,
    this.onChange,
    this.autofocus,
    this.suffixIcon,
    this.obscureText,
    this.perfixIcon,
    this.onSuffixIconTap,
    this.hintStyle,
    this.perfixIconColor,
    this.suffixIconColor,
    super.key,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: widget.onChange,
        autofocus: widget.autofocus ?? false,
        controller: widget.controller,
        style: Theme.of(context).textTheme.displayMedium,
        cursorColor: AppTheme.appPrimaryColor,
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.perfixIcon,
            size: 28,
            color: widget.perfixIconColor ?? Theme.of(context).dividerColor,
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onSuffixIconTap,
            child: Icon(
              widget.suffixIcon,
              size: 28,
              color: widget.suffixIconColor ?? Theme.of(context).dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.8,
            ),
          ),
          isDense: true,
          hintText: widget.name,
          hintStyle: widget.hintStyle ??
              Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).dividerColor,
                  ),
        ),
      ),
    );
  }
}
