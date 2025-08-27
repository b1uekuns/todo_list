import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';
import 'package:todolist/app/product/models/todo_model.dart';
import '../../core/utils/date_utils.dart';

class CalendarController extends GetxController {
  static CalendarController get to => Get.find<CalendarController>();

  final TodoController todoController = Get.find<TodoController>();

  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].obs;
  final dates = <DateTime>[].obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    generateWeekDates();
  }

  void generateWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    dates.value = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
    selectedIndex.value = now.weekday - 1;
  }

  void goToPreviousWeek() {
    final currentWeek = dates[0].subtract(Duration(days: 7));
    final monday = currentWeek.subtract(
      Duration(days: currentWeek.weekday - 1),
    );
    dates.value = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
    selectedIndex.value = 0;
  }

  void goToNextWeek() {
    final currentWeek = dates[0].add(Duration(days: 7));
    final monday = currentWeek.subtract(
      Duration(days: currentWeek.weekday - 1),
    );
    dates.value = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
    selectedIndex.value = 0;
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void selectDate(int index) {
    selectedIndex.value = index;
  }

  List<Todo> get todosForSelectedDate {
    return todoController.getTodosForDate(dates[selectedIndex.value]);
  }

  DateTime get selectedDate => dates[selectedIndex.value];

  String get selectedDateText {
    final date = selectedDate;
    return '${AppDateUtils.getWeekdayName(date)}, ${date.day} ${AppDateUtils.getMonthName(date)} ${date.year}';
  }
}
