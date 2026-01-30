/// Represents a confession post.
class PostModel {
  final int? id;
  final String caption;
  final String? mediaPath;
  final String? mediaType; // 'video' or 'audio'
  final String visibility; // 'blurFace' or 'showFace'
  final bool allowComments;
  final int likes;
  final bool isLiked;
  final DateTime createdAt;

  PostModel({
    this.id,
    required this.caption,
    this.mediaPath,
    this.mediaType,
    required this.visibility,
    required this.allowComments,
    this.likes = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  /// Creates from database map.
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int?,
      caption: map['caption'] as String,
      mediaPath: map['media_path'] as String?,
      mediaType: map['media_type'] as String?,
      visibility: map['visibility'] as String,
      allowComments: (map['allow_comments'] as int) == 1,
      likes: map['likes'] as int? ?? 0,
      isLiked: (map['is_liked'] as int?) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// Converts to database map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'caption': caption,
      'media_path': mediaPath,
      'media_type': mediaType,
      'visibility': visibility,
      'allow_comments': allowComments ? 1 : 0,
      'likes': likes,
      'is_liked': isLiked ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Creates a copy with optional overrides.
  PostModel copyWith({
    int? id,
    String? caption,
    String? mediaPath,
    String? mediaType,
    String? visibility,
    bool? allowComments,
    int? likes,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      visibility: visibility ?? this.visibility,
      allowComments: allowComments ?? this.allowComments,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns the post id as string for comments.
  String get postIdString => 'post_$id';

  @override
  String toString() {
    return 'PostModel(id: $id, caption: $caption, mediaType: $mediaType, likes: $likes)';
  }
}
