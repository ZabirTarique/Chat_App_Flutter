import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.hint,
    this.obscure = false,
    this.icon = const Icon(Icons.person),
    required this.onChanged,
    this.customController,
  });

  final String hint;
  final bool obscure;
  final Icon icon;
  final Function(String) onChanged;
  final TextEditingController? customController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        controller: customController,
        style: const TextStyle(color: Colors.black),
        obscureText: obscure,
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
