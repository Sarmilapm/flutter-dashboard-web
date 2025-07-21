import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_data.dart';
import '../widgets/chart_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends StatelessWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF011638),
        title: const Text('Analytics Dashboard',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white,
                  title: const Text('Confirm Logout!',
                      style: TextStyle(
                          color: Color(0xFF011638),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  content: const Text('Are you sure you want to logout?',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                  actionsPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: Color(0xFF017CA3))),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF011638),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color(0xFFF8F9FB),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFilterCard(provider, context),
                  const SizedBox(height: 16),
                  Expanded(child: _buildChartGrid(provider.filteredData)),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterCard(DashboardProvider provider, BuildContext context) {
    final sites = provider.allData.map((e) => e.site).toSet().toList();
    final individuals = provider.selectedSite == null
        ? provider.allData.map((e) => e.individual).toSet().toList()
        : provider.allData
            .where((e) => e.site == provider.selectedSite)
            .map((e) => e.individual)
            .toSet()
            .toList();

    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            DropdownButton<String>(
              hint: const Text('Site'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Color(0xFF011638)),
              value: provider.selectedSite,
              items: sites
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: provider.setSite,
            ),
            DropdownButton<String>(
              hint: const Text('Individual'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Color(0xFF011638)),
              value: provider.selectedIndividual,
              items: individuals
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: provider.setIndividual,
            ),
            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: provider.selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  provider.setDate(picked);
                }
              },
              icon: const Icon(Icons.date_range, color: Color(0xFF011638)),
              label: Text(
                provider.selectedDate != null
                    ? "${provider.selectedDate!.year}-${provider.selectedDate!.month.toString().padLeft(2, '0')}-${provider.selectedDate!.day.toString().padLeft(2, '0')}"
                    : 'Pick Date',
                style: const TextStyle(color: Color(0xFF011638)),
              ),
            ),
            if (provider.selectedSite != null ||
                provider.selectedIndividual != null ||
                provider.selectedDate != null)
              TextButton.icon(
                onPressed: provider.clearFilters,
                icon: const Icon(Icons.clear, color: Colors.redAccent),
                label: const Text("Clear Filters",
                    style: TextStyle(color: Colors.redAccent)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartGrid(List<DashboardData> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return GridView.count(
          key: ValueKey(data.length),
          padding: const EdgeInsets.all(8),
          physics: const BouncingScrollPhysics(),
          crossAxisCount: isWide ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isWide ? 1.5 : 0.8,
          children: [
            ChartWidget(title: 'Parameter A vs Hour', data: data, isA: true),
            ChartWidget(title: 'Parameter B vs Hour', data: data, isA: false),
          ],
        );
      },
    );
  }
}
