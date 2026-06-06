/// Holds developer-only audio configuration.
///
/// The audio container URL (an Azure Blob Storage container SAS URL) is a
/// private secret and must NOT be committed to the repository. It is injected
/// at build time via `--dart-define-from-file=secrets.json`, for example:
///
///   flutter run --dart-define-from-file=secrets.json
///   flutter build apk --dart-define-from-file=secrets.json
///
/// `secrets.json` is gitignored. See `secrets.example.json` for the format.
class AudioConfig {
  /// Full Azure Blob Storage container SAS URL, e.g.
  /// `https://<account>.blob.core.windows.net/<container>?sp=r&st=...&sig=...`
  ///
  /// Blob (word) names are inserted into the path before the query string.
  static const String audioContainerSasUrl = String.fromEnvironment(
    'AUDIO_SAS_URL',
  );

  /// Whether a download URL has been provided for this build.
  static bool get isConfigured => audioContainerSasUrl.trim().isNotEmpty;
}
