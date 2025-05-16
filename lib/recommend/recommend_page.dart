import 'dart:convert';

import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class RecommendWidget extends StatefulWidget {
  /// 카테고리 (이걸로 서버 통신)
  final String category;

  /// 부모 위젯 상태 변경
  final Function([Map<String, String>?]) onClickCard;

  const RecommendWidget(
      {super.key, required this.category, required this.onClickCard});

  @override
  State<RecommendWidget> createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {
  // 통신 후 해당 맵에 담기
  final List<Map<String, String>> categoryCards = [];

  List<CategoryClass> places = [];
  bool loading = true;

  Future<void> fetchRecommendPlaces() async {
    try {
      final response = await http.get(Uri.parse(
          "$BASE_URL/get_gemini_recommend?user_category_answer=${widget.category}"));
      logger.d(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        logger.f("${jsonData['responses']['response'].runtimeType}");

        final List<dynamic> data = jsonData['responses']['response'];
        if (!mounted) return;

        setState(() {
          places = data.map((e) => CategoryClass.fromJson(e)).toList();
          for (var i in places) {
            categoryCards.add({NAME: i.name, CATEGORY: widget.category});
          }
          loading = false;
        });
      } else {
        throw Exception('Failed to fetch places');
      }
    } catch (e) {
      logger.e('에러 발생: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecommendPlaces();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return places.isEmpty
        ? const Text("검색 결과가 없음.", style: TextStyle(color: Colors.grey))
        : ListView.separated(
            itemBuilder: (context, index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onClickCard(categoryCards[index]),
                  child: recommandCard(places[index]),
                )),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(
              height: 16,
            ),
          );
  }
}

Container recommandCard(CategoryClass card) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(3))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.name,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          card.description,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "특징:",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          card.features,
          style: const TextStyle(color: Colors.black),
        )
      ],
    ),
  );
}

class CategoryClass {
  final String name;
  final String description;
  final String features;

  CategoryClass({
    required this.name,
    required this.description,
    required this.features,
  });

  factory CategoryClass.fromJson(Map<String, dynamic> json) {
    return CategoryClass(
      name: json['name'],
      description: json['description'],
      features: json['features'],
    );
  }
}
