import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/services/cloud/cloud_note.dart';
import 'package:my_flutter_app/services/cloud/cloud_storage_constants.dart';
import 'package:my_flutter_app/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

// --------------------CRUD-----------------------------------------------------
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
        documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
            //     return CloudNote(
            //       documentId: doc.id,
            //       ownerUserId: doc.data()[ownerUserIdFieldName] as String,
            //       text: doc.data()[textFieldName] as String,
            //     );
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNoteUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

// ---------------------------Singleton-------------------------------------------
  //this is static that is only initialized once when class is called first time
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  //private constructor
  FirebaseCloudStorage._sharedInstance();
  // factory constructor that is called by all the objects of this class
  factory FirebaseCloudStorage() => _shared;
}
