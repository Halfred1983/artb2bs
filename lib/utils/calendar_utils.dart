import 'package:artb2b/app/resources/theme.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../app/resources/styles.dart';
import '../widgets/calendar_loader.dart';

class CalendarUtils {
  static CalendarBuilders buildCalendarBuilders(bool isLoading, User host, [Map<DateTime, String> unavailableDatesSpaces = const {}, List<DateTime> unavailableDates = const [], bool showSpaces = true]) {
    return CalendarBuilders(
      selectedBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: ClipOval(
              child: Text(
                day.day.toString(),
              ),
            ),
          ),
        );
      },
      defaultBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
            ),
          ),
        );
      },
      outsideBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
            ),
          ),
        );
      },
      rangeEndBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      withinRangeBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
            ),
          ),
        );
      },
      rangeStartBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      disabledBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(), style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
          ),
        );
      },
      todayBuilder: (context, day, focusedDay) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              day.day.toString(),
            ),
          ),
        );
      },
      markerBuilder: (BuildContext context, date, events) {
        if(isLoading) {
          return const CalendarLoader();
        }
        if(showSpaces) {
          int freeSpaces = int.parse(host.venueInfo!.spaces!);


          for (Object? e in events) {
            Booking b = e as Booking;
            freeSpaces = freeSpaces - int.parse(b.spaces!);
          }

          unavailableDatesSpaces.forEach((day, spaces) {
            if (isSameDay(day, date)) {
              freeSpaces = freeSpaces - int.parse(spaces);
            }
          });
          return Container(
            margin: const EdgeInsets.only(top: 35),
            padding: const EdgeInsets.all(1),
            child: Text(
                freeSpaces.toString(), style: TextStyles.semiBoldN90012),
          );
        }

        if (unavailableDates.isNotEmpty) {
          for (var day in unavailableDates) {
            if (isSameDay(day, date)) {
              return Container(
                  height: 8,
                  width: 8,
                  margin: const EdgeInsets.only(bottom: 10),
                  // Adjust padding for better centering
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.d200, // Optional: Add a background color
                  )
              );
            }
          }
        }
      },
    );
  }
}