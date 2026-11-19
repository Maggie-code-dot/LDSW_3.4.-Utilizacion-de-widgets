import 'package:flutter/material.dart';
import 'movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: movie.imageUrl.isNotEmpty
                    ? Image.network(
                        movie.imageUrl,
                        height: 320,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                      )
                    : const Icon(Icons.movie, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              movie.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Año: ${movie.year}')),
                Chip(label: Text('Género: ${movie.genre}')),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Director: ${movie.director}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 28),
            Text(
              'Sinopsis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              movie.synopsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}