import 'package:flutter/material.dart';

class BigTextColonText extends StatelessWidget {
  final String? title;
  final String? value;
  final double? fSize;
  const BigTextColonText(
      {super.key, required this.title, required this.value, this.fSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  " :      ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: fSize),
                )
              ],
            )),
        Expanded(
            flex: 2,
            child: Text(value ?? "",
                style:
                    TextStyle(fontSize: fSize, fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class TextColonText extends StatelessWidget {
  final String? title;
  final String? value;
  final double? fSize;
  const TextColonText(
      {super.key, required this.title, required this.value, this.fSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  ":   ",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: fSize),
                )
              ],
            )),
        Expanded(
          flex: 3,
          child: Text(
            value ?? "",
            style: TextStyle(fontSize: fSize, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class FlexTextColonText extends StatelessWidget {
  final String? title;
  final int? value;
  final double? fSize;
  const FlexTextColonText(
      {super.key, required this.title, required this.value, this.fSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black),
                ),
                const Text(
                  ":   ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                )
              ],
            )),
        Expanded(
          flex: 1,
          child: Text(
            "$value",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
