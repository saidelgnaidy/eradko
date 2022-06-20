import 'package:eradko/const.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key, required this.hintText, required this.onChanged, required this.obscureText, this.warning, this.textEditingController
  }) : super(key: key);
  final String hintText;
  final Function(String) onChanged;
  final bool obscureText ;
  final bool? warning;
  final TextEditingController? textEditingController;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool? isPassword  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric( vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor.withOpacity(.6)  , width: 1.5 ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged:  widget.onChanged,
        obscureText: isPassword ?? widget.obscureText,
        controller: widget.textEditingController,
        cursorColor: textColor,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: textColor.withOpacity(.6),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: widget.obscureText ? SizedBox(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.visibility ,color:accentColor,size: 16),
              onPressed: (){
                setState(() {
                  if(isPassword == null){
                    isPassword = false ;
                  }else if(isPassword!){
                    isPassword = false;
                  }else{
                    isPassword = true;
                  }
                });
              },
            ),
          ):null,
          suffix: widget.warning == true ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.error ,color: Colors.redAccent,size: 16,),
          ) : const SizedBox(),
        ),
      ),
    );
  }
}

