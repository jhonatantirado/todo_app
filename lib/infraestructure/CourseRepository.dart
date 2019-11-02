import 'package:todo_app/model/course.dart';

abstract class CourseRepository {
  Future<int> insert(Course course);
  Future<int> update(Course course);
  Future<int> delete(Course course);
  Future<List<Course>> getList();
}