import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  final bool readOnly;
  const SearchTextField(
      {Key key,
      this.readOnly = false,
      this.onTap,
      this.onChanged,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Autofocus will on if readOnly mode off
    return TextField(
      autofocus: !readOnly,
      readOnly: readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey[100].withOpacity(0.5),
        hintText: 'Search for news,topics...',
        hintStyle: TextStyle(fontSize: 14, color: Colors.blueGrey.shade400),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 0.00001, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        suffixIcon: Icon(Icons.search),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
      onSubmitted: onSubmitted,
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}
