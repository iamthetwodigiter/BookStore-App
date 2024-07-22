import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;

  const CustomButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
            color: CupertinoColors.white, shape: BoxShape.circle),
        child:  Icon(
          icon,
          color: CupertinoColors.systemBrown,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
