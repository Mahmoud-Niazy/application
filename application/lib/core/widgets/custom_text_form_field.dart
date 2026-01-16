import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_styles.dart';
import 'custom_icon_button.dart';

//ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  final String title;
  bool isPassword;
  final bool isSuffixIconShown;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final IconData? pIcon;
  int? maxLine;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onPressOnPrefixIcon;
  final Color? pIconColor;
  final bool? isEnabled;

  CustomTextFormField({
    super.key,
    required this.title,
    this.isPassword = false,
    this.isSuffixIconShown = false,
    this.keyboardType,
    required this.controller,
    this.pIcon,
    this.maxLine = 1,
    this.onFieldSubmitted,
    this.onPressOnPrefixIcon,
    this.pIconColor,
    this.isEnabled = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      style: TextStyle(fontSize: 13),
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.maxLine,
      controller: widget.controller,
      validator: (String? value){
        if (value!.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      keyboardType: widget.keyboardType,
      inputFormatters: widget.keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
        prefixIcon: widget.pIcon != null
            ? InkWell(
                onTap: widget.onPressOnPrefixIcon,
                child: Icon(
                  widget.pIcon,
                  color: widget.pIconColor ?? Colors.grey,
                ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors.blue.withAlpha(20),
        filled: true,
        border: InputBorder.none,
        hintText: widget.title,
        hintStyle: AppStyles.style15Grey,
        suffixIcon: widget.isSuffixIconShown == true
            ? CustomIconButton(
                onPressed: () {
                  setState(() {
                    widget.isPassword = !widget.isPassword;
                  });
                },
                icon: widget.isPassword
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined,
              )
            : null,
      ),
      obscureText: widget.isPassword,
    );
  }
}
