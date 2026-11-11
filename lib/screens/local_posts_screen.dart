import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/lesson_hint.dart';
import 'local_add_post_screen.dart';

/// Same "get posts" UI as PostsScreen, but NO Provider.
///
/// State lives only inside this StatefulWidget (setState).
/// - Add: works — we insert the returned Post into [posts]
/// - Refresh: reloads from the API, so the locally added post disappears
///   (JSONPlaceholder does not really save it)
class LocalPostsScreen extends StatefulWidget {
  const LocalPostsScreen({super.key});

  @override
  State<LocalPostsScreen> createState() => _LocalPostsScreenState();
}

class _LocalPostsScreenState extends State<LocalPostsScreen> {
  final _service = PostService();

  List<Post> posts = [];
  bool isLoading = false;
  String? errorMessage;
  bool showHint = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchPosts());
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loaded = await _service.getPosts();
      if (!mounted) return;
      setState(() {
        posts = loaded;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Something went wrong.\n$e';
        isLoading = false;
      });
    }
  }

  Future<void> openAddPost() async {
    // Wait for a Post? from LocalAddPostScreen (or null if user cancels)
    final created = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const LocalAddPostScreen()),
    );

    if (!mounted || created == null) return;

    // Local-only update — nothing is shared with other screens.
    setState(() {
      posts.insert(0, created);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Added in this screen only. Tap refresh — it will disappear.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setState · ${posts.length} posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from API (local adds are lost)',
            onPressed: fetchPosts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddPost,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (showHint)
            LessonHint(
              text:
                  'Without Provider: list lives in setState. '
                  'Add works until you refresh — then GET replaces the list.',
              onClose: () => setState(() => showHint = false),
            ),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchPosts,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 88),
      itemCount: posts.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${post.id}')),
          title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        );
      },
    );
  }
}
