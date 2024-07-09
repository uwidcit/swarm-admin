import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:swarnet_admin_client/screens/dashboard/view.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    final node = FocusScope.of(context);
    String username = "";
    String password = "";

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            context.go("/dashboard");
          }
          if (state is LoginFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Invalid credentials, please try again")));
          }
        },
        builder: (context, state) {
          if (state is LoginLoadedState) {
            return Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/swarnet_full_logo.png",
                              width: MediaQuery.of(context).size.width / 8,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Email address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  final emailRegExp = RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                  if (value!.isEmpty ||
                                      !emailRegExp.hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  username = value;
                                  return null;
                                },
                                onEditingComplete: () => node.nextFocus()),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  password = value;
                                  return null;
                                },
                                onEditingComplete: () => node.nextFocus()),
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  bloc.add(LoginScreenFormSubmitEvent(
                                      username, password));
                                }
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: const Text(
                                  "Log In",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
