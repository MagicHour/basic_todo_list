
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_app_3/todoListPage2.dart';
import 'package:flutter_app_3/todoListPage3.dart';

class TodoList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Welcome to My Todo List",
        theme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(title: Text("Youkoso")),
            body: Center(child: TodoItemList())
        )
    );
  }
}

class TodoItemInfo {
  String todoText = "";
  bool isDone = false;
  String string;
  TodoItemInfo(this.todoText);
  String toString(){
    return "TodoItemInfo(\"$todoText\", $isDone)";
  }
}


class TodoItemList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TodoItemListState();

}

class ListState{
  ListState(this.widget, this.list);

  State widget;
  List list;

}

// List of items
class _TodoItemListState extends State<StatefulWidget> {
  List<TodoItemInfo> _todos = <TodoItemInfo>[
    TodoItemInfo("Mercury"),
    TodoItemInfo("Venus"),
    TodoItemInfo("Earth"),
    TodoItemInfo("Mars"),
    TodoItemInfo("Asteroid belt"),
    TodoItemInfo("Jupiter"),
    TodoItemInfo("Saturn"),
    TodoItemInfo("Uranus"),
    TodoItemInfo("Neptune"),
    TodoItemInfo("Ice")
  ];

  ListState listState;

  @override
  void initState() {
    super.initState();
    listState = ListState(this, _todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _makeTodoList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewTodoPage(listState)),
            );
          },
        )
    );
  }

  removeTodo(TodoItemInfo info){
    setState(() {
      _todos.remove(info);
    });
  }

  //Make the entire list
  Widget _makeTodoList(){
    return ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          if(i % 2 == 1) return Divider();

          int itemIndex = i ~/ 2;
          if(itemIndex >= _todos.length){
            return Container(height: 50);
          }
          //return Container(height: 50, child: TodoItem(this, _todos, _todos[itemIndex]));

          return Dismissible(
              key: Key("${_todos[itemIndex].toString()}$itemIndex"),
              background: ListTile(
                tileColor: Colors.red,
                leading: Icon(Icons.remove_circle_outline),
                trailing: Icon(Icons.remove_circle_outline),
              ),
              onDismissed: (dir){
                setState(() {
                  _todos.removeAt(itemIndex);
                });
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Todo removed!", style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1)
                    ));
              },
              child: ListTile(
                  title: Text(
                      _todos[itemIndex].todoText,
                      style: TextStyle(fontSize: 18.0)
                  ),
                  trailing: Icon(
                      _todos[itemIndex].isDone ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                      color:  _todos[itemIndex].isDone ? Colors.green : Colors.white70
                  ),
                  onLongPress: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodoPageLookup(_todos[itemIndex].todoText)),
                      //Probably better to do something like;
                      // TodoPageLookup(onAdd: (item) {
                      //  setState(() {_todos[itemIndex].add....;});
                      // })
                    );
                  },
                  onTap: () => setState(() {
                    _todos[itemIndex].isDone = ! _todos[itemIndex].isDone;
                  })
              ));
        });
  }

}