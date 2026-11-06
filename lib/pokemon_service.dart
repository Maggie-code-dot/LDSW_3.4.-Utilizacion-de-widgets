import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  Future<List<dynamic>> fetchPokemonList() async {
    // Petición a PokéAPI para obtener los primeros 20 Pokémon
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al conectar con PokéAPI: ${response.statusCode}');
    }
  }
}