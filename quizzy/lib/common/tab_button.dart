import 'package:flutter/material.dart';
import 'package:quizzy/common/colo_extension.dart';

class TabButton extends StatelessWidget {
  final IconData icon;
  final IconData selectIcon;
  final VoidCallback onTap;
  final bool isActive;
  const TabButton(
      {super.key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(isActive ? selectIcon : icon,color: TColor.gray, size: 30,
           ),
         SizedBox(
          height: isActive ?  8: 12,
        ),
        if(isActive)
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: TColor.secondaryG,
              ),
              borderRadius: BorderRadius.circular(2)),
        )
      ]),
    );
  }
}
