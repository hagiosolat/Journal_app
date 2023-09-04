import 'package:flutter/material.dart';
import 'package:journal_app4/blocs/login_bloc.dart';
import 'package:journal_app4/services/authentication.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc? _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Icon(Icons.account_circle, size: 88.0, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: _loginBloc?.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      icon: const Icon(Icons.mail_outline),
                      errorText: snapshot.error as String?),
                  onChanged: _loginBloc!.emailChanged.add,
                ),
              ),
              StreamBuilder(
                stream: _loginBloc!.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      icon: const Icon(Icons.security),
                      errorText: snapshot.error as String?),
                  onChanged: _loginBloc!.passwordChanged.add,
                ),
              ),
              const SizedBox(height: 48.0),
              _buildLoginAndCreateButton()!,
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLoginAndCreateButton() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc!.loginOrCreateButton,
      builder: (context, snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }
         return build(context);
      },
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc!.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 16.0,
                backgroundColor: Colors.lightGreen.shade200,
                disabledBackgroundColor: Colors.grey.shade100),
            onPressed: snapshot.data
                ? () => _loginBloc!.loginOrCreateChanged.add('Login')
                : null,
                child: const Text('Login'),
          ),
        ),
        TextButton(
            onPressed: () {
              _loginBloc!.loginOrCreateButtonChanged.add('Create Account');
            },
            child: const Text('Create Account'),
            )
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: false,
          stream: _loginBloc!.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 16.0,
                backgroundColor: Colors.lightGreen.shade200,
                disabledBackgroundColor: Colors.grey.shade100),
                        onPressed: snapshot.data
                ? () => _loginBloc!.loginOrCreateChanged.add('Create Account')
                : null,
              child: const Text('Create Account'),
          ),
        ),
        TextButton(
          
            onPressed: () {
              _loginBloc!.loginOrCreateButtonChanged.add('Login');
            },
              child: const Text('Login'),
            )
      ],
    );
  }
}
