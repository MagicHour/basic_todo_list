import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_app_3/todoList.dart';

typedef SpringyDraggableDrag = void Function(SpringyDraggableState state, DragEndDetails details);

class SpringyDraggable extends StatefulWidget{
  final SpringyDraggableDrag onDragEnd;
  SpringyDraggable(this.onDragEnd);
  @override
  State<StatefulWidget> createState() => SpringyDraggableState(onDragEnd);

}

class SpringyDraggableState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Offset currentOffset = Offset.zero;
  Animation<Offset> _animation;

  SpringyDraggableDrag onDragEnd;

  SpringyDraggableState(this.onDragEnd);


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // When ever our AnimationController ticks we see who should get animated
    _controller.addListener(() {
      setState(() {
        currentOffset = _animation.value;
      });
    });
  }


  void springBack() {
    _animation = _controller.drive(
      //A type of animation where we go from begin to end for a specified duration
      Tween<Offset>(
          begin: currentOffset,
          end: Offset.zero
      ),
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, 0);
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child:Stack(
            children: <Widget>[
              Positioned(
                  left: currentOffset.dx,
                  child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          currentOffset = Offset(currentOffset.dx + details.delta.dx, currentOffset.dy);
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        onDragEnd.call(this, details);
                      },
                      child: Container(
                        width: size.width,
                        child: Card(
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(width: 5), // padding
                                Icon(Icons.arrow_back_ios),
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text("Swipe to confirm!!",
                                        style: TextStyle(fontSize: 18)),
                                    SizedBox(height: 10),
                                  ]
                                ),
                                Icon(Icons.arrow_forward_ios),
                                Container(width: 5) // padding
                              ],
                            )
                        ),
                      )
                  )
              )
            ]
        )
    );
  }
}

class NewTodoPage extends StatelessWidget{
  final ListState _listener;
  NewTodoPage(this._listener);

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text("Create a new TODO")),
        body: NewTodoInput(_listener)
    );
  }
}

class NewTodoInput extends StatefulWidget{
  final ListState _listener;
  NewTodoInput(this._listener);

  @override
  State<StatefulWidget> createState() => _NewTodoInputState(this._listener);
}

class _NewTodoInputState extends State<NewTodoInput>{
  String newText = "";
  final ListState _listener;

  _NewTodoInputState(this._listener);

  // Updates the main list for any new items
  void updateList(){
    if(newText == "") return;
    this._listener.widget.setState(() {
      this._listener.list.add(TodoItemInfo(newText));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return  Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: size.width/2,
                  child: TextField(
                      onSubmitted: (text) => newText = text,
                      decoration: InputDecoration(
                          hintText: "Enter something"
                      )
                  )
              )
            ]
        ),
        Container(height: 10), // Some padding
        SpringyDraggable(
                (draggable, details) {
              if(draggable.currentOffset.dx.abs() >= size.width*0.4){
                if(newText == ""){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Please enter some text!"),
                          backgroundColor: Colors.red,
                      )
                  );
                  draggable.springBack();
                  return;
                }
                _listener.widget.setState(() {
                  _listener.list.add(TodoItemInfo(newText));
                });
                Navigator.pop(context);
              } else {
                draggable.springBack();
              }
            }
        )
      ],
    );
  }
}
