//class used to store the path of the element for visualization
import 'package:flutter/material.dart';

class SAElementPath {
  SAElementPath._(this._element);
  factory SAElementPath.createFrom({
    required Element element,
    required Element pageElement,
  }) {
    SAElementPath path = SAElementPath._(element);
    path._element = element;
    bool searchTarget = true;
    element.visitAncestorElements((parent) {
      if (parent.widget is GestureDetector) {
        searchTarget = false;
      }
      if (searchTarget && _SAPathConstants.levelSet.contains(parent.widget.runtimeType)) {
        path._element = parent;
      }
      if (parent == pageElement) {
        return false;
      }
      return true;
    });
    return path;
  }
  Element _element;
  Element get element => _element;
}

class _SAPathConstants {
  static final Set<Type> levelSet = {
    IconButton,
    TextButton,
    InkWell,
    ElevatedButton,
    ListTile,
  };
}