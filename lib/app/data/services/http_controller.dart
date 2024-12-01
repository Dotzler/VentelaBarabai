import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/article.dart'; 
class HttpController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  static const String _apiKey = '2980294ea67f41b88ae36ab84fefd5c5'; 
  static const String _query = 'sneakers'; // Query pencarian
  static const String _fromDate = '2024-11-29&to=2024-11-29'; // Tanggal mulai pencarian
  static const String _sortBy = 'publishedAt'; // Sortir berdasarkan tanggal publikasi

  RxList<Article> articles = RxList<Article>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;

      // URL untuk API endpoint
      final Uri url = Uri.parse(
        '$_baseUrl/everything?q=$_query&from=$_fromDate&sortBy=$_sortBy&apiKey=$_apiKey',
      );

      // Permintaan GET ke endpoint API
      final response = await http.get(url);

      // Cek status HTTP
      if (response.statusCode == 200) {
        // Parse JSON dari response body
        final jsonData = json.decode(response.body);

        // Konversi JSON menjadi objek Articles
        final articlesResult = Articles.fromJson(jsonData);

        // Update nilai artikel di RxList
        articles.value = articlesResult.articles;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      // Selesaikan loading
      isLoading.value = false;
    }
  }
}