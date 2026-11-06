import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/core/l10n_x.dart';
import 'package:visioncompanion/features/auth/cubit/auth_cubit.dart';
import 'package:visioncompanion/features/auth/cubit/auth_state.dart';
import 'package:visioncompanion/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _registering = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthCubit>();
    if (_registering) {
      auth.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } else {
      auth.signIn(_emailController.text, _passwordController.text);
    }
  }

  void _toggleMode() {
    setState(() => _registering = !_registering);
    _formKey.currentState?.reset();
  }

  String _messageFor(AppLocalizations l10n, AuthIssue issue) {
    switch (issue) {
      case AuthIssue.invalidCredentials:
        return l10n.authInvalidCredentials;
      case AuthIssue.invalidEmail:
        return l10n.authInvalidEmail;
      case AuthIssue.emailInUse:
        return l10n.authEmailInUse;
      case AuthIssue.weakPassword:
        return l10n.authWeakPassword;
      case AuthIssue.network:
        return l10n.authNetwork;
      case AuthIssue.tooManyAttempts:
        return l10n.authTooMany;
      case AuthIssue.unknown:
        return l10n.authUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(_messageFor(context.l10n, state.issue))),
              );
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                _Hero(registering: _registering),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_registering) ...[
                          _Field(
                            controller: _nameController,
                            label: l10n.nameLabel,
                            icon: Icons.person_outline_rounded,
                            enabled: !loading,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? l10n.errNameRequired
                                    : null,
                          ),
                          const SizedBox(height: 16),
                        ],
                        _Field(
                          controller: _emailController,
                          label: l10n.emailLabel,
                          icon: Icons.mail_outline_rounded,
                          enabled: !loading,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            final valid =
                                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
                            return valid ? null : l10n.errEmailInvalid;
                          },
                        ),
                        const SizedBox(height: 16),
                        _Field(
                          controller: _passwordController,
                          label: l10n.passwordLabel,
                          icon: Icons.lock_outline_rounded,
                          enabled: !loading,
                          obscure: _hidePassword,
                          validator: (value) => (value ?? '').length < 6
                              ? l10n.errPasswordShort
                              : null,
                          suffix: IconButton(
                            tooltip: _hidePassword
                                ? l10n.showPassword
                                : l10n.hidePassword,
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? Semantics(
                                  liveRegion: true,
                                  label: l10n.signingIn,
                                  child: const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                              : Text(
                                  _registering
                                      ? l10n.registerButton
                                      : l10n.signInButton,
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                l10n.orDivider,
                                style: TextStyle(color: scheme.outline),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: loading
                              ? null
                              : () =>
                                  context.read<AuthCubit>().signInWithGoogle(),
                          icon: const Icon(Icons.g_mobiledata_rounded, size: 34),
                          label: Text(l10n.continueWithGoogle),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: loading ? null : _toggleMode,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                          ),
                          child: Text(
                            _registering
                                ? l10n.switchToLogin
                                : l10n.switchToRegister,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.registering});

  final bool registering;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(28, top + 36, 28, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.tertiary, 0.7)!,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(46),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.visibility_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.appName,
            style: TextStyle(
              color: Colors.white.withAlpha(210),
              fontSize: 15,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            registering ? l10n.registerTitle : l10n.loginTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            registering ? l10n.registerSubtitle : l10n.loginSubtitle,
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.validator,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withAlpha(90),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
    );
  }
}
