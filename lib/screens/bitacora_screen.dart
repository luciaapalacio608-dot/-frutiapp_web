import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;
import '../services/access_log_service.dart';

class BitacoraScreen extends StatefulWidget {
  const BitacoraScreen({super.key});

  @override
  State<BitacoraScreen> createState() => _BitacoraScreenState();
}

class _BitacoraScreenState extends State<BitacoraScreen> {
  void _descargarJson(String contenido) {
  final base64 = base64Encode(utf8.encode(contenido));
  final anchor = web.HTMLAnchorElement()
    ..href = 'data:application/json;base64,$base64'
    ..setAttribute('download', 'bitacora_accesos.json')
    ..style.display = 'none';

  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
}
  void _exportarBitacora() {
    _descargarJson(logService.exportJson());
  }

  Future<void> _importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    try {
      final contenido = await file.readAsString();
      logService.importJson(contenido);
      setState(() {});
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON inválido: ${e.message}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo leer el archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = logService.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de accesos'),
        backgroundColor: const Color(0xFFB8E0C8),
        foregroundColor: const Color(0xFF3D6B52),
      ),
      backgroundColor: const Color(0xFFFDF6F0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _exportarBitacora,
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar JSON'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _importarBitacora,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Importar JSON'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? const Center(child: Text('Aún no hay intentos registrados.'))
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final r = records[index];
                      return ListTile(
                        leading: Icon(
                          r.exitoso ? Icons.check_circle : Icons.cancel,
                          color: r.exitoso ? Colors.green : Colors.red,
                        ),
                        title: Text(r.usuario.isEmpty ? '(sin usuario)' : r.usuario),
                        subtitle: Text(r.fechaHora.toString()),
                        trailing: Text(r.exitoso ? 'OK' : 'FALLÓ'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}