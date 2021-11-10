import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.optionSelected == widget.description
              ? widget.optionSelected == widget.correctOption
                  ? Colors.greenAccent
                  : Colors.redAccent
              : Colors.grey,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(13),
        
    ),
    child: Text(
        widget.description,
        style: TextStyle(color: Colors.white),
      ),

    );
  }
}