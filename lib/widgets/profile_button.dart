import 'package:flutter/material.dart';

import '../consts/colors.dart';

class ProfileButton extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback? press;
  final bool? isSwitch;

   ProfileButton({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.press,
    this.isSwitch=false,
  });


  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}


class _ProfileButtonState extends State<ProfileButton> {
  var switchValue=false;
  changeSwitchValue(value){
  setState(() {
  switchValue=value;
    });  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: widget.press,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(widget.icon, color: Colors.white),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: widget.isSwitch==false
            ? Icon(Icons.arrow_forward_ios, size: 16, color: fontGrey)
            :Switch(
          activeColor:appColor,
          value: switchValue, onChanged:(value) {
              changeSwitchValue(value);
        },
    )

    ),
    );
  }
}
