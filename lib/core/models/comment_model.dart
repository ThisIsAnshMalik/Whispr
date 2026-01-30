/// Represents a comment on a confession post.
/// Supports nested replies via [parentId].
class CommentModel {
  final int? id;
  final String postId;
  final int? parentId; // null = top-level comment, non-null = reply
  final String text;
  final DateTime createdAt;

  CommentModel({
    this.id,
    required this.postId,
    this.parentId,
    required this.text,
    required this.createdAt,
  });

  /// Creates from database map.
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int?,
      postId: map['post_id'] as String,
      parentId: map['parent_id'] as int?,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// Converts to database map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'parent_id': parentId,
      'text': text,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Creates a copy with optional overrides.
  CommentModel copyWith({
    int? id,
    String? postId,
    int? parentId,
    String? text,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, parentId: $parentId, text: $text)';
  }
}
