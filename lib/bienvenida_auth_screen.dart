import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'catalogo_screen.dart';

class WelcomeAuthScreen extends StatefulWidget {
  const WelcomeAuthScreen({super.key});

  @override
  State<WelcomeAuthScreen> createState() => _WelcomeAuthScreenState();
}

class _WelcomeAuthScreenState extends State<WelcomeAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAuth() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un correo válido y una contraseña de al menos 6 caracteres.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CatalogScreen()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException -> code: ${e.code}, message: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error [${e.code}]: ${e.message ?? 'Error de autenticación'}'),
        ),
      );
    } catch (e) {
      debugPrint('Error inesperado en auth: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE4DFFB), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B87F5).withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge pastel con degradado morado, azul y verde menta
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9B87F5),
                          Color(0xFF7EC8E3),
                          Color(0xFF8CE0C3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5F5E9), // Verde menta pastel
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CineStar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF246A54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bienvenid@ a CineStar',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D264B),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isLogin
                        ? 'Inicia sesión para explorar las películas'
                        : 'Crea tu cuenta nueva para comenzar',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5C5470),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF7E6CE0)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF276782)),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _submitAuth,
                            child: Text(
                              _isLogin ? 'Ingresar' : 'Registrarse',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF5A49B8),
                    ),
                    child: Text(
                      _isLogin
                          ? '¿No tienes cuenta? Regístrate aquí'
                          : '¿Ya tienes cuenta? Inicia sesión',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}