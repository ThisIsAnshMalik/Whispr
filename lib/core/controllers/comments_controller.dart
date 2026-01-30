import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/models/comment_model.dart';
import 'package:whispr_app/core/services/local_database_service.dart';

/// Holds a comment and its replies for easy UI rendering.
class CommentWithReplies {
  final CommentModel comment;
  final List<CommentModel> replies;

  CommentWithReplies({required this.comment, required this.replies});
}

/// Controller for managing comments on a post.
class CommentsController extends GetxController {
  final String postId;
  CommentsController({required this.postId});

  final _db = LocalDatabaseService.instance;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final comments = <CommentWithReplies>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;

  /// The comment being replied to (null = new top-level comment).
  final replyingTo = Rx<CommentModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadComments();
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  /// Loads all comments and their replies for the post.
  Future<void> loadComments() async {
    isLoading.value = true;
    try {
      final topLevel = await _db.getCommentsForPost(postId);
      final list = <CommentWithReplies>[];
      for (final c in topLevel) {
        final replies = c.id != null
            ? await _db.getReplies(c.id!)
            : <CommentModel>[];
        list.add(CommentWithReplies(comment: c, replies: replies));
      }
      comments.value = list;
    } catch (e) {
      debugPrint('Error loading comments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Starts replying to a comment (shows in text field hint).
  void startReply(CommentModel comment) {
    replyingTo.value = comment;
    focusNode.requestFocus();
  }

  /// Cancels the reply mode.
  void cancelReply() {
    replyingTo.value = null;
  }

  /// Sends a new comment or reply.
  Future<void> sendComment(BuildContext context) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;
    try {
      final comment = CommentModel(
        postId: postId,
        parentId: replyingTo.value?.id,
        text: text,
        createdAt: DateTime.now(),
      );
      await _db.insertComment(comment);
      textController.clear();
      replyingTo.value = null;
      await loadComments();
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, message: 'Comment added');
      }
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(context, message: 'Failed to add comment');
      }
    } finally {
      isSending.value = false;
    }
  }

  /// Deletes a comment.
  Future<void> deleteComment(BuildContext context, int id) async {
    try {
      await _db.deleteComment(id);
      await loadComments();
      if (context.mounted) {
        CommonSnackbar.showSuccess(context, message: 'Comment deleted');
      }
    } catch (e) {
      if (context.mounted) {
        CommonSnackbar.showError(context, message: 'Failed to delete comment');
      }
    }
  }
}
