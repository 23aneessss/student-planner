// lib/features/auth/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../core/widgets/planora_input.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/tokens.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthState> auth = ref.watch(authProvider);

    ref.listen<AsyncValue<AuthState>>(authProvider, (
      _,
      AsyncValue<AuthState> next,
    ) {
      next.whenOrNull(
        error: (Object error, StackTrace stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return GradientScaffold(
      resizeToAvoidBottomInset: true,
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
        CloudPosition.bottomRight,
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 110),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  children: const <InlineSpan>[
                    TextSpan(text: 'Sign in to '),
                    TextSpan(
                      text: 'PLANORA',
                      style: TextStyle(color: kLavender),
                    ),
                    TextSpan(text: ' !'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PlanoraTextField(
                hint: 'Email or username',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              PlanoraTextField(
                hint: 'Password',
                controller: _passwordController,
                obscure: _obscure,
                validator: validatePassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset requires a connected backend.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Forget password ?'),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Login',
                trailingIcon: Icons.arrow_forward_rounded,
                loading: auth.isLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await ref
                        .read(authProvider.notifier)
                        .signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GoogleButton(
                label: 'Sign in with Google',
                onPressed: () => ref.read(authProvider.notifier).signInGoogle(),
              ),
              const SizedBox(height: 26),
              TextButton(
                onPressed: () => context.go('/sign-up'),
                child: const Text(
                  'Don\'t have an account ? Create yours now !',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
