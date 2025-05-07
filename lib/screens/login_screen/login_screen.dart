import 'package:oo/components/custom_buttons.dart';
import 'package:oo/constants.dart';
import 'package:oo/screens/home_screen/teacher_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../admin/Admin Dashboard.dart';
import '../../student/student_home_screen.dart';
import '../password/Forgot Password.dart';
import '../Signup_Screen/Signup_Screen.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool islogin = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  Future<void> _login() async {
    // if (islogin) return;
    islogin = true;
    setState(() {});
    if (!_formKey.currentState!.validate()) return;

    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = response.user;

      if (user == null) {
        _showError('Connection failed. Please try again.');
        return;
      }

      // Vérifie le profil dans la table `profiles`
      final profileResponse =
          await supabase
              .from('profiles')
              .select('user_type')
              .eq('id', user.id)
              .maybeSingle();

      if (profileResponse == null || profileResponse['user_type'] == null) {
        _showError('Profile not found. Please contact support.');
        return;
      }

      String userType = profileResponse['user_type'];

      if (!mounted) return;
      switch (userType) {
        case 'Student':
          // Navigator.pushReplacementNamed(context, 'StudentProfile');
          Navigator.pushReplacementNamed(context, StudentHomeScreen.routeName);
          break;
        case 'Teacher':
          Navigator.pushReplacementNamed(context, TeacherHomeScreen.routeName);
          break;
        case 'Parent':
          Navigator.pushReplacementNamed(context, 'ParentProfile');
          break;
        case 'Admin':
          Navigator.pushReplacementNamed(context, AdminDashboard.routeName);
          break;
        default:
          _showError('Unknown user type.');
      }
    } catch (error) {
      islogin = false;
      setState(() {});
      _showError('Erreur : ${error.toString()}');
    } finally {
      islogin = false;
      setState(() {});
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      _showError('Google Error: ${e.toString()}');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await supabase.auth.signInWithOAuth(OAuthProvider.facebook);
    } catch (e) {
      _showError('Facebook Error : ${e.toString()}');
    }
  }

  Future<void> signInWithApple() async {
    try {
      await supabase.auth.signInWithOAuth(OAuthProvider.apple);
    } catch (e) {
      _showError('Apple Error : ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: 100.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi Student',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Image.asset(
                    'assets/images/splash.png',
                    height: 40.h,
                    width: 60.w,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        buildEmailField(),
                        SizedBox(height: 20),
                        buildPasswordField(),
                        SizedBox(height: 30),
                        islogin
                            ? CircularProgressIndicator(color: Colors.blue)
                            : DefaultButton(
                              onPress: () => _login(),
                              title: islogin ? 'Loading...' : 'SIGN IN',
                              iconData: Icons.arrow_forward_outlined,
                            ),

                        SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                              onPressed: () => signInWithGoogle(),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                              ),
                              onPressed: () => signInWithFacebook(),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.apple,
                                color: Colors.black,
                              ),
                              onPressed: () => signInWithApple(),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Create an Account ?",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordVisible,
      keyboardType: TextInputType.visiblePassword,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'The password must contain at least 5 characters';
        }
        return null;
      },
    );
  }
}
