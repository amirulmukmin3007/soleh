import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soleh/features/calendar/bloc/calendar_bloc.dart';
import 'package:soleh/features/calendar/models/islamic_date.dart';
import 'package:soleh/shared/component/appbar.dart';
import 'package:soleh/themes/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _events = {};
  bool _isYearView = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // _loadIslamicDates();
    context
        .read<CalendarBloc>()
        .add(LoadDataByYearEvent(year: _focusedDay.year, events: _events));
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(isYearView: _isYearView),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, listenerState) {},
        builder: (context, builderState) {
          if (builderState is CalendarLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (builderState is CalendarError) {
            return Center(
              child: Text(builderState.error),
            );
          }

          if (builderState is CalendarLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showIslamicDatesDialog(builderState.islamicDate),
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('View All Islamic Dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Show either year view or month view
                if (_isYearView)
                  Expanded(child: _buildYearView())
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                        CalendarFormat.twoWeeks: '2 Weeks',
                        CalendarFormat.week: 'Week',
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        }
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: _getEventsForDay,
                      calendarStyle: CalendarStyle(
                        // Today's date styling
                        todayDecoration: BoxDecoration(
                          color: ColorTheme.primary.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),

                        // Selected date styling
                        selectedDecoration: BoxDecoration(
                          color: ColorTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),

                        // Marker styling for events
                        markerDecoration: BoxDecoration(
                          color: ColorTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,

                        // Weekend styling
                        weekendTextStyle: TextStyle(
                          color: ColorTheme.primary.withValues(alpha: 0.7),
                        ),

                        // Outside month days
                        outsideDaysVisible: true,
                        outsideTextStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: ColorTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ColorTheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: ColorTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: ColorTheme.primary,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: ColorTheme.primary,
                        ),
                        titleTextStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorTheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),

                if (!_isYearView) const SizedBox(height: 16),

                // Events list for selected day (only show in month view)
                if (!_isYearView) ...[
                  Expanded(
                    child: _buildEventsList(),
                  ),
                  const SizedBox(height: 150),
                ],
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: ColorTheme.primary,
            ),
          );
        },
      ),
      floatingActionButton: !_isYearView
          ? FloatingActionButton(
              onPressed: () {
                _showAddEventDialog();
              },
              backgroundColor: ColorTheme.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildYearView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Year selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: ColorTheme.primary),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(_focusedDay.year - 1, _focusedDay.month);
                    });
                  },
                ),
                Text(
                  '${_focusedDay.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: ColorTheme.primary),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(_focusedDay.year + 1, _focusedDay.month);
                    });
                  },
                ),
              ],
            ),
          ),
          // Grid of months
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return _buildMonthCard(index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard(int month) {
    final monthDate = DateTime(_focusedDay.year, month, 1);
    final monthName = DateFormat('MMMM').format(monthDate);
    final daysInMonth = DateUtils.getDaysInMonth(_focusedDay.year, month);

    // Count events in this month
    int eventCount = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime.utc(_focusedDay.year, month, day);
      if (_events.containsKey(date) && _events[date]!.isNotEmpty) {
        eventCount += _events[date]!.length;
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          _focusedDay = DateTime(_focusedDay.year, month, 1);
          _selectedDay = DateTime(_focusedDay.year, month, 1);
          _isYearView = false;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: month == DateTime.now().month &&
                    _focusedDay.year == DateTime.now().year
                ? ColorTheme.primary
                : Colors.grey.shade200,
            width: month == DateTime.now().month &&
                    _focusedDay.year == DateTime.now().year
                ? 2
                : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              monthName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: month == DateTime.now().month &&
                        _focusedDay.year == DateTime.now().year
                    ? ColorTheme.primary
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            if (eventCount > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$eventCount event${eventCount > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    final events = _getEventsForDay(_selectedDay!);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No events for this day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: ColorTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              events[index],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddEventDialog() {
    final TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          controller: eventController,
          decoration: const InputDecoration(
            hintText: 'Enter event name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                setState(() {
                  final key = DateTime.utc(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                  );
                  if (_events[key] != null) {
                    _events[key]!.add(eventController.text);
                  } else {
                    _events[key] = [eventController.text];
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showIslamicDatesDialog(List<IslamicDate> islamicDate) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorTheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Islamic Dates',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // List of Islamic Dates
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: islamicDate.length,
                  itemBuilder: (context, index) {
                    final dateInfo = islamicDate[index];
                    final englishDate = DateFormat('MMMM dd, yyyy').format(
                      dateInfo.englishDate,
                    );
                    final hijrahDate = dateInfo.hijrahDate;
                    final occasion = dateInfo.occasion;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Navigate to that date on calendar
                          final date = dateInfo.englishDate;
                          setState(() {
                            _selectedDay = date;
                            _focusedDay = date;
                            _isYearView = false; // Switch to month view
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Occasion
                              Text(
                                occasion,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Hijrah Date
                              if (hijrahDate.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event,
                                      size: 16,
                                      color: ColorTheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      hijrahDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorTheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              // English Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    englishDate,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
