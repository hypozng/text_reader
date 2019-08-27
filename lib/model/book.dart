class Book {
  /// ID
  String id;

  /// 名称
  String name;

  /// 描述
  String description;

  /// 阅读到的章节号
  int chapterNumber;

  /// 阅读到的段落号
  int paragraphNumber;

  /// 网络地址
  String url;

  Book({
    this.name,
    this.description,
    this.chapterNumber,
    this.paragraphNumber,
    this.url
  });

  @override
  String toString() {
    return "《$name》";
  }
}