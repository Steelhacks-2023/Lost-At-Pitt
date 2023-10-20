import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:lost_found_steelhacks/pages/signup_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  String _error = '';
  bool _hidePassword = true;
  bool loading = false;

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => setState(() {
              _email = value;
            }),
            controller: _emailController,
            validator: (val) => val == null ||
                    val.isEmpty ||
                    !RegExp(r"^[A-Za-z0-9._%+-]+@pitt\.edu$").hasMatch(val)
                ? 'Please enter valid email.'
                : null,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => setState(() {
              _password = value.trim();
            }),
            controller: _passwordController,
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter valid password' : null,
            obscureText: _hidePassword,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    color: Colors.white,
                    _hidePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () async {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => SignUpPage()))),
        //style: TextButton.styleFrom(padding: EdgeInsets.fromLTRB(left, top, right, bottom)
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn(authService) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: OutlinedButton(
        //elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            try {
              MyUser? result = await authService.signInWithEmailAndPassword(_email, _password);

              if (result == null) {
                throw FirebaseAuthException(code: "Sign in failed");
              }

              setState(() {
                loading = false;
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: ((context) => MapPage())));
            } on FirebaseAuthException catch (e) {
              setState(() {
                _error =
                    'The email or password is incorrect. Please try again.';
                loading = false;
              });
            }
          }
        },
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtnRow(authService) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              onPressed: () async {
                Future result = authService.signInWithGoogle();
                result.then((value) {
                  if (value == null) {
                    setState(() {
                      _error = "Google sign in failed. Please try again.";
                    });
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: ((context) => MapPage())));
                  }
                });
              },
              icon: Icon(
                Ionicons.logo_google,
                size: 40,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => SignUpPage()))),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMsg() {
    return Text(_error,
        style: TextStyle(fontSize: 13.0, color: Colors.red),
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE0D2C7),
                      Color.fromARGB(255, 68, 176, 158)
                    ],
                    stops: [0.1, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          _buildEmailTF(),
                          SizedBox(
                            height: 30.0,
                          ),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
                          _buildErrorMsg(),
                          loading ? Loading() : _buildLoginBtn(authService),
                          _buildSignInWithText(),
                          _buildSocialBtnRow(authService),
                          _buildSignupBtn(),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
