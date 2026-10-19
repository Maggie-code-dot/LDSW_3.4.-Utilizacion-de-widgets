import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LDSW Widgets Básicos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatalogoPeliculasScreen(),
    );
  }
}

class CatalogoPeliculasScreen extends StatelessWidget {
  const CatalogoPeliculasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.movie_creation_outlined, color: Colors.purple),
            SizedBox(width: 8),
            Text(
              'CineStar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // 1. WIDGET COLUMN: Organiza los elementos verticalmente
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. WIDGET CONTAINER: Banner principal de bienvenida
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bienvenida al Catálogo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Explora los mejores estrenos y películas de la temporada',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. WIDGET TEXT: Título de sección
              const Text(
                'Colecciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 4. WIDGET ROW: Elementos alineados horizontalmente
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGenreChip('Acción'),
                  _buildGenreChip('Ciencia Ficción'),
                  _buildGenreChip('Drama'),
                  _buildGenreChip('Romance'),
                  _buildGenreChip('Misterio'),
                  _buildGenreChip('Terror psicológico'),
                  _buildGenreChip('Anime'),
                  _buildGenreChip('Adaptaciones de videojuegos'),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'El Estreno más esperado',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 5. WIDGET STACK: Superposición de elementos (imagen y etiqueta flotante)
              Center(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: 320,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade800,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Icon(Icons.movie, size: 60, color: Colors.white54),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ingress: The animation',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para las etiquetas de género
  Widget _buildGenreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.deepPurple.shade800, fontWeight: FontWeight.w500),
      ),
    );
  }
}