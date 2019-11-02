import 'package:flutter/material.dart';
import 'package:todo_app/infraestructure/Sqflite_CourseRepository.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/model/course.dart';
import 'package:todo_app/screen/course/course_detail_page.dart';

class CourseListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CourseListPageState();
}

class CourseListPageState extends State<CourseListPage> {
  SqfliteCourseRepository courseRepository = SqfliteCourseRepository(DatabaseHelper.get);
  List<Course> courses;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      courses = List<Course>();
      getData();
    }
    return Scaffold(
      body: courseListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          navigateToDetail(Course('', 1, 4, 0, ''));
        }
        ,
        tooltip: "Add new Course",
        child: new Icon(Icons.add),
      ),
    );
  }
  
  ListView courseListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.courses[position].semester),
              child:Text(this.courses[position].semester.toString()),
            ),
          title: Text(this.courses[position].name),
          subtitle: Text(this.courses[position].credits.toString()),
          onTap: () {
            debugPrint("Tapped on " + this.courses[position].id.toString());
            navigateToDetail(this.courses[position]);
          },
          ),
        );
      },
    );
  }
  
  void getData() {
      print('Main Thread getData');
      final coursesFuture = courseRepository.getList();
      print('Main Thread getList ' + coursesFuture.toString());
      coursesFuture.then((courseList) {
        print('Main Thread getList .then');
        setState(() {
          courses = courseList;
          count = courseList.length;
        });
        debugPrint("Main Thread - Items: " + count.toString());
      });
  }

  Color getColor(int semester) {
    switch (semester) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.yellow;
        break;
      case 4:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Course course) async {
    bool result = await Navigator.push(context, 
        MaterialPageRoute(builder: (context) => CourseDetailPage(course)),
    );
    if (result == true) {
      getData();
    }
  }
}