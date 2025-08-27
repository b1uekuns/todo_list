import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/calendar_controller.dart';
import 'package:todolist/app/product/controllers/todo_controller.dart';
import 'package:todolist/app/product/models/todo_model.dart';

class CalendarTab extends GetView<CalendarController> {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildWeekCalendar(context),
            SizedBox(height: 24),
            Expanded(child: _buildTodoList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          controller.selectedDateText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: controller.goToPreviousWeek,
          icon: Icon(Icons.chevron_left, size: 24),
        ),
        Expanded(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isSelected = i == controller.selectedIndex.value;
                final isToday = controller.isToday(controller.dates[i]);
                return GestureDetector(
                  onTap: () => controller.selectDate(i),
                  child: Column(
                    children: [
                      Text(controller.days[i], style: TextStyle(fontSize: 13)),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : isToday
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          controller.dates[i].day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isToday
                                ? Colors.orange
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        IconButton(
          onPressed: controller.goToNextWeek,
          icon: Icon(Icons.chevron_right, size: 24),
        ),
      ],
    );
  }

  Widget _buildTodoList() {
    return Obx(() {
      final todos = controller.todosForSelectedDate;

      if (todos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tasks for this day',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, idx) {
          final todo = todos[idx];
          return _buildTodoCard(context, todo);
        },
      );
    });
  }

  Widget _buildTodoCard(BuildContext context, Todo todo) {
    final TodoController todoController = Get.find<TodoController>();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  todo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: todo.done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) =>
                    todoController.handleMenuAction(value, todo),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'status', child: Text('Change Status')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                child: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
          if (todo.description.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              todo.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: todo.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: todo.status.color),
                ),
                child: Text(
                  todo.status.displayName,
                  style: TextStyle(
                    color: todo.status.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
