import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/services/cloud/cloud_note.dart';
import 'package:my_flutter_app/services/cloud/cloud_storage_constants.dart';
import 'package:my_flutter_app/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

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
