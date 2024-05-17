import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF202325),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final _bottomNavigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.access_time),
      label: 'Currently',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_view_day_sharp),
      label: 'Today',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: 'Weekly',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFF202325),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          stretch: true,
                          floating: true,
                          pinned: false,
                          backgroundColor: const Color(0xFF202325),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                      prefixIconColor: Colors.white,
                                      suffixIconColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: const Icon(Icons.clear),
                                      hintText: 'Search',
                                      fillColor: Colors.black12),
                                ),
                              ),
                              const Icon(
                                size: 30,
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          expandedHeight: 385,
                          flexibleSpace: FlexibleSpaceBar(
                            background: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                              child: Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/night.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  //date at the top left
                                  Positioned(
                                    top: 80,
                                    left: 20,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        '17th, may 2024',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 120,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        '22C\nSunny',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 30,
                                    right: 30,
                                    child: Row(children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'Hamid',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_outward_outlined,
                                        color: Colors.white,
                                      )
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF333438),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  textColor: Colors.white,
                                  title: Text('Item $index'),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF333438),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              )),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF333438),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: const Color(0xFF252729),
                    currentIndex: _currentIndex,
                    items: _bottomNavigationBarItems.map((item) {
                      final index = _bottomNavigationBarItems.indexOf(item);
                      return BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home,
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        label: item.label,
                      );
                    }).toList(),
                    onTap: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.bounceInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ForcastList extends StatelessWidget {
  const ForcastList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
