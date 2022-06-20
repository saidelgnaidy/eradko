import 'package:eradko/cart/cart.dart';
import 'package:eradko/favorites/favorite.dart';
import 'package:eradko/home/home_view.dart';
import 'package:eradko/media/media.dart';
import 'package:eradko/profile/profile_landding.dart';
import 'package:flutter/cupertino.dart';

class Routs {
  static Widget cart = const Cart();
  static Widget favorite = const Favorite();
  static Widget home = const HomeScreen();
  static Widget personal = const ProfileLanding();
  static Widget media = const MediaLanding();

}