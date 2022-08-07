import 'package:flutter/material.dart';

class OptionRadio extends StatefulWidget {
  final String text;
  final int index;
  final int selectedButton;
  final Function press;

  const OptionRadio({
    required this.text,
    required this.index,
    required this.selectedButton,
    required this.press,
  }) : super();

  @override
  OptionRadioPage createState() => OptionRadioPage();
}

class OptionRadioPage extends State<OptionRadio> {
  // QuestionController controllerCopy =QuestionController();

  int id = 1;
  late bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  int? _selected = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.press(widget.index);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                // height: 60.0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.grey,
                        disabledColor: Colors.blue),
                    child: Column(children: [
                      RadioListTile(
                        title: Text(
                          "${widget.index + 1}. ${widget.text}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          softWrap: true,
                        ),
                        /*Here the selectedButton which is null initially takes place of value after onChanged. Now, I need to clear the selected button when other button is clicked */
                        groupValue: widget.selectedButton,
                        value: widget.index,
                        activeColor: Colors.green,
                        onChanged: (val) async {
                          debugPrint('Radio button is clicked onChanged $val');
                          // setState(() {
                          //   debugPrint('Radio button setState $val');
                          //   selectedButton = val;
                          //   debugPrint('Radio button is clicked onChanged $widget.index');
                          // });
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // prefs.setInt('intValue', val);
                          widget.press(widget.index);
                        },
                        toggleable: true,
                      ),
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}