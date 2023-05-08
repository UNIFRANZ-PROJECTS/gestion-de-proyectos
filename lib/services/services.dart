String host() => 'http://localhost:8001/api';

String setLogin() => '/auth';
//teacher
String teachers(String? id) => '/teacher/${id ?? ''}';
String teachersXlxs() => '/teacher/file';
String downloadTechers() => '/teacher/download';
// subject
String subjects(String? id) => '/subject/${id ?? ''}';
String subjectsXlxs() => '/subject/file';
// projects
String projects(String? id) => '/project/${id ?? ''}';
//users
String users(String? id) => '/user/${id ?? ''}';
String studentsXlxs() => '/user/file';
//permisos
String permisions() => '/permision';
//roles
String roles(String? id) => '/role/${id ?? ''}';
//tipos de usuaros
String typeUsers(String? id) => '/typeuser/${id ?? ''}';
//categorias
String categories(String? id) => '/category/${id ?? ''}';
//tipos de proyectos
String typeProjects(String? id) => '/typeproject/${id ?? ''}';
