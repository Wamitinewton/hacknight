import 'package:flutter/material.dart';

class AuthMethods extends StatelessWidget {
 final VoidCallback onTap;
  final String text;
  final String authlogo;
  const AuthMethods({super.key, required this.onTap, required this.text, required this.authlogo, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(41, 0, 0, 0),
                offset: Offset(0, 1),
                blurRadius: 0,
              )
            ],
            border: Border.all(color: Colors.green)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/$authlogo.png'),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
