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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner principal de bienvenida
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1000&auto=format&fit=crop',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 28),
                            SizedBox(width: 8),
                            Text(
                              '¡Hello World, CineStar!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Bienvenida al Catálogo. Explora los mejores estrenos, películas de la temporada y colecciones exclusivas.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Título de sección Colecciones
              const Text(
                'Colecciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Géneros con efecto hover
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGenreChip('Acción'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Ciencia Ficción'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Drama'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Romance'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Misterio'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Terror psicológico'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Anime'),
                    const SizedBox(width: 8),
                    _buildGenreChip('Adaptaciones de videojuegos'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Título de estrenos
              const Text(
                'Los estrenos más esperados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Carrusel horizontal con 3 películas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMovieCard(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBIaOSbDyhf60nhd2ew8vjYuSezT6NSx4N3JpsfshTKg&s',
                      'Cyberpunk: Edgerunners',
                    ),
                    const SizedBox(width: 15),
                    _buildMovieCard(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRES8HLxUn-2FhEn3rEFDtMGRLmcjBqiyJG34F_P6JVmXbnrM2l-TaeG3Jg&s=10',
                      'Ingress: The animation',
                    ),
                    const SizedBox(width: 15),
                    _buildMovieCard(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYG1zsejPENCpfwMX-vqreC6cuRZ5wX3LC8H_s4tTF5Q&s=10',
                      'Pantheon',
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

  // Widget auxiliar para los géneros
  Widget _buildGenreChip(String label) {
    return _GenreChipItem(label: label);
  }

  // Widget para las tarjetas de películas
  Widget _buildMovieCard(String imageUrl, String title) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            imageUrl,
            width: 280,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: 280,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, const Color.fromRGBO(0, 0, 0, 0.8)],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// Widget Stateful independiente para el efecto hover de los géneros
class _GenreChipItem extends StatefulWidget {
  final String label;
  const _GenreChipItem({required this.label});

  @override
  State<_GenreChipItem> createState() => _GenreChipItemState();
}

class _GenreChipItemState extends State<_GenreChipItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isHovered ? Colors.deepPurple.shade700 : Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered ? Colors.deepPurple.shade900 : Colors.deepPurple.shade200,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: isHovered ? Colors.white : Colors.deepPurple.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}