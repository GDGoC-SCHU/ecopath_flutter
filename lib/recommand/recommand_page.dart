import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';

class RecommandWidget extends StatefulWidget {
  /// 카테고리 (이걸로 서버 통신)
  final String category;

  /// 부모 위젯 상태 변경
  final Function([Map<String, String>?]) onClickCard;

  const RecommandWidget(
      {super.key, required this.category, required this.onClickCard});

  @override
  State<RecommandWidget> createState() => _RecommandWidgetState();
}

class _RecommandWidgetState extends State<RecommandWidget> {
  // 통신 후 해당 맵에 담기
  final List<Map<String, String>> categoryCards = [
    {NAME: "이름", CATEGORY: "카테고리"},
    {NAME: "이름1", CATEGORY: "카테고리1"}
  ];

  @override
  Widget build(BuildContext context) {
    return categoryCards.isEmpty
        ? const Text("검색 결과가 없음.", style: TextStyle(color: Colors.grey))
        : ListView.separated(
            itemBuilder: (context, index) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => widget.onClickCard(categoryCards[index]),
                  child: recommandCard(categoryCards[index]),
                )),
            itemCount: categoryCards.length,
            separatorBuilder: (_, __) => const SizedBox(
              height: 16,
            ),
          );
  }
}

Container recommandCard(Map<String, String> card) {
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
          "카테고리: ${card[CATEGORY]}",
          style: const TextStyle(color: Colors.black),
        )
      ],
    ),
  );
}
