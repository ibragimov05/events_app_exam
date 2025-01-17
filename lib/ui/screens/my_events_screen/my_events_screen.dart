import 'package:events_app_exam/ui/screens/my_events_screen/my_events.dart';
import 'package:events_app_exam/ui/screens/my_events_screen/get_events.dart';
import 'package:events_app_exam/ui/widgets/arrow_back_button.dart';
import 'package:events_app_exam/utils/app_constants.dart';
import 'package:events_app_exam/utils/app_router.dart';
import 'package:flutter/material.dart';

import '../../../data/models/event.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: const ArrowBackButton(),
          title: const Text('My events'),
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Near'),
              Tab(text: 'Participated'),
              Tab(text: 'Favorite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MyEvents(),
            GetEvents(
              isCanceled: false,
              eventFunction:
                  (List<Event> events, List<String> userParticipatingEvents) {
                List<Event> result = [];
                final DateTime now = DateTime.now();
                final DateTime sevenDaysFromNow =
                    now.add(const Duration(days: 7));
                for (Event event in events) {
                  if (userParticipatingEvents.contains(event.id) &&
                      event.startTime.toDate().isAfter(now) &&
                      event.startTime.toDate().isBefore(sevenDaysFromNow)) {
                    result.add(event);
                  }
                }
                return result;
              },
            ),
            GetEvents(
              isCanceled: false,
              eventFunction:
                  (List<Event> events, List<String> userParticipatingEvents) {
                List<Event> result = [];
                final DateTime now = DateTime.now();
                for (Event event in events) {
                  if (userParticipatingEvents.contains(event.id) &&
                      event.startTime.toDate().isBefore(now)) {
                    result.add(event);
                  }
                }
                return result;
              },
            ),
            GetEvents(
              isCanceled: true,
              eventFunction:
                  (List<Event> events, List<String> userParticipatingEvents) {
                List<Event> result = [];
                for (var each in events) {
                  if (AppConstants.userFavList.contains(each.id)) {
                    result.add(each);
                  }
                }

                return result;
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.addEvent);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
