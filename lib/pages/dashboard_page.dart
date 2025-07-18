import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';
import '../services/csv_parser.dart';
import '../widgets/chart_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<DashboardData> allData = [];
  List<DashboardData> filteredData = [];

  String? selectedSite;
  String? selectedIndividual;
  DateTime? selectedDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final data = await CSVParser.loadDashboardData();
    print("Loaded rows: ${data.length}");
    final sites = data.map((e) => e.site).toSet().toList();
    final individuals = data.map((e) => e.individual).toSet().toList();
    print("Sites: ${sites.length} => $sites");
    print("Individuals: ${individuals.length} => $individuals");
    setState(() {
      allData = data;
      filteredData = data;
      isLoading = false;
    });
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _applyFilters() {
    setState(() {
      filteredData = allData.where((d) {
        final matchSite = selectedSite == null || d.site == selectedSite;
        final matchIndividual =
            selectedIndividual == null || d.individual == selectedIndividual;
        final matchDate =
            selectedDate == null || _isSameDate(d.date, selectedDate!);
        return matchSite && matchIndividual && matchDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Confirm Logout!'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildFilterCard(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildChartGrid()),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterCard() {
    final sites = allData.map((e) => e.site).toSet().toList();
    final individuals = allData.map((e) => e.individual).toSet().toList();

    return Card(
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
              value: selectedSite,
              items: sites
                  .map<DropdownMenuItem<String>>(
                    (s) => DropdownMenuItem<String>(value: s, child: Text(s)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSite = value;
                  _applyFilters();
                });
              },
            ),
            DropdownButton<String>(
              hint: const Text('Individual'),
              value: selectedIndividual,
              items: individuals
                  .map<DropdownMenuItem<String>>(
                    (i) => DropdownMenuItem<String>(value: i, child: Text(i)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedIndividual = value;
                  _applyFilters();
                });
              },
            ),
            TextButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    _applyFilters();
                  });
                }
              },
              icon: const Icon(Icons.date_range),
              label: Text(
                selectedDate != null
                    ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                    : 'Pick Date',
              ),
            ),
            if (selectedSite != null ||
                selectedIndividual != null ||
                selectedDate != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    selectedSite = null;
                    selectedIndividual = null;
                    selectedDate = null;
                    filteredData = allData;
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text("Clear Filters"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        return GridView.count(
          key: ValueKey(filteredData.length),
          crossAxisCount: isWide ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isWide ? 1.5 : 0.8,
          children: [
            ChartWidget(
              title: 'Parameter A vs Hour',
              data: filteredData,
              isA: true,
            ),
            ChartWidget(
              title: 'Parameter B vs Hour',
              data: filteredData,
              isA: false,
            ),
          ],
        );
      },
    );
  }
}
