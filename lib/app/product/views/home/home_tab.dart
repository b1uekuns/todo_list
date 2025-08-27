import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              //backgroundImage: AssetImage('assets/logo.png'),
              backgroundColor: Colors.blue,
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, user 👋',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your daily adventure starts now',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.grid_view),
              color: Theme.of(context).iconTheme.color,
              iconSize: 30,
              onPressed: () {
                // 
              },
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusSummaryCards(context),
              _buildRecentTask(context),
              _buildRecentTasksSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSummaryCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildStatusCard(
          context: context,
          color: Color(0xFF4F8CFF),
          icon: Icons.sync,
          title: 'On going',
          count: 24,
        ),
        _buildStatusCard(
          context: context,
          color: Color(0xFFFFC94F),
          icon: Icons.access_time,
          title: 'In Process',
          count: 12,
        ),
        _buildStatusCard(
          context: context,
          color: Color(0xFF4FD1C5),
          icon: Icons.check_circle,
          title: 'Completed',
          count: 42,
        ),
        _buildStatusCard(
          context: context,
          color: Color(0xFFFF6B6B),
          icon: Icons.cancel,
          title: 'Canceled',
          count: 8,
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String title,
    required int count,
  }) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$count Tasks',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTask(BuildContext context) {
    return Text(
      'Recent Task ',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.headlineSmall?.color,
      ),
    );
  }

  Widget _buildRecentTasksSection(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildTaskCard(
            context: context,
            title: 'Website for Rune.io',
            subtitle: 'Digital Product Design',
            tasks: 12,
            percent: 0.4,
            color: Colors.redAccent,
          ),
          _buildTaskCard(
            context: context,
            title: 'Dashboard for ProSavvy',
            subtitle: 'Digital Product Design',
            tasks: 12,
            percent: 0.75,
            color: Colors.cyan,
          ),
          _buildTaskCard(
            context: context,
            title: 'Mobile Apps for Track.id',
            subtitle: 'Digital Product Design',
            tasks: 12,
            percent: 0.5,
            color: Colors.orange,
          ),
          _buildTaskCard(
            context: context,
            title: 'Website for CourierGo.com',
            subtitle: 'Digital Product Design',
            tasks: 12,
            percent: 0.4,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int tasks,
    required double percent,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_sharp,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.6),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '$tasks Tasks',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 5,
                  backgroundColor: Theme.of(
                    context,
                  ).dividerColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${(percent * 100).round()}%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
