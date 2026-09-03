import 'package:flutter/material.dart';
import '../models/access_record.dart';
import '../services/access_log_service.dart';
import 'bitacora_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _recordarme = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validarCorreo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese el correo';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Correo no válido';
    }
    return null;
  }

  String? _validarContrasena(String? value) {
    if (value == null || value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _ingresar() {
    final exitoso = _formKey.currentState!.validate();

    logService.add(
      AccessRecord(
        usuario: _emailController.text.trim(),
        fechaHora: DateTime.now(),
        exitoso: exitoso,
      ),
    );

    if (exitoso) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _verBitacora() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BitacoraScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        title: const Text('FrutiApp'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFB8E0C8),
        foregroundColor: const Color(0xFF3D6B52),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver bitácora',
            onPressed: _verBitacora,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8D5D0), width: 1),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB8E0C8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco, color: Color(0xFF3D6B52), size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FrutiApp',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D6B52),
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: _validarCorreo,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: _validarContrasena,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Checkbox(
                        value: _recordarme,
                        onChanged: (v) => setState(() => _recordarme = v ?? false),
                        activeColor: const Color(0xFFF2AFC0),
                      ),
                      const Text('Recordarme', style: TextStyle(color: Color(0xFF6B6B6B))),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2AFC0),
                        foregroundColor: const Color(0xFF7A3B4E),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _ingresar,
                      child: const Text('Ingresar', style: TextStyle(fontWeight: FontWeight.w600)),
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