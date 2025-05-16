import 'dart:convert';

import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class RecommendPathPage extends StatefulWidget {
  /// 부모 위젯 상태 변경
  final Function([Map<String, String>?, List<Map<String, String>>?])
      onClickCard;

  const RecommendPathPage({super.key, required this.onClickCard});

  @override
  State<RecommendPathPage> createState() => _RecommendPathPageState();
}

class _RecommendPathPageState extends State<RecommendPathPage> {
  final List<Map<String, String>> recommendPathCards = [];
  List<RecommendedRoute> routes = [];

  bool loading = true;

  Future<void> fetchRecommandPath() async {
    try {
      final response =
          await http.get(Uri.parse("$BASE_URL/gemini_routes?region=서울"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rawList = data['recommended_routes'];
        final result =
            rawList.map((json) => RecommendedRoute.fromJson(json)).toList();
        if (!mounted) return;

        setState(() {
          routes = result;
          loading = false;
        });
      } else {
        throw Exception('Failed to load routes');
      }
    } catch (e) {
      logger.e('에러 발생: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecommandPath();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return routes.isEmpty
        ? const Center(
            child: Text(
              "추천 경로가 없습니다.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(), // 부모 스크롤만 사용
                  shrinkWrap: true, // 높이 무한 확장 방지
                  itemCount: routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onClickCard(
                        routes[index].course[0],
                        routes[index].course,
                      ),
                      child: SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: routes[index].course.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, index_) => recommandPathCard(
                            routes[index].course[index_],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class RecommendedRoute {
  final List<Map<String, String>> course;
  final String transportationGuide;

  RecommendedRoute({required this.course, required this.transportationGuide});

  factory RecommendedRoute.fromJson(Map<String, dynamic> json) {
    return RecommendedRoute(
      course: (json['course'] as List)
          .map((item) => {
                'category': item['category'] as String,
                'name': item['name'] as String
              })
          .toList(),
      transportationGuide: json['transportation_guide'] as String,
    );
  }
}

Container recommandPathCard(Map<String, String> card) {
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
          "이름: ${card[NAME]}",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "카테고리:${card[CATEGORY]}",
          style: const TextStyle(color: Colors.black),
        )
      ],
    ),
  );
}
