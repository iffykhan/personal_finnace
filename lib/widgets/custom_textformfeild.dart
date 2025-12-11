import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  const CustomTextFormFeild(
      {super.key,
      required this.controller,
      required this.hint,
      required this.isPassword,
      required this.keyboardType,
      required this.validator,
      this.prefixIcon,
      this.suffixIcon});

  @override
  State<CustomTextFormFeild> createState() => _CustomTextFormFeildState();
}

class _CustomTextFormFeildState extends State<CustomTextFormFeild> {
  bool isObscure = false;
  @override
  void initState() {
    super.initState();
    if (widget.isPassword == true) {
      isObscure = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: isObscure,
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon:
                      Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                )
              : null,
          hintText: widget.hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
