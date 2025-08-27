import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/product/controllers/create_task_controller.dart';

class CreateTask extends GetView<CreateTaskController> {
  const CreateTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Tasks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildTaskTitle(),
            SizedBox(height: 12),
            _buildDateField(),
            SizedBox(height: 12),
            _buildDetailsField(),
            SizedBox(height: 16),
            _buildCategorySection(context),
            SizedBox(height: 18),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTitle() {
    return TextField(
      controller: controller.titleController,
      decoration: InputDecoration(
        hintText: 'Task Title',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: controller.dateController,
      decoration: InputDecoration(
        hintText: 'Select Date',
        prefixIcon: Icon(Icons.calendar_today),
        suffixIcon: Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      readOnly: true,
      onTap: controller.selectDate,
    );
  }

  Widget _buildDetailsField() {
    return TextField(
      controller: controller.detailsController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Add your task details',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.categories
                .map(
                  (cat) => ChoiceChip(
                    label: Text(cat),
                    selected: controller.selectedCategory.value == cat,
                    onSelected: (val) => controller.selectCategory(cat),
                    selectedColor: Colors.orange[200],
                    backgroundColor:
                        Theme.of(context).chipTheme.backgroundColor ??
                        Theme.of(context).colorScheme.surface,
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: controller.createTask,
        child: Text(
          'Create Task',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
