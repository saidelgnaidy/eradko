class AppUrl {
  static const String baseUrl =  'https://backend.eradco.murabba.dev/api';
  static const String login =  '$baseUrl/login';
  static const String register =  '$baseUrl/register';
  static const String sections = '$baseUrl/sections';
  static const String profileData = '$baseUrl/profile_data';
  static const String updateProfileData = '$baseUrl/user_profile';
  static const String updatePassword = '$baseUrl/update_password';
  static const String getAddresses = '$baseUrl/addresses';
  static const String updateAddress  ='$baseUrl/addresses/';
  static const String getSliders ='$baseUrl/sliders';
  static const String getProductDetails=  '$baseUrl/products';
  static const String getAllProduct= '$baseUrl/products?';
  static const String getMainCategory= '$baseUrl/sections';
  static const String getPosts= '$baseUrl/posts?';
  static const String getPostsId= '$baseUrl/posts';
  static const String getGallery= '$baseUrl/photos_galleries?';
  static const String getGalleryDetails= '$baseUrl/photos_galleries/';
  static const String getVideos= '$baseUrl/videos?';
  static const String getReleases= '$baseUrl/releases?';
  static const String getReleasesDetails= '$baseUrl/releases';
  static const String getBranches=  '$baseUrl/branches';
  static const String getRoles= '$baseUrl/user_roles';
  static const String getAllOffers= '$baseUrl/offers';
  static const String getOfferDetails= '$baseUrl/offers';
  static const String getCartData             = '$baseUrl/cart';
  static const String addToCart               = '$baseUrl/cart';
  static const String updateCartItemQuantity  = '$baseUrl/cart_items/';
  static const String deleteCartItem          = '$baseUrl/cart_items/';
  static const String searchList              = '$baseUrl/search?search=';
  static const String addToFavorite           = '$baseUrl/favorites';
  static const String getPages           = '$baseUrl/pages';
  static const String contactUs           = '$baseUrl/contact';
  static const String addEmailToSendCode      = '$baseUrl/password/email';
  static const String  resetCode              = '$baseUrl/password/reset';
  static const String  verifyResetCode              = '$baseUrl/verify_reset_code';
  static const String  paymentMethods    = '$baseUrl/payment_methods';
  static const String  orders    = '$baseUrl/orders';
  static const String  commercialRegister    = '$baseUrl/commercial_register';
  static const String  notifications    = '$baseUrl/system_notifications';
}
