class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['resourceId']['videoId'],
      title: map['title'],
      thumbnailUrl: map['thumbnails']['high']['url'],
      channelTitle: map['channelTitle'],
    );
  }
}