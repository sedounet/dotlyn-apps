import 'dart:async';
import 'package:flutter/material.dart';

/// Mixin for auto-save behavior with debouncing
/// 
/// Provides auto-save functionality with configurable delay.
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   @override
///   State<MyScreen> createState() => _MyScreenState();
/// }
/// 
/// class _MyScreenState extends State<MyScreen> with AutoSaveMixin {
///   @override
///   Duration get autoSaveDelay => const Duration(seconds: 2);
///   
///   @override
///   Future<void> performAutoSave(String content) async {
///     // Save your content here
///   }
///   
///   void onContentChanged(String newContent) {
///     scheduleAutoSave(newContent); // Triggers auto-save with debounce
///   }
/// }
/// ```
mixin AutoSaveMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;
  String? _pendingContent;

  /// Duration to wait before triggering auto-save
  /// Override in your state class to customize
  Duration get autoSaveDelay => const Duration(seconds: 2);

  /// Implement this method to perform the actual save operation
  /// Called automatically after the debounce delay
  Future<void> performAutoSave(String content);

  /// Check if there are unsaved changes
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  /// Schedule an auto-save with debounce
  /// Cancels previous timer and starts a new one
  void scheduleAutoSave(String content) {
    _pendingContent = content;
    _hasUnsavedChanges = true;
    
    // Cancel existing timer to restart debounce
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(autoSaveDelay, () async {
      if (_pendingContent != null) {
        await performAutoSave(_pendingContent!);
        _hasUnsavedChanges = false;
        _pendingContent = null;
      }
    });
  }

  /// Cancel any pending auto-save
  void cancelAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    _hasUnsavedChanges = false;
    _pendingContent = null;
  }

  /// Manually trigger save immediately (bypass debounce)
  Future<void> saveNow(String content) async {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    _pendingContent = null;
    
    await performAutoSave(content);
    _hasUnsavedChanges = false;
  }

  /// Clean up timer on dispose
  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    super.dispose();
  }
}
