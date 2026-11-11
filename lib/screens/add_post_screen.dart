import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> savePost() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    setState(() => isSaving = true);

    final success = await context.read<PostProvider>().addPost(title, body);

    if (!mounted) return; // the user may have left the screen
    setState(() => isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create post. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: const Text('New post · Provider')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Uses PostProvider.addPost. No need to return data with '
            'Navigator.pop — the shared provider already holds the new post.',
            style: TextStyle(color: muted, height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: bodyController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Body',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: isSaving ? null : savePost,
            child: Text(isSaving ? 'Saving...' : 'Save post'),
          ),
        ],
      ),
    );
  }
}
