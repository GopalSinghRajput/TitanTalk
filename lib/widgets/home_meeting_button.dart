import "package:flutter/material.dart";
import "package:titan_talk/utils/colors.dart";

class HomeMeetingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  const HomeMeetingButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 4),
                    )
                  ]),
              width: 130,
              height: 130,
              child: Icon(
                icon,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ))
          ],
        ));
  }
}
