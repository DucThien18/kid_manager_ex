class MapConfig{
  final bool showChildrenPicker;
  final bool showSearch;
  final bool allowRouteSearch;
  final bool allowChat;

  const MapConfig({
    required this.showChildrenPicker,
    required this.showSearch,
    required this.allowRouteSearch,
    required this.allowChat,
});

  factory MapConfig.parent() => const MapConfig(
      showChildrenPicker: true,
      showSearch: true,
      allowRouteSearch: true,
      allowChat: true);


  factory MapConfig.child() => const MapConfig(
    showChildrenPicker: false,
    showSearch: false,
    allowRouteSearch: false,
    allowChat: false,
  );


}