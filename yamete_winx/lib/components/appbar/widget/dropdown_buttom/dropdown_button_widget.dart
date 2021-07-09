import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
class DropDownButtonWidget extends StatefulWidget {
  final Function handlerSetDropDown;
  final String newValue;
  final String label;
  final List<String> data;
  final IconData icons;
  DropDownButtonWidget({
    Key key,
    this.handlerSetDropDown,
    this.newValue,
    this.label,
    this.data,
    this.icons
  }) : super(key: key);
  @override
  _DropDownButtonWidgetState createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  String newValue;
  @override
  void initState() {    
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(      
      style: AppTextStyles.dropdownHint,
      dropdownColor: AppColors.dropdownColor,
      icon: Icon(widget.icons, color: AppColors.iconColor,),
      hint: Text(widget.label, style: TextStyle(color: Colors.white),),
      value: widget.newValue,
      items: widget.data.map((e) => DropdownMenuItem<String>(
        value: removerAcentos(e),
        child: Text(e),
      )).toList(),
      onChanged: (String value){
        widget.handlerSetDropDown(value);
      },
    );
  }

  String removerAcentos(String texto)
  {
      String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
      String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";
      for (int i = 0; i < comAcentos.length; i++)
      {
          texto = texto.replaceFirst(comAcentos[i].toString(), semAcentos[i].toString());
      }
      return texto;
  }

}