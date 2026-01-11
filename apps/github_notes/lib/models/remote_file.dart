/// Remote GitHub file metadata
class RemoteFile {
  final String sha;
  final String content;
  final String path;

  const RemoteFile({
    required this.sha,
    required this.content,
    required this.path,
  });
}
