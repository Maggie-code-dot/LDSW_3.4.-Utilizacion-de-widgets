import 'package:flutter/material.dart';
import 'pokemon_service.dart'; 

class PokemonScreen extends StatelessWidget {
  final PokemonService _pokemonService = PokemonService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo PokéAPI - Tarea HTTP'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _pokemonService.fetchPokemonList(),
        builder: (context, snapshot) {
          // 1. Estado de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
          // 2. Control de Errores
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ocurrió un error:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } 
          // 3. Lista vacía
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No se encontraron registros.'),
            );
          }

          // 4. Construcción de la lista de resultados
          final pokemonList = snapshot.data!;
          return ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              final pokemonId = index + 1; // Generamos el ID según su posición
              
              // URL oficial del sprite de PokéAPI
              final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.catching_pokemon),
                  ),
                  title: Text(
                    pokemon['name'].toString().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID del registro: #$pokemonId'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}