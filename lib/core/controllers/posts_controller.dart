import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/models/post_model.dart';
import 'package:whispr_app/core/services/local_database_service.dart';

/// Global controller for managing posts across the app.
class PostsController extends GetxController {
  static PostsController get to => Get.find<PostsController>();

  final _db = LocalDatabaseService.instance;

  final posts = <PostModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  /// Loads all posts from the database.
  Future<void> loadPosts() async {
    isLoading.value = true;
    try {
      final allPosts = await _db.getAllPosts();
      posts.value = allPosts;
    } catch (e) {
      debugPrint('Error loading posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Creates a new post.
  Future<bool> createPost({
    required BuildContext context,
    required String caption,
    String? mediaPath,
    String? mediaType,
    required String visibility,
    required bool allowComments,
  }) async {
    try {
      final post = PostModel(
        caption: caption,
        mediaPath: mediaPath,
        mediaType: mediaType,
        visibility: visibility,
        allowComments: allowComments,
        createdAt: DateTime.now(),
      );
      await _db.insertPost(post);
      await loadPosts();
      if (context.mounted) {
        CommonSnackbar.showSuccess(
          context,
          message: 'Confession shared successfully',
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Failed to share confession',
        );
      }
      return false;
    }
  }

  /// Toggles like on a post.
  Future<void> toggleLike(BuildContext context, int postId) async {
    try {
      final updated = await _db.toggleLike(postId);
      if (updated != null) {
        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          posts[index] = updated;
        }
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      if (context.mounted) {
        CommonSnackbar.showError(context, message: 'Failed to update like');
      }
    }
  }

  /// Updates a post's caption.
  Future<bool> updateCaption(
    BuildContext context,
    int postId,
    String newCaption,
  ) async {
    try {
      await _db.updatePostCaption(postId, newCaption);
      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = posts[index].copyWith(caption: newCaption);
      }
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, message: 'Confession updated');
      }
      return true;
    } catch (e) {
      debugPrint('Error updating caption: $e');
      if (context.mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Failed to update confession',
        );
      }
      return false;
    }
  }

  /// Deletes a post.
  Future<bool> deletePost(BuildContext context, int postId) async {
    try {
      await _db.deletePost(postId);
      posts.removeWhere((p) => p.id == postId);
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, message: 'Confession deleted');
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(
          context,
          message: 'Failed to delete confession',
        );
      }
      return false;
    }
  }

  /// Gets comment count for a post.
  Future<int> getCommentCount(int postId) async {
    try {
      return await _db.countCommentsForPost('post_$postId');
    } catch (e) {
      debugPrint('Error getting comment count: $e');
      return 0;
    }
  }
}
