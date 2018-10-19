part of flutter_aws_rest;

class User {
  final String id;
  //final String displayName;

  User(this.id);

  factory User.fromElement(xml.XmlElement ownerElem) {
    final idElem = ownerElem.findElements('ID').first;
    //final displayNameElem = ownerElem.findElements('DisplayName').first;
    return new User(idElem.text);
  }
}
