// ignore_for_file: use_build_context_synchronously
// ignore_for_file: slash_for_doc_comments

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lost_found_steelhacks/services/auth.dart';
import 'package:lost_found_steelhacks/widgets/loading_animation.dart';
import 'package:lost_found_steelhacks/models/app_user.dart';
import 'package:lost_found_steelhacks/pages/signup_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

/**
 * Login page for the application
 */
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  String _error = '';
  bool _hidePassword = true;
  bool loading = false;

  Widget _buildEmailTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email', style: theme.subtitleStyle),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
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
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.email, color: theme.dark),
                hintText: 'Enter your Email',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password', style: theme.subtitleStyle),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => setState(() {
              _password = value.trim();
            }),
            controller: _passwordController,
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter valid password' : null,
            obscureText: _hidePassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.lock, color: theme.dark),
                suffixIcon: IconButton(
                  icon: Icon(
                      color: theme.dark,
                      _hidePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () async {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
                hintText: 'Enter your Password',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn(AppTheme theme) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => routePage(const SignUpPage(), context),
        child: Text('Forgot Password?', style: theme.subtitleStyle),
      ),
    );
  }

  Widget _buildLoginBtn(AppTheme theme, bool loading) {
    return loading
        ? const Loading()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Container(
              decoration: theme.cardBodyDecoration,
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    try {
                      AppUser? result = await AuthService.instance.signInWithEmailAndPassword(_email, _password);

                      if (result == null) {
                        throw FirebaseAuthException(code: "Sign in failed");
                      }

                      setState(() => loading = false);
                      routeHome(0, context);
                    } on FirebaseAuthException {
                      setState(() {
                        _error =
                            'The email or password is incorrect. Please try again.';
                        loading = false;
                      });
                    }
                  }
                },
                child: Text('LOGIN', style: theme.titleStyle),
              ),
            ),
          );
  }

  Widget _buildSocialBtnRow(AppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              onPressed: () async {
                Future result = await AuthService.instance.signInWithGoogle();
                result.then((value) {
                  if (value == null) {
                    setState(() {
                      _error = "Google sign in failed. Please try again.";
                    });
                  } else {
                    routeHome(0, context);
                  }
                });
              },
              // global colors
              icon: Icon(Ionicons.logo_google, size: 40, color: theme.dark))
        ],
      ),
    );
  }

  Widget _buildSignupBtn(AppTheme theme) {
    return GestureDetector(
      onTap: () => routePage(const SignUpPage(), context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Don\'t have an Account? ',
                style: theme.regularStyle.copyWith(color: theme.dark)),
            TextSpan(
                text: 'Sign Up',
                style: theme.regularStyle
                    .copyWith(fontWeight: FontWeight.bold, color: theme.dark)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMsg(AppTheme theme) => Text(_error,
      style: theme.regularStyle.copyWith(color: Colors.red),
      textAlign: TextAlign.center);

  Widget _buildSpacing() => const SizedBox(height: 30);

  Widget _buildTitle(AppTheme theme) =>
      Text('Sign In', style: theme.titleStyle.copyWith(fontSize: 40));

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;

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

                  // move to theme
                  decoration: theme.gradientBackgroundDecoration),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildTitle(theme),
                          _buildSpacing(),
                          _buildEmailTF(theme),
                          _buildSpacing(),
                          _buildPasswordTF(theme),
                          _buildForgotPasswordBtn(theme),
                          _buildErrorMsg(theme),
                          _buildLoginBtn(theme, loading),
                          _buildSocialBtnRow(theme),
                          _buildSignupBtn(theme),
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
