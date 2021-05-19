import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late PageController _pageController;

  late Animation<Offset> _circlePosition;

  final itemsCount = 4;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _pageController.addListener(_onPageViewScroll);

    _animationController = AnimationController(vsync: this);

    _circlePosition = TweenSequence<Offset>(
      <TweenSequenceItem<Offset>>[
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(10, 10), end: Offset(100, 10)),
          weight: 1,
        ),
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(100, 10), end: Offset(100, 100)),
          weight: 1,
        ),
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(100, 100), end: Offset(10, 100)),
          weight: 1,
        ),
      ],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Positioned(
              top: _circlePosition.value.dy,
              left: _circlePosition.value.dx,
              width: 10,
              height: 10,
              child: Container(color: Color(0xFF00FF00)),
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: itemsCount,
                itemBuilder: (context, index) => Container(
                  height: 150,
                  color: Color(0xFFFF0000),
                  margin: EdgeInsets.symmetric(horizontal: 32),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                _animationController.value.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageViewScroll() {
    _animationController.value = _pageController.page! / (itemsCount - 1);
  }
}
