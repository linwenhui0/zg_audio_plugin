class RoomMessage {
  String fromUserID;
  String fromUserName;
  String messageID;
  String content;
  int messageType;
  int messageCategory;
  int messagePriority;

  RoomMessage(
      {this.fromUserID,
      this.fromUserName,
      this.messageID,
      this.content,
      this.messageType,
      this.messageCategory,
      this.messagePriority});
}
