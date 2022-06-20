import 'dart:convert';
import 'package:eradko/provider/app_url.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class MediaProvider {
  getArticles({String? categoryId, String? subCategoryId, String? typeId, String? page, required String locale}) async {
    List<Article> articlesList = [];
    late Map articlesListMap = {};

    String endPoint =
        'category_id=$categoryId${page == null ? '' : '&page=$page'}${subCategoryId == null ? '' : '&sub_category_id=$subCategoryId'}${typeId == null ? '' : '&type_id=$typeId'}';
    try {
      Response response = await get(Uri.parse(AppUrl.getPosts + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        var articles = json.decode(response.body)['data'];
        var pages = json.decode(response.body)['meta']['last_page'];
        for (var article in articles) {
          articlesList.add(Article.fromJson(article));
        }
        articlesListMap = {'status': true, 'articles': articlesList, 'pages': pages};
      } else {
        articlesListMap = {
          'status': false,
          'error': response.body,
        };
        if (kDebugMode) {
          print('all articles error :  ${response.body}');
        }
      }
    } catch (e) {
      articlesListMap = {
        'status': false,
        'error': 'تـأكد من أتصالك',
      };
      if (kDebugMode) {
        print('all articles error :  $e');
      }
    }
    return articlesListMap;
  }

  Future<Article> getArticleDetails({required int id, required String locale}) async {
    Article article = Article(id: 0, title: 'title', image: 'image', description: 'description', date: 'date');
    try {
      Response response = await get(Uri.parse('${AppUrl.getPostsId}/$id'), headers: {
        'accept': 'application/json',
        'locale': locale,
      });

      var postData = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        article = Article.fromJson(postData);
      } else {
        return article;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Posts error :  $e');
      }
    }
    return article;
  }

  getReleases({String? categoryId, String? subCategoryId, String? typeId, String? page, required String locale}) async {
    List<Releases> releasesList = [];
    late Map releasesListMap = {};

    String endPoint =
        'category_id=$categoryId${page == null ? '' : '&page=$page'}${subCategoryId == null ? '' : '&sub_category_id=$subCategoryId'}${typeId == null ? '' : '&type_id=$typeId'}';
    try {
      Response response = await get(Uri.parse(AppUrl.getReleases + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        var releases = json.decode(response.body)['data'];
        var pages = json.decode(response.body)['meta']['last_page'];
        for (var release in releases) {
          releasesList.add(Releases.fromJson(release));
        }
        releasesListMap = {'status': true, 'releases': releasesList, 'pages': pages};
      } else {
        releasesListMap = {
          'status': false,
          'error': response.body,
        };
        if (kDebugMode) {
          print('releases error :  ${response.body}');
        }
      }
    } catch (e) {
      releasesListMap = {
        'status': false,
        'error': 'تـأكد من أتصالك',
      };
      if (kDebugMode) {
        print('releases error :  $e');
      }
    }
    return releasesListMap;
  }

  Future<Releases> getReleasesDetails({required int id, required String locale}) async {
    Releases releases = Releases(id: 0, title: 'title', image: 'image', properties: ['properties'], attachment: 'attachment');
    try {
      Response response = await get(Uri.parse('${AppUrl.getReleasesDetails}/$id'), headers: {
        'accept': 'application/json',
        'locale': locale,
      });

      var postData = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        releases = Releases.fromJson(postData);
      } else {
        return releases;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Posts error :  $e');
      }
    }
    return releases;
  }

  getVideos({String? categoryId, String? subCategoryId, String? typeId, String? page, required String locale}) async {
    List<MediaVideo> videosList = [];
    late Map videosListMap = {};

    String endPoint =
        'category_id=$categoryId${page == null ? '' : '&page=$page'}${subCategoryId == null ? '' : '&sub_category_id=$subCategoryId'}${typeId == null ? '' : '&type_id=$typeId'}';
    try {
      Response response = await get(Uri.parse(AppUrl.getVideos + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        var gallery = json.decode(response.body)['data'];
        var pages = json.decode(response.body)['meta']['last_page'];
        for (var photo in gallery) {
          videosList.add(MediaVideo.fromJson(photo));
        }
        videosListMap = {'status': true, 'videos': videosList, 'pages': pages};
      } else {
        videosListMap = {
          'status': false,
          'error': response.body,
        };
        if (kDebugMode) {
          print('videos error :  ${response.body}');
        }
      }
    } catch (e) {
      videosListMap = {
        'status': false,
        'error': 'تـأكد من أتصالك',
      };
      if (kDebugMode) {
        print('videos error :  $e');
      }
    }
    return videosListMap;
  }

  getGallery({String? categoryId, String? subCategoryId, String? typeId, String? page, required String locale}) async {
    List<MediaPhoto> galleryList = [];
    late Map galleryListMap = {};

    String endPoint =
        'category_id=$categoryId${page == null ? '' : '&page=$page'}${subCategoryId == null ? '' : '&sub_category_id=$subCategoryId'}${typeId == null ? '' : '&type_id=$typeId'}';
    try {
      Response response = await get(Uri.parse(AppUrl.getGallery + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        var gallery = json.decode(response.body)['data'];
        var pages = json.decode(response.body)['meta']['last_page'];
        for (var photo in gallery) {
          galleryList.add(MediaPhoto.fromJson(photo));
        }
        galleryListMap = {'status': true, 'gallery': galleryList, 'pages': pages};
      } else {
        galleryListMap = {
          'status': false,
          'error': response.body,
        };
        if (kDebugMode) {
          print('photos error :  ${response.body}');
        }
      }
    } catch (e) {
      galleryListMap = {
        'status': false,
        'error': 'تـأكد من أتصالك',
      };
      if (kDebugMode) {
        print('photos error :  $e');
      }
    }
    return galleryListMap;
  }

  Future<Gallery> getGalleryDetails({required int id, required String locale}) async {
    Gallery gallery = Gallery(
      id: 0,
      image: 'image',
      images: [],
      name: '',
    );
    try {
      Response response = await get(Uri.parse('${AppUrl.getGalleryDetails}$id'), headers: {
        'accept': 'application/json',
        'locale': locale,
      });

      var decoded = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        gallery = Gallery.fromJson(decoded);
      } else {
        return gallery;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Posts error :  $e');
      }
    }
    return gallery;
  }
}
