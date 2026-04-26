// lib/core/services/storage_service.dart

import 'dart:io';

class StorageService {
  // ── Upload a Single File (FAKE) ───────────────────────────────────────────────
  // Simulates a realistic upload with progress callbacks.
  // The file is never sent anywhere.

  Future<String> uploadFile({
    required File file,
    required String storagePath,
    void Function(double progress)? onProgress,
  }) async {
    // Simulate upload time based on file size (bigger file = slightly longer)
    final bytes = file.lengthSync();
    final simulatedDuration = _simulatedDuration(bytes);

    // Fire progress updates from 0.0 → 1.0
    if (onProgress != null) {
      const steps = 20;
      final stepDelay = simulatedDuration ~/ steps;

      for (int i = 1; i <= steps; i++) {
        await Future.delayed(Duration(milliseconds: stepDelay));
        onProgress(i / steps);
      }
    } else {
      await Future.delayed(Duration(milliseconds: simulatedDuration));
    }

    // Return a fake URL so the rest of the code doesn't break
    return 'https://fake-storage/$storagePath';
  }

  // ── Delete (FAKE) ─────────────────────────────────────────────────────────────

  Future<void> deleteFileByUrl(String downloadUrl) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> deleteFiles(List<String> downloadUrls) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> deleteNgoFolder(String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<String> replaceFile({
    required String oldDownloadUrl,
    required File newFile,
    required String storagePath,
    void Function(double progress)? onProgress,
  }) async {
    return uploadFile(
      file: newFile,
      storagePath: storagePath,
      onProgress: onProgress,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  int _simulatedDuration(int bytes) {
    // ~1s for small files, up to ~3s for 5MB — feels realistic
    const minMs = 800;
    const maxMs = 3000;
    const maxBytes = 5 * 1024 * 1024;
    final ratio = (bytes / maxBytes).clamp(0.0, 1.0);
    return minMs + ((maxMs - minMs) * ratio).toInt();
  }
}