import 'package:todo_app/assembler/course_assembler.dart';
import 'package:todo_app/infraestructure/CourseRepository.dart';
import 'package:todo_app/data/database_helper.dart';
import 'package:todo_app/model/course.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteCourseRepository implements CourseRepository {
  final assembler = CourseAssembler();

  DatabaseHelper databaseMigration;

  SqfliteCourseRepository(this.databaseMigration);

  @override
  Future<int> insert(Course course) async {
    final db = await databaseMigration.db;
    var id = await db.insert(assembler.tableName, assembler.toMap(course));
    return id;
  }

  @override
  Future<int> delete(Course course) async {
    final db = await databaseMigration.db;
    int result = await db.delete(assembler.tableName,
        where: assembler.columnId + " = ?", whereArgs: [course.id]);
    return result;
  }

  @override
  Future<int> update(Course course) async {
    final db = await databaseMigration.db;
    int result = await db.update(assembler.tableName, assembler.toMap(course),
        where: assembler.columnId + " = ?", whereArgs: [course.id]);
    return result;
  }

  @override
  Future<List<Course>> getList() async {
    final db = await databaseMigration.db;
    print('Secondary Thread Future getList 1');
    var result = await db.rawQuery("SELECT * FROM courses order by semester ASC, name ASC");
    print('Secondary Thread Future getList 2');
    print(result);
    List<Course> courses = assembler.fromList(result);
    print('Secondary Thread Future getList 3');
    return courses;
  }

  Future<int> getCount() async {
    final db = await databaseMigration.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM courses')
    );
    return result;
  }
}