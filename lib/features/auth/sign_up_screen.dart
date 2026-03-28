// lib/features/auth/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../core/widgets/planora_input.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/tokens.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String _scholarYear = kScholarYearOptions.first;
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthState> auth = ref.watch(authProvider);

    return GradientScaffold(
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 70),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 34,
                    color: Colors.white,
                  ),
                  children: const <InlineSpan>[
                    TextSpan(text: 'Create your '),
                    TextSpan(
                      text: 'PLANORA',
                      style: TextStyle(color: kLavender),
                    ),
                    TextSpan(text: ' account'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PlanoraTextField(
                hint: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              PlanoraTextField(
                hint: 'Full name',
                controller: _nameController,
                validator: (String? value) =>
                    validateRequired(value, label: 'Full name'),
              ),
              const SizedBox(height: 16),
              PlanoraDropdown<String>(
                hint: 'Scholar year',
                value: _scholarYear,
                items: kScholarYearOptions
                    .map(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() => _scholarYear = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              PlanoraTextField(
                hint: 'Password',
                controller: _passwordController,
                obscure: _obscure,
                validator: validatePassword,
              ),
              const SizedBox(height: 16),
              PlanoraTextField(
                hint: 'Confirm password',
                controller: _confirmController,
                obscure: _obscure,
                validator: (String? value) => validatePasswordConfirmation(
                  value,
                  _passwordController.text,
                ),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Sign up',
                trailingIcon: Icons.arrow_forward_rounded,
                loading: auth.isLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await ref
                        .read(authProvider.notifier)
                        .signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          fullName: _nameController.text.trim(),
                          scholarYear: _scholarYear,
                        );
                  }
                },
              ),
              const SizedBox(height: 16),
              GoogleButton(
                label: 'Sign up with Google',
                onPressed: () => ref.read(authProvider.notifier).signInGoogle(),
              ),
              const SizedBox(height: 26),
              TextButton(
                onPressed: () => context.go('/sign-in'),
                child: const Text('Already have an account ? Sign in now !'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
