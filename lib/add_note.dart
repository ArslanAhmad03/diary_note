import 'package:diary_note/Repository/note.dart';
import 'package:diary_note/Repository/note_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNote extends StatefulWidget {
  final Note? note;

  const AddNote({super.key, this.note});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add note"),
        actions: [
          widget.note != null? IconButton(
            onPressed: (){
              showDialog(context: context, builder: (context) =>
                AlertDialog(
                  content: const Text("sure you want to delete note"),
                  actions: [
                    TextButton(onPressed: (){Get.back();}, child: const Text('No')),
                    TextButton(onPressed: (){Get.back(); _deleteNote();}, child: const Text('Yes'))
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_outline,color: Colors.red),
          ) : const SizedBox(),
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: const Icon(Icons.done,color: Colors.green),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'type description here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _insertNote() async {
    final note = Note(
        title: _title.text,
        description: _description.text,
        createdAt: DateTime.now());

    await NoteRepository.insert(note: note);
  }

  _updateNote() async {
    final note = Note(
        id: widget.note!.id!,
        title: _title.text,
        description: _description.text,
        createdAt: widget.note!.createdAt);

    await NoteRepository.update(note: note);
  }

  _deleteNote() async {
    await NoteRepository.delete(note: widget.note!).then((e) {
      Get.back();
    });
  }
}
