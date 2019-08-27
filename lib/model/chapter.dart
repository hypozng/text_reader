class Chapter {
  /// 标题
  String title;

  /// 章节号
  int number;

  /// 段落
  List<String> _paragraphs = [];

  Chapter({
    this.title,
    this.number = 1,
    List<String> paragraphs
  }) {
    this.paragraphs = paragraphs;
  }

  List<String> get paragraphs => _paragraphs;

  set paragraphs(List<String> paragraphs) {
    _paragraphs.clear();
    if (paragraphs == null || paragraphs.isEmpty) {
      return;
    }
    var list = <String>[];
    list.addAll(paragraphs);
    list.forEach((p) => p = p?.trim() ?? "");
    list.removeWhere((p) => p?.isNotEmpty != true);
    _paragraphs.addAll(list);
  }


}