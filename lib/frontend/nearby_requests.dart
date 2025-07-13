import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scarletcart/frontend/profile.dart';
import 'package:scarletcart/frontend/shopping_list.dart';

class Request {
  final String id;
  final String storeName;
  final String deliveryLocation;
  final String distance;
  final String profit;
  final IconData icon;
  final Color iconColor;
  final LatLng baseLocation; // 👈 new

  Request({
    required this.id,
    required this.storeName,
    required this.deliveryLocation,
    required this.distance,
    required this.profit,
    required this.baseLocation,
    this.icon = Icons.shopping_bag_outlined,
    this.iconColor = Colors.green,
  });
}

// --- Sample Data (Unchanged) ---
// You might want to add unique IDs if they matter later
final Request recommendedRequest = Request(
  id: 'rec_1',
  storeName: "Shop Rite (Recommended)",
  deliveryLocation: "Deliver: Busch Student Center",
  distance: "Distance: 1.5 mi",
  profit: "Profit: \$15",
  iconColor: Colors.orange.shade700,
  baseLocation: const LatLng(40.5230, -74.4580), // 👈 Add a real location here
);

final List<Request> sampleRequests = [
  Request(
    id: 'nearby_1',
    storeName: "Stop & Shop – New Brunswick",
    deliveryLocation: "Deliver: Busch Student Center",
    distance: "1.2 mi",
    profit: "\$13",
    baseLocation: const LatLng(40.512051, -74.486452),
  ),
  Request(
    id: 'nearby_2',
    storeName: "ALDI – Piscataway",
    deliveryLocation: "Deliver: Busch Student Center",
    distance: "1.8 mi",
    profit: "\$15",
    baseLocation: const LatLng(40.552144, -74.439081),
  ),
  Request(
    id: 'nearby_3',
    storeName: "Kilmer's Market",
    deliveryLocation: "Deliver: Busch Student Center",
    distance: "2.3 mi",
    profit: "\$14",
    baseLocation: const LatLng(40.525745, -74.438538),
  )
];

// --- End Sample Data ---

// --- Main App Widget ---
// It's generally better to have one MaterialApp at the root of your entire app (main.dart).
// If OrderConfirmationScreen is pushed onto an existing navigator, this MaterialApp isn't needed here.
// For standalone testing, it's okay.
class NearbyReqScreen extends StatelessWidget {
  const NearbyReqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Requests',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFDCF5E6),
            foregroundColor: Colors.black,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'YourAppFont',
            ),
            iconTheme: IconThemeData(color: Colors.black54)),
      ),
      home: const OrderConfirmationScreen(),
    );
  }
}
// --- End Main App Widget ---

