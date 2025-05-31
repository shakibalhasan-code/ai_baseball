class DataPoint {
  final DateTime timestamp;
  final int value;

  DataPoint({
    required this.timestamp,
    required this.value,
  });

  factory DataPoint.fromJson(List<dynamic> json) {
    return DataPoint(
      timestamp: DateTime.parse(json[0]),
      value: json[1],
    );
  }

  List<dynamic> toJson() {
    return [
      timestamp.toIso8601String(),
      value,
    ];
  }
}

class SeriesData {
  final List<DataPoint> visualization;
  final List<DataPoint> consistency;
  final List<DataPoint> lifting;
  final List<DataPoint> recovery;
  final List<DataPoint> wellness;

  SeriesData({
    required this.visualization,
    required this.consistency,
    required this.lifting,
    required this.recovery,
    required this.wellness,
  });

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      visualization: (json['Visualization'] as List<dynamic>? ?? [])
          .map((item) => DataPoint.fromJson(item))
          .toList(),
      consistency: (json['Consistency'] as List<dynamic>? ?? [])
          .map((item) => DataPoint.fromJson(item))
          .toList(),
      lifting: (json['Lifting'] as List<dynamic>? ?? [])
          .map((item) => DataPoint.fromJson(item))
          .toList(),
      recovery: (json['Recovery'] as List<dynamic>? ?? [])
          .map((item) => DataPoint.fromJson(item))
          .toList(),
      wellness: (json['Wellness'] as List<dynamic>? ?? [])
          .map((item) => DataPoint.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Visualization': visualization.map((item) => item.toJson()).toList(),
      'Consistency': consistency.map((item) => item.toJson()).toList(),
      'Lifting': lifting.map((item) => item.toJson()).toList(),
      'Recovery': recovery.map((item) => item.toJson()).toList(),
      'Wellness': wellness.map((item) => item.toJson()).toList(),
    };
  }
}

class PowerRatings {
  final int visualization;
  final int consistency;
  final int lifting;
  final int recovery;
  final int wellness;

  PowerRatings({
    required this.visualization,
    required this.consistency,
    required this.lifting,
    required this.recovery,
    required this.wellness,
  });

  factory PowerRatings.fromJson(Map<String, dynamic> json) {
    return PowerRatings(
      visualization: json['Visualization'] ?? 0,
      consistency: json['Consistency'] ?? 0,
      lifting: json['Lifting'] ?? 0,
      recovery: json['Recovery'] ?? 0,
      wellness: json['Wellness'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Visualization': visualization,
      'Consistency': consistency,
      'Lifting': lifting,
      'Recovery': recovery,
      'Wellness': wellness,
    };
  }

  // Helper method to get rating by category name
  int getRatingByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'visualization':
        return visualization;
      case 'consistency':
        return consistency;
      case 'lifting':
        return lifting;
      case 'recovery':
        return recovery;
      case 'wellness':
        return wellness;
      default:
        return 0;
    }
  }

  // Helper method to get all ratings as a list
  List<int> getAllRatings() {
    return [visualization, consistency, lifting, recovery, wellness];
  }

  // Helper method to get category names
  List<String> getCategoryNames() {
    return ['Visualization', 'Consistency', 'Lifting', 'Recovery', 'Wellness'];
  }

  // Helper method to get average rating
  double getAverageRating() {
    final ratings = getAllRatings();
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }
}

class InsightsData {
  final SeriesData series;
  final PowerRatings powerRatings;

  InsightsData({
    required this.series,
    required this.powerRatings,
  });

  factory InsightsData.fromJson(Map<String, dynamic> json) {
    return InsightsData(
      series: SeriesData.fromJson(json['series'] ?? {}),
      powerRatings: PowerRatings.fromJson(json['powerRatings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'series': series.toJson(),
      'powerRatings': powerRatings.toJson(),
    };
  }

  // Helper method to get series data by category
  List<DataPoint> getSeriesByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'visualization':
        return series.visualization;
      case 'consistency':
        return series.consistency;
      case 'lifting':
        return series.lifting;
      case 'recovery':
        return series.recovery;
      case 'wellness':
        return series.wellness;
      default:
        return [];
    }
  }

  // Helper method to get all available categories
  List<String> getAvailableCategories() {
    List<String> categories = [];
    if (series.visualization.isNotEmpty) categories.add('Visualization');
    if (series.consistency.isNotEmpty) categories.add('Consistency');
    if (series.lifting.isNotEmpty) categories.add('Lifting');
    if (series.recovery.isNotEmpty) categories.add('Recovery');
    if (series.wellness.isNotEmpty) categories.add('Wellness');
    return categories;
  }
}

class InsightsResponse {
  final bool success;
  final String message;
  final InsightsData? data;

  InsightsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory InsightsResponse.fromJson(Map<String, dynamic> json) {
    return InsightsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? InsightsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

// Extension methods for easier data manipulation
extension InsightsDataExtension on InsightsData {
  // Get the latest value for a specific category
  int? getLatestValue(String category) {
    final seriesData = getSeriesByCategory(category);
    if (seriesData.isEmpty) return null;
    
    // Sort by timestamp and get the latest
    seriesData.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return seriesData.last.value;
  }

  // Get data points within a date range
  List<DataPoint> getDataInRange(String category, DateTime startDate, DateTime endDate) {
    final seriesData = getSeriesByCategory(category);
    return seriesData.where((point) {
      return point.timestamp.isAfter(startDate) && point.timestamp.isBefore(endDate);
    }).toList();
  }

  // Calculate trend (positive/negative/stable) for a category
  String getTrend(String category) {
    final seriesData = getSeriesByCategory(category);
    if (seriesData.length < 2) return 'insufficient_data';
    
    seriesData.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final first = seriesData.first.value;
    final last = seriesData.last.value;
    
    if (last > first) return 'positive';
    if (last < first) return 'negative';
    return 'stable';
  }
}

// Utility class for creating chart-friendly data
class ChartDataPoint {
  final DateTime x;
  final double y;
  final String category;

  ChartDataPoint({
    required this.x,
    required this.y,
    required this.category,
  });

  factory ChartDataPoint.fromDataPoint(DataPoint dataPoint, String category) {
    return ChartDataPoint(
      x: dataPoint.timestamp,
      y: dataPoint.value.toDouble(),
      category: category,
    );
  }
}

// Helper class to convert insights data to chart format
class InsightsChartHelper {
  static List<ChartDataPoint> getChartData(InsightsData data, String category) {
    final seriesData = data.getSeriesByCategory(category);
    return seriesData
        .map((point) => ChartDataPoint.fromDataPoint(point, category))
        .toList();
  }

  static List<ChartDataPoint> getAllChartData(InsightsData data) {
    List<ChartDataPoint> allData = [];
    
    for (String category in data.getAvailableCategories()) {
      final categoryData = getChartData(data, category);
      allData.addAll(categoryData);
    }
    
    return allData;
  }

  static Map<String, List<ChartDataPoint>> getChartDataByCategory(InsightsData data) {
    Map<String, List<ChartDataPoint>> chartData = {};
    
    for (String category in data.getAvailableCategories()) {
      chartData[category] = getChartData(data, category);
    }
    
    return chartData;
  }
}