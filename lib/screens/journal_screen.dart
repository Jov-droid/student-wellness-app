import 'package:flutter/material.dart';
import 'package:student_wellness/models/journal_entry.dart';
import 'package:student_wellness/services/hive_service.dart';
import 'package:student_wellness/widgets/journal_card.dart';
import 'package:uuid/uuid.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = HiveService.getJournalEntries();
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = JournalEntry(
        const Uuid().v4(),
        DateTime.now(),
        _contentController.text,
        _titleController.text.isNotEmpty ? _titleController.text : null,
      );

      await HiveService.addJournalEntry(newEntry);
      _titleController.clear();
      _contentController.clear();
      await _loadEntries();

      // Hide keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // New entry form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Write your thoughts...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write something';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveEntry,
                    child: const Text('Save Entry'),
                  ),
                ],
              ),
            ),
          ),

          // Journal entries list
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return JournalCard(
                  entry: _entries[index],
                  onDelete: () async {
                    await HiveService.deleteJournalEntry(_entries[index].id);
                    await _loadEntries();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}