import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/article.dart';

class HttpController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  static const String _apiKey = '2980294ea67f41b88ae36ab84fefd5c5'; // Ganti ke API KEY yang sudah didapat
  static const String _query = 'sneakers'; // Query yang akan dicari
  static const String _fromDate = '2024-09-13'; // Tanggal mulai pencarian
  static const String _sortBy = 'publishedAt'; // Sortir berdasarkan tanggal publikasi

  RxList<Article> articles = RxList<Article>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    await fetchArticles();
    super.onInit();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('${_baseUrl}everything?q=$_query&from=$_fromDate&sortBy=$_sortBy&apiKey=$_apiKey'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final articlesResult = Articles.fromJson(json.decode(jsonData));
        articles.value = articlesResult.articles.cast<Article>();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
