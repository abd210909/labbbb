import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

/// Same "add post" UI as AddPostScreen, but NO Provider.
///
/// Instead of updating a shared PostProvider, this screen:
/// 1) calls PostService itself
/// 2) pops the created Post back to the previous screen
///
/// The list screen must insert that Post into its own setState list.
class LocalAddPostScreen extends StatefulWidget {
  const LocalAddPostScreen({super.key});

  @override
  State<LocalAddPostScreen> createState() => _LocalAddPostScreenState();
}

class _LocalAddPostScreenState extends State<LocalAddPostScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final _service = PostService();
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

    try {
      final created = await _service.createPost(
        Post(userId: 1, title: title, body: body),
      );

      if (!mounted) return;

      // Give the Post back to LocalPostsScreen — there is no shared provider.
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create post. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(title: const Text('New post · setState')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'No Provider here. After save we return the Post with '
            'Navigator.pop, and the list screen inserts it with setState.',
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
