import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification/notificationApi.dart';
import 'package:flutter_notification/notificationPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    // TODO: implement initState
    NotificationAPI.init(initSchedule: true);
   // NotificationAPI.initTzTime();
    listenNotification();
  }

  void listenNotification()=>NotificationAPI.onNotification.stream.listen(notificationClicked);

  void notificationClicked(String? payload){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPage(payload:payload)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Flutter Notification"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              callback: (){
                NotificationAPI.showNotification(
                  title: "Rejoan abs",
                  body: "This is the first notification",
                  payload: "Rejoan.abs"
                );
              },
              iconData: Icon(Icons.notifications,color: Colors.black),
              labelText: Text("Local Notification",style: TextStyle(color: Colors.black),),
            ),
            ButtonWidget(
              callback: (){
                NotificationAPI.showScheduleNotification(
                    title: "Dinner Time",
                    body: "Today is 6 pm",
                    payload: "dinner at 6",
                  scheduleTime: DateTime.now().add(Duration(seconds: 5))
                );

                print("Notification start at 5 sec");
              },
              iconData: Icon(Icons.notifications_active,color: Colors.black),
              labelText: Text("Schedule Notification",style: TextStyle(color: Colors.black),),
            ),
            ButtonWidget(
              callback: (){
                NotificationAPI.showScheduleDailyNotification(
                    title: "Dinner Time",
                    body: "Today is 6 pm",
                    payload: "dinner at 6",
                    scheduleTime: DateTime.now().add(Duration(seconds: 5))
                );

                print("Notification start at 5 sec");
              },
              iconData: Icon(Icons.calendar_today,color: Colors.black),
              labelText: Text("Schedule Daily Notification",style: TextStyle(color: Colors.black),),
            ),
            ButtonWidget(
              callback: (){

              },
              iconData: Icon(Icons.delete_forever,color: Colors.black),
              labelText: Text("Remove Notification",style: TextStyle(color: Colors.black),),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {

  VoidCallback? callback;
  Widget? iconData;
  Widget? labelText;

  ButtonWidget({this.callback,this.iconData,this.labelText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed:callback,
        icon: iconData!,
        label: labelText!,
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          onPrimary: Colors.grey
        ));
  }
}
