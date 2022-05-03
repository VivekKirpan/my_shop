import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({
    Key key,
    @required this.context,
    this.message = "Something went wrong",
  }) : super(key: key);

  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'An Error Occurred!',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(message),
      actions: [
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
