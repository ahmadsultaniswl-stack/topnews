import 'package:get_storage/get_storage.dart';

import '../../Utilities_Screen/Bookmark_Model/book_mark_model.dart';

class BookmarkService {
  final GetStorage _storage = GetStorage();
  final String _bookmarksKey = 'bookmarks';

  // Save a single bookmark
  Future<void> addBookmark(BookmarkModel bookmark) async {
    List<Map<String, dynamic>> bookmarks = _getBookmarksList();

    // Check if bookmark already exists
    bool exists = bookmarks.any((item) => item['url'] == bookmark.url);

    if (!exists) {
      bookmarks.add(bookmark.toJson());
      await _storage.write(_bookmarksKey, bookmarks);
    }
  }

  // Get all bookmarks
  List<BookmarkModel> getBookmarks() {
    List<Map<String, dynamic>> bookmarks = _getBookmarksList();
    return bookmarks.map((json) => BookmarkModel.fromJson(json)).toList();
  }

  // Remove a specific bookmark by URL
  Future<void> removeBookmark(String url) async {
    List<Map<String, dynamic>> bookmarks = _getBookmarksList();
    bookmarks.removeWhere((item) => item['url'] == url);
    await _storage.write(_bookmarksKey, bookmarks);
  }

  // Clear ALL bookmarks
  Future<void> clearAllBookmarks() async {
    await _storage.remove(_bookmarksKey);
    // Alternative approach:
    // await _storage.write(_bookmarksKey, []);
  }

  // Check if a bookmark exists
  bool isBookmarked(String url) {
    List<Map<String, dynamic>> bookmarks = _getBookmarksList();
    return bookmarks.any((item) => item['url'] == url);
  }

  // Get count of bookmarks
  int getBookmarksCount() {
    return _getBookmarksList().length;
  }

  // Private helper method to get bookmarks list
  List<Map<String, dynamic>> _getBookmarksList() {
    return _storage
            .read<List<dynamic>>(_bookmarksKey)
            ?.cast<Map<String, dynamic>>() ??
        [];
  }
}
