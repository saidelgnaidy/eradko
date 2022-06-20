import 'package:eradko/const.dart';
import 'package:eradko/profile/notify/notifications_provider.dart';
import 'package:eradko/profile/notify/notify_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class NotificationsView   extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late ScrollController _scrollController;
  int page = 1 ;
  int totalPage = 1 ;
  bool loadMore = false ;
  List<MyNotification> notifications = [];
  final NotificationsProvider _notificationsProvider = NotificationsProvider( );


  fitchNot(){
    _notificationsProvider.getNotifications(locale: Lang.of(context).localeName , page: '').then((value) {
      if(mounted){
        setState(() {
          notifications = value['notifications'] ;
          totalPage = value['totalPages'] ;
        });
      }
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async =>fitchNot() );
    _scrollController.addListener(() async {
      var currentScroll = _scrollController.position.pixels ;
      var maxScroll = _scrollController.position.maxScrollExtent ;
      if(maxScroll - currentScroll == 0 && page < totalPage ){
        setState(() => loadMore = true );
        page++;
        _notificationsProvider.getNotifications(locale: Lang.of(context).localeName , page: page.toString()).then((value) {
            setState(() {
              notifications = value['notifications'] ;
              totalPage = value['totalPages'] ;
              setState(() => loadMore = false );

            });

        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final NotificationsProvider notify = Provider.of<NotificationsProvider>(context);

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: notifications.length,
          itemBuilder: (context , index) {
            return ExpansionTile(
              trailing: Text(notifications[index].time ,
                style: GoogleFonts.roboto(
                  color: accentDeActive,
                  fontWeight: FontWeight.bold ,
                  fontSize: 11,
                ),
              ),
              leading:notifications[index].seen == 0?   const Icon(Icons.notifications,color: Colors.red,):const SizedBox(),
              onExpansionChanged: (flag){
                if(notifications[index].seen == 0) {
                  notify.markSeen(id: notify.notifications[index].id);
                }
              },
              title:  Text( notifications[index].type == 'orders' ? Lang.of(context).myOrders : notifications[index].type ,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold ,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text( notifications[index].body ,
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold ,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ) ;
          },
        ),
        loadMore ?
        Positioned(
          bottom: 35,
          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(accentColor),),),
        ):const SizedBox(),
      ],
    );
  }
}
