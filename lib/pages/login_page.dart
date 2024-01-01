import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lost_found_steelhacks/authentication/auth.dart';
import 'package:lost_found_steelhacks/authentication/loading_animation.dart';
import 'package:lost_found_steelhacks/authentication/user.dart';
import 'package:lost_found_steelhacks/pages/map_page.dart';
import 'package:lost_found_steelhacks/pages/signup_page.dart';
import 'package:lost_found_steelhacks/routing/route.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';
import 'package:provider/provider.dart';

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
        Text('Email', style: theme.veryDarkSubtitleStyle),
        SizedBox(height: 10.0),
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
                contentPadding: EdgeInsets.only(top: 14.0),
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
        Text('Password', style: theme.veryDarkSubtitleStyle),
        SizedBox(height: 10.0),
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
                contentPadding: EdgeInsets.only(top: 14.0),
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
        onPressed: () => routePage(SignUpPage(), context),
        child: Text('Forgot Password?', style: theme.veryDarkSubtitleStyle),
      ),
    );
  }

  Widget _buildLoginBtn(AppTheme theme, bool loading, AuthService authService) {
    return loading
        ? const Loading()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Container(
              decoration: theme.cardBodyDecoration,
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    try {
                      MyUser? result = await authService
                          .signInWithEmailAndPassword(_email, _password);

                      if (result == null) {
                        throw FirebaseAuthException(code: "Sign in failed");
                      }

                      setState(() {
                        loading = false;
                      });
                      routePage(MapPage(), context);
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _error =
                            'The email or password is incorrect. Please try again.';
                        loading = false;
                      });
                    }
                  }
                },
                child: Text('LOGIN', style: theme.veryDarkTitleStyle),
              ),
            ),
          );
  }

  Widget _buildSocialBtnRow(AppTheme theme, AuthService authService) {
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
                    routePage(MapPage(), context);
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
      onTap: () => routePage(SignUpPage(), context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Don\'t have an Account? ', style: theme.veryDarkRegularStyle.copyWith(color: theme.dark)),
            TextSpan(
                text: 'Sign Up',
                style:
                    theme.veryDarkRegularStyle.copyWith(fontWeight: FontWeight.bold, color: theme.dark)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMsg(AppTheme theme) => Text(_error,
      style: theme.veryDarkRegularStyle.copyWith(color: Colors.red),
      textAlign: TextAlign.center);

  Widget _buildSpacing() => const SizedBox(height: 30);

  Widget _buildTitle(AppTheme theme) =>
      Text('Sign In', style: theme.veryDarkTitleStyle.copyWith(fontSize: 40));

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final AppTheme theme = Theme.of(context).extension<AppTheme>()!;
    //const Widget spacing = SizedBox(height: 30);

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
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
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
                          _buildLoginBtn(theme, loading, authService),
                          _buildSocialBtnRow(theme, authService),
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
