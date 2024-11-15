import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String id;
  String nome;
  Category({
    required this.id,
    required this.nome,
  });

  @override
  String toString() => 'Category(id: $id, nome: $nome)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
