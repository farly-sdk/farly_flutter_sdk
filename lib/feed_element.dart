class Action {
  final String id;
  final int amount;
  final String? text;
  final String? html;

  Action({
    required this.id,
    required this.amount,
    required this.text,
    required this.html,
  });

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      id: json['id'] as String,
      amount: json['amount'] as int,
      text: json['text'] as String?,
      html: json['html'] as String?,
    );
  }
}

class FeedElement {
  final String id;
  final String name;
  final String? devName;
  final String link;
  final String? icon;
  final String? smallDescription;
  final String? smallDescriptionHTML;
  final List<Action> actions;

  FeedElement({
    required this.id,
    required this.name,
    required this.devName,
    required this.link,
    required this.icon,
    required this.smallDescription,
    required this.smallDescriptionHTML,
    required this.actions,
  });

  factory FeedElement.fromJson(Map<String, dynamic> json) {
    final actionsJson = json['actions'] as List<dynamic>;
    final actions =
        actionsJson.map((actionJson) => Action.fromJson(actionJson)).toList();
    return FeedElement(
      id: json['id'] as String,
      name: json['name'] as String,
      devName: json['devName'] as String?,
      link: json['link'] as String,
      icon: json['icon'] as String?,
      smallDescription: json['smallDescription'] as String?,
      smallDescriptionHTML: json['smallDescriptionHTML'] as String?,
      actions: actions,
    );
  }
}
