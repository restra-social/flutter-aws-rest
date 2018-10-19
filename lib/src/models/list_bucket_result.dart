part of flutter_aws_rest;

class ListBucketResult {
  final String name;
  final String prefix;
  final String marker;
  final int maxKeys;
  final bool isTruncated;
  final List<Content> contents;

  ListBucketResult(this.name, this.prefix, this.marker, this.maxKeys,
      this.isTruncated, this.contents);

  factory ListBucketResult.fromXml(String xmlString) {
    final parsed = xml.parse(xmlString);
    final rootElem = parsed.findElements('ListBucketResult').first;
    final nameElem = rootElem.findElements('Name').first;
    final prefixElem = rootElem.findElements('Prefix').first;
    final markerElem = rootElem.findElements('Marker').first;
    final maxKeysElem = rootElem.findElements('MaxKeys').first;
    final isTruncatedElem = rootElem.findElements('IsTruncated').first;
    final contentsElems = rootElem.findElements('Contents');
    final contents = contentsElems
        .map((content) => new Content.fromElement(content))
        .toList();
    final maxKeys = int.parse(maxKeysElem.text);
    final isTruncated = isTruncatedElem.text.toLowerCase() == 'true';
    return new ListBucketResult(nameElem.text, prefixElem.text, markerElem.text,
        maxKeys, isTruncated, contents);
  }
}
