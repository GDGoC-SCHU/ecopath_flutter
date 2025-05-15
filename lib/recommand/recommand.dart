import 'package:eco_path/data/string.dart';
import 'package:flutter/material.dart';

import 'recommand_page.dart';
import 'recommand_path.dart';

class RecommandPage extends StatefulWidget {
  final String city;

  const RecommandPage({super.key, required this.city});

  @override
  State<RecommandPage> createState() => _RecommandState();
}

class _RecommandState extends State<RecommandPage> {
  int _selectedIndex = 0;

  /// 추천 경로 페이지는 이 파일에서, 나머지는 따로 불러오기
  late List<Widget> _pages;
  List<Map<String, String>> places = [];

  /// 사이드바로 섹션 조종
  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// 클릭한 장소 정보를 선택한 정보란에 넣고 말고를 제어
  void onClickPlace(
      [Map<String, String>? place, List<Map<String, String>>? placesList]) {
    /// 리스트가 들어왔을 때
    if (placesList != null) {
      List<Map<String, String>>? checkedList = placesList;
      bool flag = false;
      List<int>? indexs = [];
      for (int i = 0; i < places.length; i++) {
        for (int j = 0; j < placesList.length; j++) {
          if (places[i][NAME] == placesList[j][NAME] &&
              places[i][CATEGORY] == placesList[j][CATEGORY]) {
            flag = true;
            indexs.add(j);
            break;
          }
        }
      }
      if (flag) {
        for (var i in indexs) {
          checkedList.removeAt(i);
        }
      }
      setState(() => places.addAll(checkedList));
    }

    /// 장소 하나만 들어왔을 때
    else if (place != null) {
      bool flag = false;
      int index = 0;
      for (int i = 0; i < places.length; i++) {
        if (places[i][NAME] == place[NAME] &&
            places[i][CATEGORY] == place[CATEGORY]) {
          flag = true;
          index = i;
          break;
        }
      }
      setState(() {
        if (flag) {
          /// 장소가 이미 담겨있음
          places.removeAt(index);
        } else {
          /// 장소가 담겨있지 않음
          places.add(place);
        }
      });
    }
  }

  /// init page widget
  @override
  void initState() {
    super.initState();
    _pages = [
      RecommandPathPage(
        onClickCard: onClickPlace,
      ),
      RecommandWidget(
        category: "식당",
        onClickCard: onClickPlace,
      ),
      RecommandWidget(
        category: "관광지",
        onClickCard: onClickPlace,
      ),
      RecommandWidget(
        category: "카페",
        onClickCard: onClickPlace,
      ),
      RecommandWidget(
        category: "숙소",
        onClickCard: onClickPlace,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 250, 252),
      body: Center(
        child: Row(
          children: [
            // 사이드바
            Container(
              width: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 122, 215, 255),
                    Color.fromARGB(255, 67, 154, 240)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  IconButton(
                    icon: const Icon(Icons.recommend,
                        color: Colors.white, size: 40),
                    onPressed: () => _onIconTapped(0),
                  ),
                  IconButton(
                    icon: const Icon(Icons.restaurant,
                        color: Colors.white, size: 40),
                    onPressed: () => _onIconTapped(1),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.villa, color: Colors.white, size: 40),
                    onPressed: () => _onIconTapped(2),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.coffee, color: Colors.white, size: 40),
                    onPressed: () => _onIconTapped(3),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.hotel, color: Colors.white, size: 40),
                    onPressed: () => _onIconTapped(4),
                  ),
                  const SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
            Flexible(
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Column(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                "선택한 경로",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(3)),
                                    border: Border.all(color: Colors.black),
                                    color: const Color.fromARGB(
                                        255, 230, 241, 245)),
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: places.isEmpty
                                        ? const Center(
                                            child: Text(
                                              "아직 선택한 장소가 없습니다.",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        : ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              Map<String, String> place =
                                                  places[index];
                                              return Column(children: [
                                                InkWell(
                                                    onTap: () {
                                                      onClickPlace(place);
                                                    },
                                                    child: _buildSelectedCard(
                                                        place))
                                              ]);
                                            },
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                            itemCount: places.length)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Expanded(
                              child: _pages.isEmpty
                                  ? const Center(
                                      child: Text(
                                      "검색 결과가 없습니다.",
                                      style: TextStyle(color: Colors.grey),
                                    ))
                                  : _pages[_selectedIndex])
                        ]))))
          ],
        ),
      ),
    );
  }
}

Widget _buildSelectedCard(Map<String, String> data) {
  return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "이름: ${data[NAME]}",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "카테고리: ${data[CATEGORY]}",
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ));
}
