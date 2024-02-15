import 'package:flutter/material.dart';
import 'package:message/constants/constants.dart';

class MyTextFieldForm extends StatelessWidget {

  final bool edit;
  final String value;
  final String name;
  final Function onChanged;
  final Function validator;
  final IconData iconData;
  final TextInputType textInputType;

  const MyTextFieldForm({Key? key, required this.name, required this.onChanged, required this.validator, required this.iconData, required this.textInputType, required this.edit, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      style: style,
      initialValue: edit ? value : null,
      decoration: InputDecoration(
        hintText: name,
        suffixIcon: Icon(iconData),
        hintStyle: style,
        suffixIconColor: Colors.grey,
        enabledBorder : UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
            ),
        ),
      ),
      keyboardType: textInputType,
      onChanged: onChanged(),
      validator: validator(),
    );
  }
}
