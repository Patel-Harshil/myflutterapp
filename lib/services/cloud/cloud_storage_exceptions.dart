class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNoteCreateNoteException extends CloudStorageException {}
// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}
// U in CRUD
class CouldNoteUpdateNoteException extends CloudStorageException{}
// D in CRUD
class CouldNotDeleteNoteException extends CloudStorageException {}
