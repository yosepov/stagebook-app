import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagebook/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form keys
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  TextEditingController _nameController,
      _emailController,
      _companyController,
      _passwordController = TextEditingController();
  String _companyId, _name, _email, _password;
  int _selectedIndex = 0;

  _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          _buildNameTF(),
          _buildCompanyTF(),
          _buildEmailTF(),
          _buildPasswordTF(),
        ],
      ),
    );
  }

  _buildNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _nameController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow),
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Full Name',
        ),
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter your Full Name' : null,
        onSaved: (input) => _name = input.trim(),
      ),
    );
  }

  _buildCompanyTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _companyController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow),
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Company Token',
        ),
        validator: (input) => input != 'xDuo8f8nFuWixUgidYcqleUxvCF2' ||
                input != '5ntPAjgTiigidS85eXl5z9oY9Wc2'
            ? 'Please enter Company ID'
            : null,
        onSaved: (input) => _companyId = input.trim(),
      ),
    );
  }

  _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _emailController,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow),
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Email',
        ),
        validator: (input) =>
            !input.contains('@') ? 'please enter a valid email' : null,
        onSaved: (input) => _email = input,
      ),
    );
  }

  _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        autofocus: false,
        controller: _passwordController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          labelText: 'Password',
        ),
        validator: (input) =>
            input.length < 7 ? 'Must be at least 8 characters' : null,
        onSaved: (input) => _password = input,
        obscureText: true,
      ),
    );
  }

  _submit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (_selectedIndex == 0 && _loginFormKey.currentState.validate()) {
        //triggers onsaved
        _loginFormKey.currentState.save();
        //logic for login
        await authService.login(_email, _password);
      } else if (_selectedIndex == 1 &&
          _signupFormKey.currentState.validate()) {
        _signupFormKey.currentState.save();
        await authService.signup(_name, _companyId, _email, _password);
      }
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    } catch (err) {
      _showErrorDialog(err.message);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.redAccent[200],
                Colors.redAccent[400],
                Colors.redAccent[400],
                Colors.red
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // GFAvatar(
                    //     radius: 50,
                    //     shape: GFAvatarShape.standard,
                    //     backgroundColor: Colors.grey,
                    //     backgroundImage:
                    //         AssetImage('assets/images/stage_icon.png')),
                    Text(
                      _selectedIndex == 0 ? 'STAGEBOOK' : 'SIGNUP',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          child: FlatButton(
                            color: _selectedIndex == 0
                                ? Colors.redAccent
                                : Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.redAccent,
                              ),
                            ),
                            onPressed: () => setState(() => _selectedIndex = 0),
                          ),
                        ),
                        Container(
                          width: 150.0,
                          child: FlatButton(
                            color: _selectedIndex == 1
                                ? Colors.redAccent
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.redAccent,
                              ),
                            ),
                            onPressed: () => setState(() => _selectedIndex = 1),
                          ),
                        ),
                      ],
                    ),
                    _selectedIndex == 0
                        ? _buildLoginForm()
                        : _buildSignupForm(),
                    const SizedBox(height: 20.0),
                    Container(
                      width: 180.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          _selectedIndex == 0 ? 'LOGIN' : 'SIGNUP',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 30.0,
                          ),
                        ),
                        onPressed: _submit,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Terms of service & privacy agreement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
