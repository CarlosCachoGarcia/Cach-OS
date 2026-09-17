import 'package:flutter/material.dart';

import '../../core/dependencies.dart';
import '../../widgets/common.dart';

class SessionScreen extends StatefulWidget {
  final Dependencies deps;
  const SessionScreen(this.deps, {super.key});
  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void initState() {
    super.initState();
    restore();
  }

  Future<void> restore() async {
    final ok = await widget.deps.auth.restore();
    if (!mounted || !ok) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.deps.session.active ? '/catalog' : '/login',
      (_) => false,
    );
  }

  Future<void> forget() async {
    final ok = await widget.deps.auth.logout();
    if (!mounted || !ok) return;
    widget.deps.cart.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: widget.deps.auth,
        builder: (_, child) => Scaffold(
          body: widget.deps.auth.busy || widget.deps.auth.error == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: ErrorPanel(widget.deps.auth.error!, restore)),
                    TextButton(
                      onPressed: forget,
                      child: const Text('Borrar sesión guardada e ir al login'),
                    ),
                  ],
                ),
        ),
      );
}
