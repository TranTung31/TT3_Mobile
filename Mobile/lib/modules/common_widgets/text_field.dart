import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Color baseColor;
  final Color borderColor;
  final Color errorColor;
  final TextInputType inputType;
  final bool obscureText;
  final Function? validator;
  final Function? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final bool isDateField;
  final bool isReadOnly;
  final String? prefixText;

  CustomTextField({
    this.hint = "",
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.baseColor = Colors.black,
    this.borderColor = Colors.transparent,
    this.errorColor = Colors.red,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.icon,
    this.isDateField = false,
    this.isReadOnly = false,
    this.textInputAction,
    this.prefixText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final double radius = 10;

  var currentColor = ColorUtils.mainColor.obs;

  @override
  Widget build(BuildContext context) {
    currentColor.value =
        (widget.validator == null || widget.validator!(widget.controller.text))
            ? widget.borderColor
            : widget.errorColor;
    RxBool _isShowPassword = false.obs;
    return Stack(
      children: [
        Obx(
          () => Card(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            elevation: 0.0,
            color: widget.isReadOnly
                ? ColorUtils.gray.withOpacity(0.4)
                : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: currentColor.value, width: 1.0),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                right: widget.prefixText != null ? 60 : 10.0,
                left: widget.icon != null ? 60 : 10,
              ),
              child: Stack(
                children: [
                  Obx(
                    () => TextField(
                      obscureText: !_isShowPassword.value && widget.obscureText,
                      enableSuggestions: !widget.obscureText,
                      autocorrect: !widget.obscureText,
                      style: Theme.of(context).textTheme.bodyMedium,
                      inputFormatters: [LengthLimitingTextInputFormatter(255)],
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (text) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(text);
                        }
                        if (widget.isDateField) {
                          DateFormat df = new DateFormat("dd/MM/yyyy");
                          // var regex = RegExp(
                          //   r'/(((0|1)[0-9]|2[0-9]|3[0-1])\/(0[1-9]|1[0-2])\/((19|20)\d\d))$/',
                          // );
                          try {
                            if (text.length > 0) {
                              var date = df.parse(text);
                              if (date.year < 2000 || date.year > 2100)
                                throw new Exception();
                            }
                            currentColor.value = widget.borderColor;
                          } catch (e) {
                            currentColor.value = widget.errorColor;
                          }
                          // if (regex.hasMatch(text) || text.length == 0) {
                          //   currentColor.value = borderColor;
                          // } else {
                          //   currentColor.value = errorColor;
                          // }
                        }
                        if (widget.validator != null) if (!widget
                                .validator!(text) ||
                            text.length == 0) {
                          currentColor.value = widget.errorColor;
                        } else {
                          currentColor.value = widget.borderColor;
                        }
                      },
                      readOnly: widget.isDateField || widget.isReadOnly,
                      onTap: widget.isDateField && !widget.isReadOnly
                          ? () {
                              _selectDate(context);
                            }
                          : () {},
                      textInputAction: widget.textInputAction,
                      onSubmitted: (value) {
                        if (widget.onSubmitted != null)
                          widget.onSubmitted!(value);
                      },
                      keyboardType: widget.isDateField
                          ? TextInputType.datetime
                          : widget.inputType,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                        fillColor: Colors.black,
                        border: InputBorder.none,
                        hintText: widget.hint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        widget.obscureText
            ? Obx(
                () => Positioned(
                  right: 10,
                  top: 22,
                  child: InkWell(
                    child: Icon(
                      _isShowPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: ColorUtils.mainColor,
                    ),
                    onTap: () => _isShowPassword.value = !_isShowPassword.value,
                  ),
                ),
              )
            : SizedBox(),
        widget.isDateField
            ? Positioned(
                right: 10,
                top: 22,
                child: InkWell(
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: ColorUtils.mainColor,
                  ),
                  onTap: () => _selectDate(context),
                ),
              )
            : SizedBox(),
        widget.icon != null
            ? Positioned(
                left: 0,
                top: 10,
                child: Container(
                  height: 48,
                  width: 50,
                  child: Icon(widget.icon, color: Colors.white),
                  decoration: BoxDecoration(
                    color: ColorUtils.gray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        widget.prefixText != null && widget.icon == null
            ? Obx(
                () => Positioned(
                  right: 0,
                  top: 10,
                  child: Container(
                    height: 48,
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      widget.prefixText!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: currentColor.value,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(radius),
                        bottomRight: Radius.circular(radius),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Future _selectDate(context) async {
    DateTime? currentDate;
    try {
      currentDate = DateFormat("dd/MM/yyyy").parse(widget.controller.text);
      if (currentDate.year < 2000 || currentDate.year > 2100) {
        currentDate = null;
        throw new Exception();
      }
    } catch (e) {}
    // DatePicker.showDatePicker(context,
    //
    //     showTitleActions: false,
    //     minTime: DateTime(2000, 1, 1),
    //     maxTime: DateTime(2030, 12, 31), onChanged: (date) {
    //   DateFormat df = new DateFormat("dd/MM/yyyy");
    //   controller.text = df.format(date);
    // }, onConfirm: (date) {
    //   DateFormat df = new DateFormat("dd/MM/yyyy");
    //   controller.text = df.format(date);
    // }, currentTime: currentDate ?? new DateTime.now(), locale: LocaleType.vi);
    DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: currentDate ?? new DateTime.now(),
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2030),
      locale: Locale('vi', 'vi_Vn'),
    );

    if (picked != null) {
      DateFormat df = new DateFormat("dd/MM/yyyy");
      widget.controller.text = df.format(picked);
      setState(() {});
    }
  }
}
