class TeacherRoomsDataState {
  List<dynamic>? data;
  List<dynamic>? initialData;

  List<dynamic> getRooms() => data ?? [];
  void setRooms({required List<dynamic> serverData}) => data = serverData;
  void reset() => data = initialData;
}

class TeacherRoomsSingleton extends TeacherRoomsDataState {
  static final TeacherRoomsSingleton _instance =
      TeacherRoomsSingleton._internal();

  factory TeacherRoomsSingleton() {
    return _instance;
  }

  TeacherRoomsSingleton._internal() {
    this.initialData = ["dummy Rooms 1", "DummyRooms2", "DummyRooms3"];
    this.data = initialData;
    print(data);
  }
}
