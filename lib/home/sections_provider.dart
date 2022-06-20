import 'dart:convert';
import 'package:eradko/provider/app_url.dart';
import 'package:eradko/provider/models.dart';
import 'package:http/http.dart';


class SectionsAndSliders {


   getSliders()  async {
    List<OffersSlider> sliders = [];
    late Map slidersResponse = {} ;

    try {
      Response response = await get(
        Uri.parse(AppUrl.getSliders),
        headers: {'accept': 'application/json', 'X-CSRF-TOKEN': ''},
      );
      var body = json.decode(response.body)['data'];
      var decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var slider in body) {
          sliders.add(OffersSlider.formJson(slider));
        }
        sliders.sort((b, a) => a.priority.compareTo(b.priority));
        slidersResponse = {
          'status' : true,
          'sliders' : sliders,
        };
      } else {
        slidersResponse = {
          'status' : false,
          'error' : decoded,
        };
      }
    } catch (e) {
      slidersResponse = {
        'status' : false,
        'error' : 'تأكد من اتصالك',
      };
    }
    return slidersResponse ;
  }

  getSections({required String locale }) async {
    List<Section> sections = [];
    late Map sectionsResponse = {} ;

    try {
      Response response = await get(Uri.parse(AppUrl.sections), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      var decoded = json.decode(response.body);
      var body = json.decode(response.body)['data'];

      if (response.statusCode == 200) {
        for (var section in body) {
          sections.add(Section.formJson(section));
        }
        sectionsResponse = {
          'status' : true,
          'sections' : sections,
        };
      } else {
        sectionsResponse = {
          'status' : false,
          'error' : decoded,
        };
      }
    } catch (e) {
      sectionsResponse = {
        'status' : false,
        'error' : 'تأكد من اتصالك',
      };
    }
    return sectionsResponse;
  }


}