class User {
  String userId;
  String userName;
  bool mic;
  String streamId;
  bool speaker;
  int micLocation;
  bool lock;

  User(
      {this.userId,
      this.userName,
      this.mic = true,
      this.streamId,
      this.speaker,
      this.lock = false,
      this.micLocation});

  void clearData() {
    userId = null;
    userName = null;
    streamId = null;
    micLocation = 0;
  }

  @override
  String toString() {
    return "userId($userId) userName($userName) mic($mic) streamId($streamId) speaker($speaker) lock($lock) micLocation($micLocation)";
  }
}
