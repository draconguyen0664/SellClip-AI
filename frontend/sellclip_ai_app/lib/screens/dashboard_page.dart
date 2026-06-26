import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sellclip_ai_app/components/navigation/sellclip_bottom_navigation.dart';
import 'package:sellclip_ai_app/models/service_status.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<ServiceStatus>> _statuses;
  SellClipTab _currentTab = SellClipTab.home;

  @override
  void initState() {
    super.initState();
    _statuses = fetchStatuses();
  }

  Future<List<ServiceStatus>> fetchStatuses() async {
    final services = <ServiceStatusRequest>[
      const ServiceStatusRequest('Auth', '/api/auth/health'),
      const ServiceStatusRequest('Clips', '/api/clips/health'),
      const ServiceStatusRequest('AI', '/api/ai/health'),
    ];

    return Future.wait(
      services.map((service) async {
        final uri = Uri.parse('$apiBaseUrl${service.path}');
        try {
          final response =
              await http.get(uri).timeout(const Duration(seconds: 5));
          if (response.statusCode != 200) {
            return ServiceStatus(
              service.name,
              'HTTP ${response.statusCode}',
              false,
            );
          }
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          return ServiceStatus(
            service.name,
            '${body['service'] ?? service.name}: ${body['status'] ?? 'UNKNOWN'}',
            true,
          );
        } catch (error) {
          return ServiceStatus(service.name, error.toString(), false);
        }
      }),
    );
  }

  void refresh() {
    setState(() {
      _statuses = fetchStatuses();
    });
  }

  void selectTab(SellClipTab tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SellClip AI'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<ServiceStatus>>(
            future: _statuses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final statuses = snapshot.data ?? const <ServiceStatus>[];
              return ListView(
                children: [
                  Text(
                    _tabTitle(_currentTab),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'API Gateway: $apiBaseUrl',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  ...statuses.map(
                    (status) => ServiceStatusTile(status: status),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: refresh,
                    icon: const Icon(Icons.sync),
                    label: const Text('Check services'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SellClipBottomNavigation(
        currentTab: _currentTab,
        onTabSelected: selectTab,
      ),
    );
  }

  String _tabTitle(SellClipTab tab) {
    return switch (tab) {
      SellClipTab.home => 'Home',
      SellClipTab.projects => 'Projects',
      SellClipTab.create => 'Create Clip',
      SellClipTab.templates => 'Templates',
      SellClipTab.profile => 'Profile',
    };
  }
}

class ServiceStatusTile extends StatelessWidget {
  const ServiceStatusTile({required this.status, super.key});

  final ServiceStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.isHealthy ? Colors.green : Colors.red;
    return Card(
      child: ListTile(
        leading: Icon(
          status.isHealthy ? Icons.check_circle : Icons.error,
          color: color,
        ),
        title: Text(status.name),
        subtitle: Text(status.message),
      ),
    );
  }
}
