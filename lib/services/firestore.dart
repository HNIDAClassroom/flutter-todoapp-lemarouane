import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/model/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addTask(Task task) async {
  final docRef = await _firestore.collection('tasks').add({
    'title': task.title,
    'description': task.description,
    'date': task.date,
    'category': task.category.toString().split('.').last,
    'isDone': task.isDone,
  });
  return docRef.id; // Return the ID of the newly added task
}


  Stream<QuerySnapshot> getTasks() {
  return _firestore
      .collection('tasks')
      .orderBy('date', descending: true)
      .snapshots();
}

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _firestore.collection('tasks').doc(taskId).update(data);
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> updateTaskIsDone(String taskId, bool isDone) {
    return _firestore.collection('tasks').doc(taskId).update({'isDone': isDone});
  }
}
