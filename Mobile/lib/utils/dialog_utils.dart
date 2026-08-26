import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'color_utils.dart';

class DialogUtils {
  ///Show alert
  static void alert(BuildContext context, String message) {
    alertWithCallback(context, message, null);
  }

  static void alertWithCallback(
      BuildContext context, String message, Function? callback,
      {TextSpan? messageWidget}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
//                    color: Theme.of(context).backgroundColor,
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(13.0),
                    )),
                width: 50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: messageWidget != null
                          ? RichText(
                              text: messageWidget,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              message,
                              style: TextStyle(
                                  height: 1.1,
                                  fontSize: 13.0,
                                  color: Color.fromRGBO(138, 138, 138, 1)),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Theme.of(context).disabledColor,
                                width: 0.5)),
                      ),
                      height: 47,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (callback != null) {
                            callback();
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(21, 126, 251, 1)),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  static void confirmWithCallback(BuildContext context, String message,
      Function callback, String cancelText, String acceptText, String label,
      {Function? cancelCallback}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
//                    color: Theme.of(context).backgroundColor,
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(13.0),
                    )),
                width: 50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        message,
                        style: TextStyle(
                            height: 1.1,
                            fontSize: 13.0,
                            color: Color.fromRGBO(138, 138, 138, 1)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                  width: 0.5)),
                        ),
                        height: 47,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Center(
                                    child: TextButton(
                                  child: Center(
                                    child: Text(acceptText,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                21, 126, 251, 1))),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);

                                    callback();
                                  },
                                )),
                              ),
                              Container(
                                color: Theme.of(context).disabledColor,
                                width: 0.5,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextButton(
                                  child: Center(
                                    child: Text(
                                      cancelText,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(21, 126, 251, 1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (cancelCallback == null)
                                      Navigator.pop(context);
                                    else
                                      cancelCallback();
                                  },
                                ),
                              ),
                            ]))
                  ],
                ),
              ));
        });
  }

  static void enterPasscodeDialog(
      BuildContext context,
      String passcode,
      String message,
      Function callback,
      String cancelText,
      String acceptText,
      String label,
      Function cancelCallback) {
    var controller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              backgroundColor: Colors.transparent,
              content: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: new BorderRadius.all(
                      Radius.circular(13.0),
                    )),
                width: 50.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        message,
                        style: TextStyle(
                            height: 1.1,
                            fontSize: 13.0,
                            color: Color.fromRGBO(138, 138, 138, 1)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Passcode',
                            alignLabelWithHint: true,
                            suffix: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.clear();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          validator: (val) {
                            var result = val != passcode
                                ? 'Wrong passcode, please try again.'
                                : null;
                            return result;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                  width: 0.5)),
                        ),
                        height: 47,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Center(
                                    child: TextButton(
                                  child: Center(
                                    child: Text(acceptText,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromRGBO(
                                                21, 126, 251, 1))),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    callback();
                                  },
                                )),
                              ),
                              Container(
                                color: Theme.of(context).disabledColor,
                                width: 0.5,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextButton(
                                  child: Center(
                                    child: Text(
                                      cancelText,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(21, 126, 251, 1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    cancelCallback();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ]))
                  ],
                ),
              ));
        });
  }

  //Show indicator
  static void indicator(BuildContext context, String message) {
    var simDialog = new SimpleDialog(
      title: new Text(message),
      children: <Widget>[
        new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
          ColorUtils.mainColor,
        ))
      ],
      contentPadding: const EdgeInsets.all(8.0),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return simDialog;
        });
  }

  static Widget basicIndicator(bool show) {
    return show
        ? new Container(
            width: 70.0,
            height: 70.0,
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: SpinKitFadingFour(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: ColorUtils.mainColor,
                      ),
                    );
                  },
                ),
              ),
            ))
        : new Container();
  }

  static void showSnackBar(BuildContext context, String message) {
    SnackBar snackBar = new SnackBar(content: new Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
