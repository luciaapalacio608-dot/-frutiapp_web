import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _futureProductos;

  // Lista de nombres en español para reemplazar el texto en latín del endpoint.
  static const List<String> _nombresFrutas = [
    'Manzana', 'Banano', 'Piña', 'Fresa', 'Sandía',
    'Mango', 'Naranja', 'Uva', 'Pera', 'Melón',
    'Kiwi', 'Papaya', 'Durazno', 'Limón', 'Guanábana',
  ];

  @override
  void initState() {
    super.initState();
    _futureProductos = cargarProductos();
  }

  Future<List<dynamic>> cargarProductos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final datos = jsonDecode(response.body) as List<dynamic>;
      return datos.take(15).toList();
    }

    throw Exception('No se pudo cargar la información');
  }

  void _recargar() {
    setState(() {
      _futureProductos = cargarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        backgroundColor: const Color(0xFFB8E0C8),
        foregroundColor: const Color(0xFF3D6B52),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _recargar),
        ],
      ),
      backgroundColor: const Color(0xFFFDF6F0),
      body: FutureBuilder<List<dynamic>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  const Text('No se pudo cargar la información.'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _recargar, child: const Text('Reintentar')),
                ],
              ),
            );
          }

          final productos = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final item = productos[index];
              final id = item['id'] as int;
              // Nombre en español según la posición, usando módulo para no salirnos de la lista.
              final nombre = _nombresFrutas[index % _nombresFrutas.length];
              final precio = id * 100;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.local_grocery_store, color: Color(0xFF3D6B52)),
                  title: Text(nombre),
                  subtitle: Text('Precio: $precio colones'),
                  trailing: Text('#$id'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}