import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/article.dart';
import '../controllers/article_detail_controller.dart';
import '../../../routes/app_pages.dart'; // Pastikan path ini sesuai

class ArticleDetailPage extends GetView<ArticleDetailController> {
  final Article article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: article.urlToImage ?? article.title,
              child: article.urlToImage != null
                  ? Image.network(
                      article.urlToImage!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'No Image',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Date: ${article.publishedAt}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Author: ${article.author}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  // Tombol navigasi ke WebView
                  ElevatedButton(
                    onPressed: () {
                      if (article.url.isNotEmpty) {
                        // Navigasi ke halaman WebView dengan argument artikel
                        Get.toNamed(Routes.ARTICLE_DETAILS_WEBVIEW, arguments: article);
                      } else {
                        // Tampilkan pesan error jika URL tidak ada
                        Get.snackbar('Error', 'No URL available for this article');
                      }
                    },
                    child: const Text('Read more'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}