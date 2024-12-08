import 'dart:convert';
import 'dart:async'; 
import 'package:http/http.dart' as http;
import 'parse_book.dart';

class MakeApiCalls {
  static const String apiUrl = 'https://gutendex.com/books';

  /// Fetch books normally with pagination
  static Future<List<Book>> fetchBooks(int page) async {
    final uri = Uri.parse('$apiUrl?page=$page');
    return _fetchBooksFromApi(uri);
  }

  static Future<bool> morePages(int page) async {
    final uri = Uri.parse('$apiUrl?page=$page');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['next'] == null) return false;
      return true;
    } else {
      throw Exception('Failed to load books');
    }
  }

  /// Fetch books based on a search query
  static Future<List<Book>> searchBooks(String query, int page) async {
    final uri = Uri.parse('$apiUrl?page=$page&search=$query');
    return _fetchBooksFromApi(uri);
  }

  /// Common function to handle API response with retry mechanism
  static Future<List<Book>> _fetchBooksFromApi(Uri uri) async {
    const int maxRetries = 5; 
    const Duration timeoutDuration = Duration(seconds: 10); 
    const Duration retryDelay = Duration(seconds: 3); 

    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        attempt++;
        // print('Attempt $attempt to fetch books from $uri');

        final response = await http.get(uri).timeout(timeoutDuration);

        print("-------------------");
        print(uri);
        print(response.statusCode);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return (data['results'] as List)
              .map((json) => Book.parseJson(json))
              .toList();
        } else if (response.statusCode == 404) {
          // If status code is 404 (Not Found), return an empty list
          return [];
        } else {
          // For other non-200 status codes, throw an exception
          throw Exception('Failed to load books: ${response.statusCode}');
        }
      } on TimeoutException catch (_) {
        // print('Timeout on attempt $attempt for $uri');
        if (attempt < maxRetries) {
          await Future.delayed(retryDelay); 
        } else {
          throw Exception('Request timed out after $maxRetries attempts.');
        }
      } on Exception catch (e) {
        // print('An error occurred: $e');
        throw Exception('Failed to fetch books due to an unexpected error.');
      }
    }

    // If all attempts fail, throw an exception
    throw Exception('Failed to fetch books after $maxRetries retries.');
  }
}
