import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lost_found_steelhacks/services/auth_service.dart';
import 'package:lost_found_steelhacks/widgets/loading_animation.dart';
import 'package:lost_found_steelhacks/themes/app_theme.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  const SignUpPage({super.key, required this.toggleView});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool loading = false;

  String firstName = '';
  String lastName = '';
  String _error = '';
  String _password = '';
  String _email = '';

  Widget _buildFirstNameTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('First Name', style: theme.veryDarkSubtitleStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => firstName = value,
            controller: _firstNameController,
            validator: (val) => val == null || val.isEmpty
                ? 'First name cannot be empty.'
                : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.person, color: theme.dark),
                hintText: 'Enter your first name',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameTF(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: theme.veryDarkSubtitleStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: theme.textFieldDecoration,
          height: 60.0,
          child: TextFormField(
            onChanged: (value) => lastName = value,
            controller: _lastNameController,
            validator: (val) => val == null || val.isEmpty
                ? 'Last name cannot be empty.'
                : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.person, color: theme.dark),
                hintText: 'Enter your first name',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

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
            onChanged: (value) => _password = value,
            controller: _passwordController,
            validator: (val) =>
                val == null || val.isEmpty ? 'Enter valid password' : null,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(Icons.lock, color: theme.dark),
                hintText: 'Enter your Password',
                hintStyle: theme.hintStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn(AppTheme theme, bool loading) {
    return loading
        ? const LoadingAnimation()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Container(
              decoration: theme.cardBodyDecoration,
              child: OutlinedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    bool success =
                        await AuthService.registerWithEmailAndPassword(
                            firstName, lastName, _email, _password);
                    if (success) {
                      setState(() {
                        _error =
                            'Failed to register with your email and password. Please try again.';
                        loading = false;
                      });
                    } else {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                child: Text('SIGN UP', style: theme.veryDarkTitleStyle),
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
                Future result = AuthService.signInWithGoogle();
                result.then((value) {
                  if (value == null) {
                    setState(() {
                      _error = "Google sign in failed. Please try again.";
                    });
                  }
                  //no need to route, wrapper should pick up and log in
                });
              },
              // global colors
              icon: Icon(Ionicons.logo_google, size: 40, color: theme.dark))
        ],
      ),
    );
  }

  Widget _buildSignInBtn(AppTheme theme) {
    return GestureDetector(
      onTap: () => widget.toggleView(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Already have an Account? ',
                style: theme.veryDarkRegularStyle.copyWith(color: theme.dark)),
            TextSpan(
                text: 'Sign In',
                style: theme.veryDarkRegularStyle
                    .copyWith(fontWeight: FontWeight.bold, color: theme.dark)),
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
      Text('Sign Up', style: theme.veryDarkTitleStyle.copyWith(fontSize: 40));

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
                  decoration: theme.gradientBackgroundDecoration),
              SizedBox(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTitle(theme),
                        _buildSpacing(),
                        _buildFirstNameTF(theme),
                        _buildSpacing(),
                        _buildLastNameTF(theme),
                        _buildSpacing(),
                        _buildEmailTF(theme),
                        _buildSpacing(),
                        _buildPasswordTF(theme),
                        _buildSignUpBtn(theme, loading),
                        _buildSocialBtnRow(theme),
                        _buildSignInBtn(theme),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
