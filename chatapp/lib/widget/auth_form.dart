import 'dart:io';

import 'package:chat_app_flutter/picker/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  Function _submitForm;
  bool _isLoading;

  AuthForm(this._submitForm, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var userEmail = "";
  var userName = "";
  File image;
  var userPass = "";
  var _userImage;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select image"),
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget._submitForm(
          userEmail.trim(), userPass, userName, _userImage, _isLogin, context);
    }
  }

  void _pickedImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey("email"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return "Please enter valid email.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value.toString();
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey("username"),
                    decoration: InputDecoration(labelText: "User name"),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return "Please enter valid user name.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userName = value.toString();
                    },
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return "Min length of password 6 symbols.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPass = value.toString();
                  },
                ),
                SizedBox(height: 12),
                widget._isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        child: Text(_isLogin ? "Login" : "Sign Up"),
                        onPressed: _trySubmit,
                      ),
                TextButton(
                  child: Text(
                    _isLogin ? "Create new account" : "Sign in instead",
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