// --- Screen Widget ---
class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  late List<Marker> _markers;

  @override
  void initState() {
    super.initState();

    _markers = [
      Marker(
        markerId: MarkerId(recommendedRequest.id),
        position: recommendedRequest.baseLocation,
        infoWindow: InfoWindow(
          title: recommendedRequest.storeName,
          snippet: recommendedRequest.profit,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      ...sampleRequests.map((request) {
        return Marker(
          markerId: MarkerId(request.id),
          position: request.baseLocation,
          infoWindow: InfoWindow(
            title: request.storeName,
            snippet: request.profit,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color sheetBackgroundColor = colorScheme.surface;
    final Color dragHandleColor = Colors.grey[300] ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text("Requests"),
        centerTitle: false,
        titleSpacing:
            Navigator.canPop(context) ? 0 : NavigationToolbar.kMiddleSpacing,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_outline, size: 28),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // ✅ Google Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: recommendedRequest.baseLocation,
                zoom: 13.5,
              ),
              markers: Set<Marker>.of(_markers),
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          // --- Draggable Sheet ---
          DraggableScrollableSheet(
            initialChildSize:
                0.28, // Start height (percentage of available space)
            minChildSize: 0.28, // Minimum height it can be dragged down to
            maxChildSize: 0.85, // Maximum height it can be dragged up to
            builder: (BuildContext context, ScrollController scrollController) {
              // This builder returns the scrollable content of the sheet
              return Container(
                decoration: BoxDecoration(
                  color: sheetBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20)), // Rounded top corners
                  boxShadow: [
                    // Soft shadow for visual separation
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2), // Shadow above the sheet
                    ),
                  ],
                ),
                // Use a ListView for the sheet content for easy scrolling of mixed items
                child: ListView(
                  // Changed from Column + Expanded(ListView) for simplicity here
                  controller:
                      scrollController, // *** Attach the controller to the scrollable view ***
                  padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 5.0, // Padding above the drag handle
                    // Add bottom padding to avoid system navigation bars
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                  ),
                  children: [
                    // Drag Handle indicator
                    Align(
                      // Center the handle
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0), // Space around handle
                        decoration: BoxDecoration(
                          color: dragHandleColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // --- Recommended Request Section (Optional) ---
                    // Uncomment if you want a separate recommended section
                    // const Text(
                    //   "Recommended Request",
                    //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 8),
                    // _RequestRowWidget(request: recommendedRequest),
                    // const Divider(height: 20, thickness: 1),
                    // --- End Recommended Request Section ---

                    // Nearby Requests Title
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom: 5.0, top: 10.0), // Adjust spacing
                      child: Text(
                        "Nearby Requests",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // --- Nearby Requests List ---
                    // Generate list items using map and spread operator (...)
                    ...sampleRequests.map((request) => GestureDetector(
                              onTap: () {
                                // Navigate to the Shopping List screen when a request is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // Using ShoppingLI wrapper which contains ShoppingListScreen
                                    builder: (context) => const ShoppingLI(),
                                    // Consider passing request details if ShoppingLI/ShoppingListScreen needs them:
                                    // builder: (context) => ShoppingLI(requestDetails: request),
                                  ),
                                );
                              },
                              // Use the reusable widget for each row
                              child: _RequestRowWidget(request: request),
                            ) // End GestureDetector
                        ), // Convert the Iterable from map to a List<Widget>
                    // --- End Nearby Requests List ---

                    // Bottom padding is handled by ListView's padding property above
                  ], // End children of ListView
                ), // End Container for sheet content
              ); // End return Container
            }, // End builder
          ), // End DraggableScrollableSheet
          // --- End Draggable Sheet ---
        ], // End children of Stack
      ), // End Stack
    ); // End Scaffold
  }
} // End of _OrderConfirmationScreenState

// --- Reusable Widget for Displaying a Single Request Row (Unchanged) ---
class _RequestRowWidget extends StatelessWidget {
  final Request request;

  const _RequestRowWidget({required this.request});

  @override
  Widget build(BuildContext context) {
    // Get text styles and colors from the theme for consistency
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // Padding around each row
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          // Icon for the request type
          Icon(
            request.icon,
            color: request.iconColor, // Use color from request data
            size: 32, // Icon size
          ),
          const SizedBox(width: 15), // Space between icon and text
          // Text content, expands to fill available space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
              children: [
                // Store Name (Bold title)
                Text(
                  request.storeName,
                  style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold), // Use theme style
                  maxLines: 1, // Prevent wrapping
                  overflow: TextOverflow.ellipsis, // Indicate overflow with ...
                ),
                const SizedBox(height: 4), // Space below store name
                // Delivery Location (Smaller text)
                Text(
                  request.deliveryLocation,
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant), // Use theme style (often slightly muted)
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3), // Space
                // Distance
                Text(
                  request.distance,
                  style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant), // Even smaller text
                ),
                const SizedBox(height: 3), // Space
                // Profit (Slightly bolder small text)
                Text(
                  request.profit,
                  style: textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          FontWeight.w600), // Make profit stand out a bit
                ),
              ],
            ),
          ),
          const SizedBox(width: 10), // Space before chevron
          // Chevron icon indicating tappability
          Padding(
            padding: const EdgeInsets.only(top: 2.0), // Align chevron nicely
            child: Icon(
              Icons.chevron_right,
              color: Colors.grey[400], // Muted color for chevron
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
// --- End Reusable Widget ---

// --- Main Function (for standalone testing if needed) ---
/*
void main() {
  // Ensures Flutter binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NearbyReqScreen()); // Run the app starting with NearbyReqScreen
}
*/
