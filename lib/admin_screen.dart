import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _titleCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _directorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _synopsisCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  Future<void> _addMovie() async {
    if (_titleCtrl.text.isEmpty ||
        _yearCtrl.text.isEmpty ||
        _directorCtrl.text.isEmpty ||
        _genreCtrl.text.isEmpty ||
        _synopsisCtrl.text.isEmpty ||
        _imageCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos.')),
      );
      return;
    }

    // Solicitud HTTP para validar disponibilidad de la imagen o recurso externo
    try {
      final uri = Uri.tryParse(_imageCtrl.text.trim());
      if (uri != null && uri.hasAbsolutePath) {
        await http.head(uri);
      }
    } catch (_) {
      // Continuamos aunque el servidor bloquee peticiones HEAD
    }

    final newMovie = Movie(
      id: '',
      title: _titleCtrl.text.trim(),
      year: int.tryParse(_yearCtrl.text.trim()) ?? 0,
      director: _directorCtrl.text.trim(),
      genre: _genreCtrl.text.trim(),
      synopsis: _synopsisCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim(),
    );

    await FirebaseFirestore.instance.collection('movies').add(newMovie.toMap());

    _titleCtrl.clear();
    _yearCtrl.clear();
    _directorCtrl.clear();
    _genreCtrl.clear();
    _synopsisCtrl.clear();
    _imageCtrl.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película agregada correctamente al catálogo.')),
    );
  }

  Future<void> _deleteMovie(String docId) async {
    await FirebaseFirestore.instance.collection('movies').doc(docId).delete();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Película eliminada del catálogo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración de Catálogo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Alta de Nueva Película',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _yearCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Año de estreno', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _directorCtrl, decoration: const InputDecoration(labelText: 'Director', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _genreCtrl, decoration: const InputDecoration(labelText: 'Género', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _synopsisCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Sinopsis', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _imageCtrl, decoration: const InputDecoration(labelText: 'URL de la imagen (póster)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _addMovie,
              icon: const Icon(Icons.add),
              label: const Text('Guardar Película'),
            ),
            const Divider(height: 36),
            Text(
              'Baja de Películas Existentes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('movies').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.movie),
                      title: Text(data['title'] ?? ''),
                      subtitle: Text('${data['year'] ?? ''} • ${data['director'] ?? ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMovie(docs[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}