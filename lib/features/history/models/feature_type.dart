enum FeatureType {
  detector,
  analyzer;

  static FeatureType fromKey(String key) {
    return FeatureType.values.firstWhere(
      (type) => type.name == key,
      orElse: () => FeatureType.detector,
    );
  }
}
