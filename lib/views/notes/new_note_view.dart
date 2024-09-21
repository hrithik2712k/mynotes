import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesServices = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textController.text;
    await _notesServices.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote?> createNewNote() async {
    try {
      final existingNote = _note;

      if (existingNote != null) {
        return existingNote;
      }

      final currentUser = AuthService.firebase().currentUser;

      if (currentUser == null) {
        return null;
      }

      final email = currentUser.email;

      if (email == null) {
        return null;
      }

      final owner = await _notesServices.getUser(email: email);

      final newNote = await _notesServices.createNote(owner: owner);
      return newNote;
    } catch (e) {
      // Handle the error (e.g., log it, show a message, etc.
      return null;
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder<DatabaseNote?>(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                _note = snapshot.data!;
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                );
              } else {
                // Handle the case where snapshot.data is null
                return const Center(
                  child: Text('Error: Could not load note'),
                );
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
