class User {
  
  final String name;
  final String comment;
  final int updated;
  final String id;
  
  User(this.name, this.comment, {
    this.updated = 0,
    this.id,
  });

}