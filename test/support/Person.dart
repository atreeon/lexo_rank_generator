class Person {
  int id;
  String name;
  int age;
  String rank;

  Person(this.id, this.name, this.age, this.rank);

  @override
  String toString() => //
      'Person{id: $id, name: $name, age: $age, rank: $rank}';

  Person copyWith({int? id, String? name, int? age, String? rank}) => //
      Person(id ?? this.id, name ?? this.name, age ?? this.age, rank ?? this.rank);
}
