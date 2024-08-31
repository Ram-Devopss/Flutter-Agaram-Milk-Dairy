import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:flutter_calendar_carousel/classes/event.dart';

class ScrollableCleanCalendar extends StatelessWidget {
  final Map<DateTime, List<Event>> markedDates;

  ScrollableCleanCalendar({required this.markedDates});
  @override
  Widget build(BuildContext context) {
    // Convert the markedDates map to the required format

    DateTime current = DateTime.now();

    EventList<Event> markedDatesMap = EventList<Event>(
      events: markedDates.entries.fold<Map<DateTime, List<Event>>>({},
          (map, entry) {
        map[entry.key] = entry.value ?? [];
        return map;
      }),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: CalendarCarousel<Event>(
              // markedDatesMap: markedDatesMap,
              customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              ) {
                // Check if day is in subscription_dates
                if (markedDates.containsKey(day) &&
                    markedDates[day]!
                        .any((event) => event.title == 'Subscription Date')) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                }

                else if (isPrevMonthDay || (!isThisMonthDay && !isNextMonthDay)) {
                  return Container(
                    decoration: BoxDecoration(
                      color:Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Adjust the radius value as needed
                      border: Border.all(color: Colors.transparent), // Red border
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.transparent,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),                      ),
                    ),
                  );
                }

                // Check if day is today
                else if (isToday) {
                  return Container(
                    decoration: BoxDecoration(
                      color:(markedDates.containsKey(day) &&
                          markedDates[day]!
                              .any((event) => event.title == 'Subscription Date'))? Colors.blue[100] :Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)), // Adjust the radius value as needed
                      border: Border.all(color: Colors.red), // Red border
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),                      ),
                    ),
                  );
                }
// Check if day is in rejected_delivered
                // Check if day is in rejected_delivered
                else if (markedDates.containsKey(day) &&
                    markedDates[day]!
                        .any((event) => event.title == 'Rejected Delivered')) {
                  return Container(
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                }

                else if (markedDates.containsKey(day) &&
                    markedDates[day]!
                        .any((event) => event.title == 'Vacation Period')) {
                  return Container(
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                  );
                }

                else if (markedDates.containsKey(day) &&
                    markedDates[day]!
                        .any((event) => event.title == 'Delivered')) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.greenAccent[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Adjust font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),                      ),
                    ),
                  );
                }
// No decoration for other cases
                else {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }

              },
              onDayPressed: (DateTime date, List<Event> events) {
                print(date);
              },
            ),
          ),
        ),
      ),
    );
  }
}
