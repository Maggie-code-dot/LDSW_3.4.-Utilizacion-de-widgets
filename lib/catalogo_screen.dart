import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_model.dart';
import 'movie_detail_screen.dart';
import 'admin_screen.dart';
import 'bienvenida_auth_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGenre = 'Todas';

  final List<String> _collections = const [
    'Todas',
    'Terror psicológico',
    'Ciencia Ficción',
    'Acción',
    'Comedia',
    'Romance',
    'Drama',
    'Suspenso',
    'Anime',
  ];

  // Alterna tonos pastel entre morado, azul y verde menta
  Color _pastelChipColor(int index, bool isSelected) {
    const colors = [
      Color(0xFFE5DEFF), // Morado pastel
      Color(0xFFD6F0FA), // Azul pastel
      Color(0xFFD5F5E9), // Verde menta pastel
    ];
    const selectedColors = [
      Color(0xFF9B87F5),
      Color(0xFF64B5F6),
      Color(0xFF52C7A2),
    ];
    return isSelected
        ? selectedColors[index % selectedColors.length]
        : colors[index % colors.length];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            // Logo e identidad CineStar en la esquina superior izquierda
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B87F5), Color(0xFF7EC8E3)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.movie_filter_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'CineStar',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: 0.5,
                color: Color(0xFF3B3355),
              ),
            ),
            const SizedBox(width: 24),
            // Buscador integrado en el navbar
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Buscar película por título...',
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                      prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF7E6CE0)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Menú superior requerido por la rúbrica
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF3B3355)),
            tooltip: 'Menú',
            onSelected: (value) async {
              if (value == 'admin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                );
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'catalog',
                child: ListTile(
                  leading: Icon(Icons.movie_outlined, color: Color(0xFF9B87F5)),
                  title: Text('Catálogo de Películas'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'admin',
                child: ListTile(
                  leading: Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF52C7A2)),
                  title: Text('Administración'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text('Cerrar Sesión'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de colecciones debajo del navbar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFFDFCFF),
              border: Border(bottom: BorderSide(color: Color(0xFFE8E4FA))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Colecciones por género',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5C5470),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_collections.length, (index) {
                      final genre = _collections[index];
                      final isSelected = _selectedGenre == genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            genre,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isSelected ? Colors.white : const Color(0xFF3B3355),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: _pastelChipColor(index, true),
                          backgroundColor: _pastelChipColor(index, false),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) {
                            setState(() => _selectedGenre = genre);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal del catálogo desde Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('movies').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay películas registradas todavía.\nVe al menú superior -> Administración para agregar.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Convertir documentos y aplicar filtros de búsqueda y género
                final allMovies = snapshot.data!.docs.map((doc) {
                  return Movie.fromMap(doc.id, doc.data() as Map<String, dynamic>);
                }).toList();

                final filteredMovies = allMovies.where((movie) {
                  final matchesSearch = movie.title.toLowerCase().contains(_searchQuery);
                  final matchesGenre = _selectedGenre == 'Todas' ||
                      movie.genre.toLowerCase().contains(_selectedGenre.toLowerCase());
                  return matchesSearch && matchesGenre;
                }).toList();

                if (filteredMovies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 54, color: Color(0xFF9B87F5)),
                        const SizedBox(height: 10),
                        Text(
                          'No se encontraron películas en "$_selectedGenre"${_searchQuery.isNotEmpty ? ' con "$_searchQuery"' : ''}.',
                          style: const TextStyle(fontSize: 15, color: Color(0xFF5C5470)),
                        ),
                      ],
                    ),
                  );
                }

                // Grid compacto y responsivo
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int columns = 2;
                    if (constraints.maxWidth >= 1200) {
                      columns = 6;
                    } else if (constraints.maxWidth >= 900) {
                      columns = 5;
                    } else if (constraints.maxWidth >= 650) {
                      columns = 3;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE4DFFB), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9B87F5).withValues(alpha: 0.10),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: movie.imageUrl.isNotEmpty
                                      ? Image.network(
                                          movie.imageUrl,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: const Color(0xFFEDE9FE),
                                            child: const Icon(Icons.broken_image, color: Color(0xFF9B87F5)),
                                          ),
                                        )
                                      : Container(
                                          color: const Color(0xFFEDE9FE),
                                          child: const Icon(Icons.movie, color: Color(0xFF9B87F5)),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD5F5E9), // Verde menta pastel
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          movie.genre,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF246A54),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        movie.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF2D264B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}