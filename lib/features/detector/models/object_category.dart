import 'dart:ui';

enum ObjectCategory {
  people(Color(0xFFE53935)),
  vehicles(Color(0xFF1E88E5)),
  animals(Color(0xFF2E9B47)),
  food(Color(0xFFEF6C00)),
  furniture(Color(0xFF8E24AA)),
  electronics(Color(0xFF00897B)),
  sports(Color(0xFFD81B60)),
  other(Color(0xFF546E7A));

  const ObjectCategory(this.color);

  final Color color;

  static const _vehicles = {
    'bicycle', 'car', 'motorcycle', 'airplane', 'bus', 'train', 'truck', 'boat',
    'traffic light', 'fire hydrant', 'stop sign', 'parking meter',
  };

  static const _animals = {
    'bird', 'cat', 'dog', 'horse', 'sheep', 'cow', 'elephant', 'bear', 'zebra',
    'giraffe', 'teddy bear',
  };

  static const _food = {
    'banana', 'apple', 'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog',
    'pizza', 'donut', 'cake', 'bottle', 'wine glass', 'cup', 'fork', 'knife',
    'spoon', 'bowl',
  };

  static const _furniture = {
    'bench', 'chair', 'couch', 'potted plant', 'bed', 'dining table', 'toilet',
    'sink', 'vase', 'clock', 'book', 'scissors', 'toothbrush', 'hair drier',
  };

  static const _electronics = {
    'tv', 'laptop', 'mouse', 'remote', 'keyboard', 'cell phone', 'microwave',
    'oven', 'toaster', 'refrigerator',
  };

  static const _sports = {
    'frisbee', 'skis', 'snowboard', 'sports ball', 'kite', 'baseball bat',
    'baseball glove', 'skateboard', 'surfboard', 'tennis racket', 'backpack',
    'umbrella', 'handbag', 'tie', 'suitcase',
  };

  static ObjectCategory of(String label) {
    if (label == 'person') return ObjectCategory.people;
    if (_vehicles.contains(label)) return ObjectCategory.vehicles;
    if (_animals.contains(label)) return ObjectCategory.animals;
    if (_food.contains(label)) return ObjectCategory.food;
    if (_furniture.contains(label)) return ObjectCategory.furniture;
    if (_electronics.contains(label)) return ObjectCategory.electronics;
    if (_sports.contains(label)) return ObjectCategory.sports;
    return ObjectCategory.other;
  }
}
