import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

List<Event> getEventList(List<dynamic> list) {
  List<Event> result = [];
  list.forEach((it) {
    result.add(Event.fromJson(it));
  });
  return result;
}

@JsonSerializable()
class Event extends Object {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'actor')
  Actor actor;
  @JsonKey(name: 'repo')
  Repo repo;
  @JsonKey(name: 'payload')
  Payload payload;
  @JsonKey(name: 'public')
  bool public;
  @JsonKey(name: 'created_at')
  String createdAt;

  Event(
    this.id,
    this.type,
    this.actor,
    this.repo,
    this.payload,
    this.public,
    this.createdAt,
  );

  factory Event.fromJson(Map<String, dynamic> srcJson) =>
      _$EventFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable()
class Actor extends Object {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'login')
  String login;
  @JsonKey(name: 'display_login')
  String displayLogin;
  @JsonKey(name: 'gravatar_id')
  String gravatarId;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;

  Actor(
    this.id,
    this.login,
    this.displayLogin,
    this.gravatarId,
    this.url,
    this.avatarUrl,
  );

  factory Actor.fromJson(Map<String, dynamic> srcJson) =>
      _$ActorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ActorToJson(this);
}

@JsonSerializable()
class Repo extends Object {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'url')
  String url;

  Repo(
    this.id,
    this.name,
    this.url,
  );

  factory Repo.fromJson(Map<String, dynamic> srcJson) =>
      _$RepoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RepoToJson(this);
}

@JsonSerializable()
class Payload extends Object {
  @JsonKey(name: 'action')
  String action;

  Payload(
    this.action,
  );

  factory Payload.fromJson(Map<String, dynamic> srcJson) =>
      _$PayloadFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}
