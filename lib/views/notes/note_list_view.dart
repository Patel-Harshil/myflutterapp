import 'package:flutter/material.dart';
import 'package:my_flutter_app/services/cloud/cloud_note.dart';
import 'package:my_flutter_app/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text.isNotEmpty ? note.text : "Empty Note",
            maxLines: 1, //extends to 1 line
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:my_flutter_app/services/crud/notes_service.dart';
// import 'package:my_flutter_app/utilities/dialogs/delete_dialog.dart';

// typedef NoteCallback = void Function(DatabaseNote note);

// class NotesListView extends StatelessWidget {
//   final List<DatabaseNote> notes;
//   final NoteCallback onDeleteNote;
//   final NoteCallback onTap;
//   const NotesListView({
//     super.key,
//     required this.notes,
//     required this.onDeleteNote,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         return ListTile(
//           onTap: () {
//             onTap(note);
//           },
//           title: Text(
//             note.text.isNotEmpty ? note.text : "Empty Note",
//             maxLines: 1, //extends to 1 line
//             softWrap: true,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: IconButton(
//             onPressed: () async {
//               final shouldDelete = await showDeleteDialog(context);
//               if (shouldDelete) {
//                 onDeleteNote(note);
//               }
//             },
//             icon: const Icon(Icons.delete),
//           ),
//         );
//       },
//     );
//   }
// }
