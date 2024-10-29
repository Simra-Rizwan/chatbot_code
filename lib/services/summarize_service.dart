// lib/services/summarize_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SummarizeService {
  final String baseUrl;

  SummarizeService(this.baseUrl);

  Future<String> summarizeText(String text, int sentenceCount) async {
    final url = '$baseUrl/summarize';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, 'sentence_count': sentenceCount}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['summary'];
    } else {
      throw Exception('Failed to summarize text');
    }
  }
}
