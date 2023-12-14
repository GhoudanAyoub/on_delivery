import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/utils/constants.dart';

import 'custom_card.dart';

class TextFormBuilder extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final FocusNode? focusNode, nextFocusNode;
  final VoidCallback submitAction;
  final FormFieldValidator<String?> validateFunction;
  final void Function(String?)? onSaved, onChange;
  final Key? key;
  final IconData? prefix;
  bool suffix = false;
  final bool readOnly;

  TextFormBuilder(
      {this.prefix,
      required this.suffix,
      this.initialValue,
      this.enabled,
      this.hintText,
      this.textInputType,
      this.controller,
      this.textInputAction,
      this.nextFocusNode,
      this.focusNode,
      required this.submitAction,
      this.obscureText = false,
      required this.validateFunction,
      this.onSaved,
      this.onChange,
      this.key,
      this.readOnly = false});

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  String? error;
  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              child: Theme(
                data: ThemeData(
                  primaryColor: Theme.of(context).accentColor,
                  accentColor: Theme.of(context).accentColor,
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: widget.initialValue,
                  enabled: widget.enabled,
                  onChanged: (val) {
                    error = widget.validateFunction(val);
                    setState(() {});
                    if(widget.onSaved!=null) widget.onSaved!(val);
                  },
                  readOnly: widget.readOnly,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                  key: widget.key,
                  controller: widget.controller,
                  obscureText: widget.suffix
                      ? _secureText
                          ? true
                          : false
                      : false,
                  keyboardType: widget.textInputType,
                  validator: widget.validateFunction,
                  onSaved: (val) {
                    error = widget.validateFunction(val);
                    setState(() {});
                    if(widget.onSaved!=null)  widget.onSaved!(val);
                  },
                  textInputAction: widget.textInputAction,
                  focusNode: widget.focusNode,
                  onFieldSubmitted: (String? term) {
                    if (widget.nextFocusNode != null) {
                      widget.focusNode?.unfocus();
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    } else {
                      widget.submitAction();
                    }
                  },
                  decoration: InputDecoration(
                      labelText: widget.hintText,
                      prefixIcon: Icon(
                        widget.prefix,
                        size: 15.0,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: widget.suffix == true
                          ? IconButton(
                              icon: Icon(
                                _secureText
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                                size: 20,
                                color: Color.fromRGBO(110, 113, 145, 1),
                              ),
                              onPressed: () {
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      fillColor: Color.fromRGBO(239, 240, 246, 1),
                      filled: true,
                      /*hintText: widget.hintText,*/
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(110, 113, 130, 1),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      border: border(context),
                      enabledBorder: border(context),
                      hoverColor: GBottomNav,
                      focusedBorder: focusBorder(context),
                      errorStyle: TextStyle(height: 0.0, fontSize: 0.0)),
                ),
              ),
            ),
            onTap: (){},
          ),
          SizedBox(height: 5.0),
          Visibility(
            visible: error != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '$error',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0.0,
      ),
    );
  }

  focusBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Color.fromRGBO(110, 113, 145, 1),
        width: 1.0,
      ),
    );
  }
}
