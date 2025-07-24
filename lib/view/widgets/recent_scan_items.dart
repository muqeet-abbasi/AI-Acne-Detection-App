import 'package:acne_detection_app/models/scan_model.dart';
import 'package:flutter/material.dart';

class RecentScanItem extends StatefulWidget {
  final ScanModel scan;

  const RecentScanItem({super.key, required this.scan});

  @override
  _RecentScanItemState createState() => _RecentScanItemState();
}

class _RecentScanItemState extends State<RecentScanItem> {
  bool _isTapped = false;

  // Get color based on acne severity
  Color _getSeverityColor(String severity, ColorScheme colorScheme) {
    switch (severity.toLowerCase()) {
      case 'mild acne':
        return Colors.green.shade400; // Fallback, replace with theme color if needed
      case 'moderate acne':
        return colorScheme.secondary; // Use accentColor
      case 'severe acne':
        return Colors.red.shade400; // Fallback, replace with theme error color if needed
      default:
        return colorScheme.primary; // Use primaryColor
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final severityColor = _getSeverityColor(widget.scan.result, colorScheme);

    return GestureDetector(
      // // onTapDown: (_) => setState(() => _isTapped = true),
      // onTapUp: (_) => setState(() => _isTapped = false),
      // onTapCancel: () => setState(() => _isTapped = false),
      // onTap: () {
      //   // Optional: Navigate to details screen or show dialog
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Tapped scan: ${widget.scan.result}')),
      //   );
      // },
      child: AnimatedScale(
        scale: _isTapped ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.41, // Responsive: 55% of screen width
          margin: const EdgeInsets.only(right: 16, bottom: 5),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.scaffoldBackgroundColor, // backgroundColor
                    severityColor.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: severityColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date with icon
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color ?? Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.scan.date,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodySmall?.color ?? Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Severity (Result)
                    Text(
                      widget.scan.result,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Spot Count with badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: severityColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        'Spots: ${widget.scan.spotCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: severityColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}