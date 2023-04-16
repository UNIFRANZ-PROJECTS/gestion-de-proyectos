String setLogin() => '/auth';
//teacher
String teachers(String? id) => '/teacher/${id ?? ''}';
// subject
String subjects(String? id) => '/subject/${id ?? ''}';
// projects
String projects(String? id) => '/project/${id ?? ''}';
//users
String users(String? id) => '/user/${id ?? ''}';
//permisos
String permisions() => '/permision';
//roles
String roles(String? id) => '/role/${id ?? ''}';
//tipos de usuaros
String typeUsers(String? id) => '/typeuser/${id ?? ''}';
