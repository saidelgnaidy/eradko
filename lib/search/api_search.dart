import 'package:eradko/search/search_model.dart';
import 'package:http/http.dart';
import 'package:eradko/provider/app_url.dart';

class FetchSearchList {

 static final RegExp charEN = RegExp('[a-zA-Z]');

 Future<SearchResultMap> getSearchList({required String query, required String locale}) async {
    late SearchResultMap results ;

    try {
      Response response = await get(Uri.parse(AppUrl.searchList+query), headers: {
        'accept': 'application/json',
        'locale': charEN.hasMatch(query) ? 'en' : 'ar' ,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        results  = SearchResultMap(state: true, searchResult: searchResultFromJson(response.body), error: '',)  ;
      } else {
        results  = SearchResultMap(state: false, searchResult: searchResultFromJson(response.body), error: 'تأكد من اتصالك',)  ;
      }
    }catch (e) {
      results  = SearchResultMap(state: false, searchResult: null, error: 'حدثت مشكلة .. تأكد من اتصالك',)  ;
    }
    return results;
  }
}

