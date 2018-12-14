class User {
  String userId;
  String userName;
  bool mic;
  String streamId;
  bool speaker;
  int micLocation;

  User(
      {this.userId,
      this.userName,
      this.mic,
      this.streamId,
      this.speaker,
      this.micLocation});

  @override
  String toString() {
    return "userId($userId) userName($userName) mic($mic) streamId($streamId) speaker($speaker) micLocation($micLocation)";
  }
}
