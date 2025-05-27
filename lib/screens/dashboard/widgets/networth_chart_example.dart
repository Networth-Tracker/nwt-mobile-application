import 'package:flutter/material.dart';
import 'package:nwt_app/screens/dashboard/data/networth_chart_dummy_data.dart';
import 'package:nwt_app/screens/dashboard/widgets/networth_chart.dart';

class NetworthChartExample extends StatelessWidget {
  const NetworthChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Get data from our dummy data helper
    final currentProjection = NetworthChartDummyData.getCurrentProjection();
    final futureProjection = NetworthChartDummyData.getFutureProjection();
    final totalNetworth = NetworthChartDummyData.getTotalNetworth();
    final projectedNetworth = NetworthChartDummyData.getProjectedNetworth();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Networth Chart Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            const Text(
              'Your Networth Projection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current networth: ₹${(totalNetworth / 10000000).toStringAsFixed(2)} Cr',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            
            // The chart widget with our data
            NetworthChart(
              showProjection: true,
              currentNetworth: totalNetworth,
              projectedNetworth: projectedNetworth,
              currentprojection: currentProjection,
              futureprojection: futureProjection,
            ),
            
            const SizedBox(height: 24),
            
            // Additional information
            const Text(
              'About this projection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This chart shows your current networth history and projected future growth based on your current investment patterns and market conditions.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
