class FilterSettings {
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegetarian;
  final bool isVegan;

  const FilterSettings({
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.isVegetarian = false,
    this.isVegan = false,
  });

  FilterSettings copyWith({
    bool? isGlutenFree,
    bool? isLactoseFree,
    bool? isVegetarian,
    bool? isVegan,
  }) {
    return FilterSettings(
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
    );
  }

  bool get hasAny =>
      isGlutenFree || isLactoseFree || isVegetarian || isVegan;
}