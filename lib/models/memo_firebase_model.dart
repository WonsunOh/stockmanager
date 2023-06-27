import 'package:cloud_firestore/cloud_firestore.dart';

class MemoFirebaseModel {
  String? id;
  String? writer;
  String? title;
  String? inputDay;
  String? completionDay;
  String? completionRate;
  String? category;
  String? content;

  MemoFirebaseModel({
    this.id,
    this.writer,
    this.title,
    this.inputDay,
    this.completionDay,
    this.completionRate,
    this.category,
    this.content,
  });

  MemoFirebaseModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot['id'];
    writer = documentSnapshot['writer'];
    title = documentSnapshot['title'];
    inputDay = documentSnapshot['inputDay'];
    completionDay = documentSnapshot['completionDay'];
    completionRate = documentSnapshot['completionRate'];
    category = documentSnapshot['category'];
    content = documentSnapshot['content'];
  }

  factory MemoFirebaseModel.fromMap(Map<dynamic, dynamic> json) {
    return MemoFirebaseModel(
      id: json['id'],
      writer: json['writer'],
      title: json['title'],
      inputDay: json['inputDay'],
      completionDay: json['completionDay'],
      completionRate: json['completionRate'],
      category: json['category'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'writer': writer,
      'title': title,
      'inputDay': inputDay,
      'completionDay': completionDay,
      'completionRate': completionRate,
      'category': category,
      'content': content,
    };
  }
}
