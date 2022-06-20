import 'package:flutter/cupertino.dart';

class RoutsProvider extends ChangeNotifier{

  Widget _topWidget = const SizedBox();
  static const int _topWidgetIndex = 5 ;
  int _currentIndex = 0 ;
  int _previousIndex = 0 ;
  int _lastNavIndex = 0 ;

  Widget get topWidget => _topWidget ;
  int get currentIndex => _currentIndex ;
  int get topWidgetIndex => _topWidgetIndex ;
  int get previousIndex => _previousIndex ;
  int get lastNavIndex => _lastNavIndex ;

  topLayerSetter({required Widget widget , required int index ,required int previousIndex ,int ? navIndex }){
    _topWidget = widget ;
    _currentIndex = index ;
    _previousIndex = previousIndex ;
    _lastNavIndex = navIndex ?? _lastNavIndex ;
    notifyListeners();
  }

}