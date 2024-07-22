import 'dart:convert';
import 'package:bookstore/constants/constants.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getAllBooks() async {
  final response = await http.get(Uri.parse(getAllBooksUrl));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  }
  return {'error': 'no books found'};
}

Future<Map<String, dynamic>> getByID(String id) async {
  final response = await http.get(Uri.parse(getByIDUrl + id));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data'];
  }
  return {'error': 'Sorry, couldn\'t find your book'};
}

Future<Map<String, dynamic>> searchByTitle(String title) async {
  final response = await http.get(Uri.parse("$searchByTitleUrl${title.replaceAll(' ', '%20')}&pageNo=0&pageSize=10&sortBy=id&order=asc"));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final booksData = data;
    return booksData;
  }
  return {'error': 'Sorry, couldn\'t find your book'};
}