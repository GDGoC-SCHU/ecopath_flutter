import 'package:eco_path/data/city_list.dart';
import 'package:flutter/material.dart';

import 'click_to_city.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return const Column(
            children: [
              HomePageHeader(),
              Expanded(child: HomePageBody()), // ✅ 핵심: 여기서 확실한 제약 부여
            ],
          );
        },
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(double.infinity, 180),
          painter: WavePainter(),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          height: 140,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.flight, color: Colors.blue, size: 28),
              Text(
                "Eco Path",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Icon(Icons.menu, color: Colors.blue, size: 28),
            ],
          ),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDEEFF)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height - 30);

    // 커스텀 곡선 (오른쪽으로 비대칭 + 움푹 들어감)
    path.cubicTo(
      size.width * 0.25,
      size.height,
      size.width * 0.75,
      size.height - 80,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
        child: const Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("환영합니다.",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Text(
              "친환경 여행을 시작해볼까요?",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            SearchBarPage()
          ],
        ));
  }
}

class SearchBarPage extends StatefulWidget {
  const SearchBarPage({super.key});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> cList = cityList;

  List<String> searchList = [];

  /// 검색
  void _filterAndRankList(String query) {
    if (query.isEmpty) {
      setState(() {
        searchList = [];
      });
      return;
    }
    final ranked = cList.where((word) => word.contains(query)).map((word) {
      int index = word.indexOf(query);
      int score = index == 0 ? 100 : (index > 0 ? 50 - index : 0);
      return MapEntry(word, score);
    }).toList();

    ranked.sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      searchList = ranked.map((e) => e.key).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: _controller,
            onChanged: _filterAndRankList,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요',
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      if (searchList.isNotEmpty)
        SizedBox(
            height: 200, // 또는 원하는 고정 높이
            child: ListView.separated(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchList[index]),
                  onTap: () => clickToCity(context, searchList[index]),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ))
    ]);
  }
}
