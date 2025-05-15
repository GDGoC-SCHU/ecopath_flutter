import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';

import 'recommand_page.dart';

class RecommandPathPage extends StatefulWidget {
  /// 부모 위젯 상태 변경
  final Function([Map<String, String>?, List<Map<String, String>>?])
      onClickCard;

  const RecommandPathPage({super.key, required this.onClickCard});

  @override
  State<RecommandPathPage> createState() => _RecommandPathPageState();
}

class _RecommandPathPageState extends State<RecommandPathPage> {
  ///
  final List<Map<String, String>> RecommandPathCards = [
    {NAME: "이름", CATEGORY: "카테고리"},
    {NAME: "이름1", CATEGORY: "카테고리1"},
    {NAME: "이름2", CATEGORY: "카테고리2"},
    {NAME: "이름3", CATEGORY: "카테고리3"},
    {NAME: "이름4", CATEGORY: "카테고리4"}
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () => {
                  widget.onClickCard(RecommandPathCards[0], RecommandPathCards),
                },
            child: ListView.separated(
              itemBuilder: (_, index) =>
                  recommandCard(RecommandPathCards[index]),
              itemCount: RecommandPathCards.length,
              separatorBuilder: (_, __) => const SizedBox(
                height: 16,
              ),
            )));
  }
}
