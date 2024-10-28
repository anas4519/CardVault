import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.teal,
    ),
  );
}

void showLoadingDialog(BuildContext context, String content) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                    color: Colors.teal, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    },
  );
}
