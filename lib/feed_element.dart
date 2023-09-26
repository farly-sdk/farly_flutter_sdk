class Action {
  final String id;
  final int amount;
  final String text;
  final String html;

  Action({
    required this.id,
    required this.amount,
    required this.text,
    required this.html,
  });
}

class FeedElement {
  final String id;
  final String name;
  final String devName;
  final String link;
  final String icon;
  final String smallDescription;
  final String smallDescriptionHTML;
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
}
