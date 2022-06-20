import 'package:flutter/cupertino.dart';

class TopLayerWidget  extends StatelessWidget {
  final Widget topWidget ;
  const TopLayerWidget({Key? key, required this.topWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return topWidget;
  }
}
