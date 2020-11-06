import 'package:flutter/material.dart';

class AnimationDemo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("gfgs")),
        body: TextAnimation(),
      ),
    );
  }
}

class TextAnimation extends StatefulWidget {
  @override
  _TextAnimationState createState() => _TextAnimationState();
}

class _TextAnimationState extends State<TextAnimation> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  int i = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    // the animated bit
    _controller.addListener(() {
      setState(() {
        i++;
      });
    });
    _controller.forward(); // start the animation
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        i = 0;
        _controller.reset();
        _controller.forward();
      },
      child: Center(child: Text("$i hii", textDirection: TextDirection.ltr))
    );
  }
}
