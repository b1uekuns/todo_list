import 'package:flutter/material.dart';

class AlertTab extends StatelessWidget {
  const AlertTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alerts & Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Alert List
            Expanded(
              child: ListView(
                children: [
                  _buildAlertCard(
                    context: context,
                    title: 'Task Deadline',
                    subtitle: 'Website for Rune.io is due tomorrow',
                    time: '2 hours ago',
                    icon: Icons.schedule,
                    color: Colors.orange,
                  ),
                  _buildAlertCard(
                    context: context,
                    title: 'Team Meeting',
                    subtitle: 'Designer and Developer meeting in 30 minutes',
                    time: '30 minutes ago',
                    icon: Icons.group,
                    color: Colors.blue,
                  ),
                  _buildAlertCard(
                    context: context,
                    title: 'Task Completed',
                    subtitle: 'Mobile Apps for Track.id has been completed',
                    time: '1 day ago',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  _buildAlertCard(
                    context: context,
                    title: 'New Task Assigned',
                    subtitle:
                        'Optimize Homepage Design has been assigned to you',
                    time: '2 days ago',
                    icon: Icons.assignment,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
