import 'package:flutter/widgets.dart';

typedef SAElementWalker = bool Function(Element child, Element? parent);

class SAElementUtil {
  static void walk(BuildContext? context, SAElementWalker walker) {
    if (context == null) {
      return;
    }
    context.visitChildElements((element) {
      if (walker(element, null)) {
        walkElement(element, walker);
      }
    });
  }

  static void walkElement(Element element, SAElementWalker walker) {
    element.visitChildren((child) {
      if (walker(child, element)) {
        walkElement(child, walker);
      }
    });
  }

  //find title
  static String? findTitle(Element element) {
    String? title;
    walkElement(element, (child, _) {
      if (child.widget is NavigationToolbar) {
        NavigationToolbar toolBar = child.widget as NavigationToolbar;
        if (toolBar.middle == null) {
          return false;
        }
        
        if (toolBar.middle is Text) {
          title = (toolBar.middle as Text).data;
          return false;
        }

        int layoutIndex = 0;
        if (toolBar.leading != null) {
          layoutIndex += 1;
        }
        title = findTextsInMiddle(child, layoutIndex);
        return false;
      }
      return true;
    });
    return title;
  }
  static String? findTextsInMiddle(Element element, int layoutIndex) {
    String? text;
    int index = 0;
    walkElement(element, ((child, _) {
      if (child.widget is LayoutId) {
        if (index == layoutIndex) {
          text = findTexts(child).join('');
          return false;
        }
        index += 1;
      }
      return true;
    }));
    return text;
  }

  static List<String> findTexts(Element element) {
    List<String> list = [];
    walkElement(element, ((child, _) {
      if (child.widget is Text) {
        String? text = (child.widget as Text).data;
        if (text != null) {
          list.add(text);
        }
        return false;
      }
      return true;
    }));
    return list;
  }

  static Element? findAncestorElementOfWidgetType<T extends Widget>(Element? element) {
    if (element == null) {
      return null;
    }

    Element? target;
    element.visitAncestorElements((parent) {
      if (parent.widget is T) {
        target = parent;
        return false;
      }
      return true;
    });
    return target;
  }
}