import 'package:flutter/material.dart';
import 'package:yamete_winx/components/appbar/widget/dropdown_buttom/dropdown_button_widget.dart';
import 'package:yamete_winx/core/AppColors.dart';
import 'package:yamete_winx/core/AppGradients.dart';
import 'package:yamete_winx/core/AppTextStyles.dart';
import 'package:yamete_winx/data/hdata.dart';
import 'package:yamete_winx/mobx/main_model.dart';
import 'package:yamete_winx/screens/home_screen/widgets/textfield_search_widget.dart';
import 'package:provider/provider.dart';

class MenuBarWidget extends StatefulWidget {
  MenuBarWidget({Key key}) : super(key: key);

  @override
  _MenuBarWidgetState createState() => _MenuBarWidgetState();
}

class _MenuBarWidgetState extends State<MenuBarWidget> {
  String _dropDownValueCategory;
  String _dropDownValueTarget;
  String _lastCategory;
  String _lastTarget;
  MainModel mainModel;

  @override
  void initState() { 
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mainModel = Provider.of<MainModel>(context);    
  }

  /* gatilho para mudar drop down e ainda chamar os hentais da categoria */
  _handlerSetDropDownCategory(String value){
    setState(() {
      _lastCategory = value;
      _dropDownValueCategory = value;
    });
  }

  _handlerSetDropDownTarget(String value){
    Function _handlerFunction = mainModel.handlerDropDown[value];
    _handlerFunction();
    mainModel.setCurrentApi(value);
    setState(() {
      _lastTarget = value;
      _dropDownValueTarget = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 600,
      decoration: BoxDecoration(
        color: AppColors.menuButtonColor,
        // borderRadius: BorderRadius.circular(10),
        gradient: AppGradients.linear03
      ),
      padding: const EdgeInsets.symmetric(horizontal: 60,),
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [                    
          DropDownButtonWidget(
            handlerSetDropDown: _handlerSetDropDownCategory,
            newValue: _dropDownValueCategory,
            label: "Category",
            data: HData.categorys,
            icons: Icons.list_alt,
          ),
          SizedBox(width: 20,),
          DropDownButtonWidget(
            handlerSetDropDown: _handlerSetDropDownTarget,
            newValue: _dropDownValueTarget,
            label: "Target",
            data: HData.targets,
            icons: Icons.link,
          ),
          SizedBox(width: 20,),
          TextFieldSearchWidget()
        ],
      ),
    );
  }
}