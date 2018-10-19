part of flutter_aws_rest;

class Content {
  final String key;
  final DateTime lastModified;
  final String etag;
  final int size;
  final User owner;
  final String storageClass;

  Content(this.key, this.lastModified, this.etag, this.size, this.owner,
      this.storageClass);

  factory Content.fromElement(xml.XmlElement contentElem) {
    final keyElem = contentElem.findElements('Key').first;
    final lastModifiedElem = contentElem.findElements('LastModified').first;
    final etagElem = contentElem.findElements('ETag').first;
    final sizeElem = contentElem.findElements('Size').first;
    final ownerElem = contentElem.findElements('Owner').first;
    final storageClassElem = contentElem.findElements('StorageClass').first;
    final owner = new User.fromElement(ownerElem);
    final lastModified = DateTime.parse(lastModifiedElem.text);
    final size = int.parse(sizeElem.text);
    return new Content(keyElem.text, lastModified, etagElem.text, size, owner,
        storageClassElem.text);
  }
}
