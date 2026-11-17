import 'package:flutter/material.dart';
import 'package:scarletcart/frontend/cart_page.dart';
import 'package:scarletcart/frontend/profile.dart';
import 'package:scarletcart/frontend/order_tracking.dart';
// --- Placeholder Screens for Navigation ---
// (Replace with your actual screen implementations if they exist)
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile')), body: const Center(child: Text('Profile Screen')));
// }
// class ShoppingCartScreen extends StatelessWidget {
//   const ShoppingCartScreen({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Cart')), body: const Center(child: Text('Shopping Cart Screen')));
// }
// class CustomerOrderDetailsScreen extends StatelessWidget {
//   final String orderId;
//   const CustomerOrderDetailsScreen({super.key, required this.orderId});
//   @override
//   Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Track Order $orderId')), body: Center(child: Text('Tracking Details for $orderId')));
// }
// --- End Placeholder Screens ---


// A simple data model for an order (replace with your actual model)
class Order {
 final String id;
 final String productName;
 final double price;
 final String imagePath; // Placeholder for image icon/path


 Order({
   required this.id,
   required this.productName,
   required this.price,
   this.imagePath = 'assets/placeholder.png', // Default placeholder
 });
}


class OrdersScreen extends StatefulWidget {
 const OrdersScreen({super.key});


 @override
 State<OrdersScreen> createState() => _OrdersScreenState();
}


// Enum to manage which tab is selected
enum OrderType { current, past }


class _OrdersScreenState extends State<OrdersScreen> {
 OrderType _selectedOrderType = OrderType.current; // Default to current orders
 int cartItemCount = 3; // Example item count for the cart badge


 // --- Updated Sample Data with Diverse Items ---
 final List<Order> _currentOrders = [
   Order(
     id: '#orderID_123',
     productName: 'Eggs, Milk',
     price: 5.49,
     // imagePath: 'assets/blueberries.png', // Optional: if you have specific images
   ),
   Order(
     id: '#765434',
     productName: 'Whole Wheat Bread',
     price: 6.99,
     // imagePath: 'assets/bread.png', // Optional
   ),
   Order(
     id: '#765435',
     productName: 'Organic Milk (Gallon)',
     price: 4.79,
     // imagePath: 'assets/milk.png', // Optional
   ),
   Order(
     id: '#765436',
     productName: 'Avocado (Bag of 3)',
     price: 3.99,
     // imagePath: 'assets/avocado.png', // Optional
   ),
   Order(
     id: '#765437',
     productName: 'Ground Coffee (Medium Roast)',
     price: 11.20,
     // imagePath: 'assets/coffee.png', // Optional
   ),
 ];


 final List<Order> _pastOrders = [
   Order(
     id: '#123450',
     productName: 'Imported Olive Oil (500ml)',
     price: 15.50,
     // imagePath: 'assets/olive_oil.png', // Optional
   ),
   Order(
     id: '#123451',
     productName: 'Whole Wheat Pasta (Box)',
     price: 2.85,
     // imagePath: 'assets/pasta.png', // Optional
   ),
   Order(
     id: '#123452',
     productName: 'Natural Peanut Butter',
     price: 4.95,
     // imagePath: 'assets/peanut_butter.png', // Optional
   ),
    Order(
     id: '#123453',
     productName: 'Frozen Pizza Margherita',
     price: 8.75,
     // imagePath: 'assets/pizza.png', // Optional
   ),
 ];
 // --- End Updated Sample Data ---


 // Define the colors from the image
 final Color primaryGreen = const Color(0xFF6CC48E);
 final Color lightBgGreen =
     const Color(0xFFF0FAF5); // Slightly adjusted for visibility
 final Color darkTextColor = const Color(0xFF333333); // Darker text
 final Color lightTextColor = const Color(0xFF555555); // Lighter text like ID
 final Color borderColor =
     const Color(0xFFB0E0C5); // Border color for inactive tab
 final Color iconColor = const Color.fromARGB(
     255, 23, 74, 44); // Icon color like previous examples


 @override
 Widget build(BuildContext context) {
   // Determine which list to display based on the selected type
   final List<Order> ordersToShow =
       _selectedOrderType == OrderType.current ? _currentOrders : _pastOrders;


   return Scaffold(
     backgroundColor: lightBgGreen,
     // ========== New AppBar ==========
     appBar: AppBar(
       backgroundColor: Colors.white, // White AppBar background
       elevation: 1.0, // Subtle shadow
       shadowColor: Colors.grey.withOpacity(0.2),
       // --- Back Button ---
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: iconColor),
         tooltip: 'Back',
         onPressed: () {
           // Standard back navigation
           if (Navigator.canPop(context)) {
             Navigator.pop(context);
           }
           // Optional: Add fallback if it cannot pop (e.g., navigate to home)
           // else { Navigator.pushReplacementNamed(context, '/home'); }
         },
       ),
       // --- Title ---
       title: Text(
         'Orders',
         style: TextStyle(
           color: darkTextColor,
           fontWeight: FontWeight.w600,
           fontSize: 20,
         ),
       ),
       // --- Action Icons ---
       actions: <Widget>[
         // Profile Icon
         IconButton(
           icon: Icon(Icons.person_outline, color: iconColor),
           tooltip: 'Profile',
           onPressed: () {
             print('Profile Tapped');
             // Navigate to Profile Screen
             Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) =>
                       const ProfileScreen()), // <-- Navigate directly to the Screen widget
             );
           },
         ),
         // Orders List Icon (Optional - redundant here, but included as requested)
         IconButton(
           icon: Icon(Icons.list_alt, color: iconColor), // Use consistent icon color
           tooltip: 'My Orders',
           onPressed: () {
             // Already on the orders screen, could refresh or do nothing
             print('Orders Icon Tapped (already here)');
             // Or maybe navigate to a specific filter/section if needed later
           },
         ),
         // Cart Icon with Badge
         Stack(
           alignment: Alignment.center,
           children: <Widget>[
             IconButton(
               icon: Icon(Icons.shopping_cart_outlined, color: iconColor),
               tooltip: 'Shopping Cart',
               onPressed: () {
                 print('Cart Tapped');
                 // Navigate to Cart Screen
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => const ShoppingCartScreen()));
               },
             ),
             if (cartItemCount > 0)
               Positioned(
                 right: 6, // Adjust position as needed
                 top: 6, // Adjust position as needed
                 child: Container(
                   padding: const EdgeInsets.all(2),
                   decoration: BoxDecoration(
                     color: primaryGreen, // Use your theme's green
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white, width: 1),
                   ),
                   constraints: const BoxConstraints(
                     minWidth: 16,
                     minHeight: 16,
                   ),
                   child: Text(
                     cartItemCount > 9 ? '9+' : '$cartItemCount',
                     style: const TextStyle(
                       color: Colors.white,
                       fontSize: 10,
                       fontWeight: FontWeight.bold,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
               ),
           ],
         ),
         const SizedBox(width: 8), // Add a little padding to the right edge
       ],
       // If you use a custom leading widget, you might want this false
       // If you want the default drawer/back behavior, set it to true (or omit)
       // automaticallyImplyLeading: false,
     ),
     // ========== End New AppBar ==========
     body: Column(
       children: [
         _buildToggleButtons(), // The "Current" / "Past" buttons
         Expanded(
           // Make the list scrollable and take remaining space
           child: ordersToShow.isEmpty
               ? _buildEmptyListIndicator() // Show message if list is empty
               : ListView.separated(
                   padding: const EdgeInsets.symmetric(
                       horizontal: 16.0, vertical: 20.0),
                   itemCount: ordersToShow.length,
                   itemBuilder: (context, index) {
                     return _buildOrderItem(ordersToShow[index]);
                   },
                   separatorBuilder: (context, index) => Divider(
                     color: borderColor.withOpacity(0.6), // Slightly faded divider
                     height: 30, // Increased spacing between items
                     thickness: 1,
                     indent: 10, // Indent from left
                     endIndent: 10, // Indent from right
                   ),
                 ),
         ),
       ],
     ),
     // Bottom Nav Bar removed as per the request focus on AppBar
   );
 }


 // Widget to build the "Current" / "Past" toggle buttons
 Widget _buildToggleButtons() {
   return Container(
     color: Colors.white, // White background behind buttons
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
     child: Row(
       children: [
         Expanded(
           child: _buildToggleButton(
             'Current',
             OrderType.current,
           ),
         ),
         const SizedBox(width: 10), // Spacing between buttons
         Expanded(
           child: _buildToggleButton(
             'Past',
             OrderType.past,
           ),
         ),
       ],
     ),
   );
 }


 // Helper to build a single toggle button
 Widget _buildToggleButton(String text, OrderType type) {
   bool isSelected = _selectedOrderType == type;
   return InkWell(
     onTap: () {
       if (!isSelected) {
         // Only update state if it's actually changing
         setState(() {
           _selectedOrderType = type;
         });
       }
     },
     borderRadius:
         BorderRadius.circular(12.0), // Match container border radius
     child: Container(
       padding: const EdgeInsets.symmetric(vertical: 12.0),
       decoration: BoxDecoration(
         color: isSelected ? primaryGreen : Colors.transparent,
         borderRadius: BorderRadius.circular(12.0),
         border:
             isSelected ? null : Border.all(color: borderColor, width: 1.5),
       ),
       child: Center(
         child: Text(
           text,
           style: TextStyle(
             color: isSelected ? Colors.white : primaryGreen,
             fontWeight: FontWeight.w600,
             fontSize: 15,
           ),
         ),
       ),
     ),
   );
 }


 // Widget to build a single order item in the list
 Widget _buildOrderItem(Order order) {
   // Determine button text based on order type
   String buttonText = _selectedOrderType == OrderType.current ? 'Track Order' : 'Reorder'; // Or 'View Details' for past


   return Column(
     mainAxisSize: MainAxisSize.min, // Important for ListView item sizing
     children: [
       Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Image Placeholder
           Container(
             width: 55, // Slightly larger image
             height: 55,
             decoration: BoxDecoration(
                 color: Colors.grey.shade200, // Placeholder background
                 borderRadius: BorderRadius.circular(8),
                 border: Border.all(color: borderColor, width: 1)),
             child: Icon(Icons.image_outlined,
                 color: Colors.grey.shade400, size: 30),
             // TODO: Replace with actual image loading if paths are available
             // child: ClipRRect( // Use ClipRRect for rounded corners on image
             //   borderRadius: BorderRadius.circular(8.0),
             //   child: Image.asset(
             //     order.imagePath,
             //     fit: BoxFit.cover,
             //     errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.grey.shade400, size: 30), // Error fallback
             //   ),
             // ),
           ),
           const SizedBox(width: 15),
           // Product Name and Price
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   order.productName,
                   style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                     color: darkTextColor,
                   ),
                   maxLines: 2, // Allow slightly longer names
                   overflow: TextOverflow.ellipsis,
                 ),
                 const SizedBox(height: 6), // Increased spacing
                 Text(
                   '\$${order.price.toStringAsFixed(2)}', // Format price
                   style: TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.w500,
                     color: primaryGreen, // Use primary green for price
                   ),
                 ),
               ],
             ),
           ),
           const SizedBox(width: 10),
           // Order ID
           Padding(
             padding: const EdgeInsets.only(top: 2.0), // Align slightly better
             child: Text(
               'ID: ${order.id}',
               style: TextStyle(
                 fontSize: 13,
                 color: lightTextColor,
                 fontWeight: FontWeight.w500,
               ),
             ),
           ),
         ],
       ),
       const SizedBox(height: 18), // Increased spacing before button
       // Track Order / Reorder Button (aligned to the right)
       Align(
         alignment: Alignment.centerRight,
         child: ElevatedButton(
           onPressed: () {
             if (_selectedOrderType == OrderType.current) {
               // --- Navigation Logic for Tracking ---
               print('Track Order Tapped: ${order.id}');
               Navigator.push(
                   context,
                   MaterialPageRoute(
                     // Use the actual order ID here if available
                     builder: (context) => CustomerOrderDetailsScreen(orderId: order.id),
                   ));
             } else {
                // --- Logic for Reorder / View Details ---
               print('Reorder/View Details Tapped: ${order.id}');
               // TODO: Implement reorder functionality or navigate to past order details
                // Example: Show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reorder functionality for ${order.productName} not implemented yet.'))
                );
             }
           },
           style: ElevatedButton.styleFrom(
             backgroundColor: primaryGreen,
             foregroundColor: Colors.white,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20.0),
             ),
             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
             elevation: 2,
             shadowColor: primaryGreen.withOpacity(0.4),
           ),
           child: Text(
             buttonText,
             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
           ),
         ),
       ),
     ],
   );
 }


 // Widget to display when the order list is empty
 Widget _buildEmptyListIndicator() {
   return Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(
           Icons.receipt_long_outlined,
           size: 60,
           color: Colors.grey.shade400,
         ),
         const SizedBox(height: 16),
         Text(
           _selectedOrderType == OrderType.current
               ? 'You have no current orders'
               : 'You have no past orders',
           style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
         ),
          const SizedBox(height: 8),
          Text(
           _selectedOrderType == OrderType.current
               ? 'Items you order will appear here.'
               : 'Completed orders will appear here.',
           style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
           textAlign: TextAlign.center,
         ),
       ],
     ),
   );
 }
}




// --- Main Function (for standalone testing - uncomment if needed) ---
/*
void main() {
 runApp(const MyApp());
}


class MyApp extends StatelessWidget {
 const MyApp({super.key});


 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Flutter Orders Demo',
     theme: ThemeData(
       primarySwatch: Colors.green, // Base color swatch
       colorScheme: ColorScheme.fromSwatch( // More modern way
           primarySwatch: Colors.green,
       ).copyWith(
           primary: const Color(0xFF6CC48E), // Your primary green
           secondary: const Color(0xFF6CC48E), // Often same as primary or accent
           background: const Color(0xFFF0FAF5), // Your light background
        ),
       appBarTheme: AppBarTheme(
         iconTheme: IconThemeData(color: const Color.fromARGB(255, 23, 74, 44)), // Default icon color
         titleTextStyle: TextStyle(color: const Color(0xFF333333), fontSize: 20, fontWeight: FontWeight.w600), // Default title style
         backgroundColor: Colors.white,
         elevation: 1.0,
         shadowColor: Colors.grey.withOpacity(0.2),
       ),
       visualDensity: VisualDensity.adaptivePlatformDensity,
       scaffoldBackgroundColor: const Color(0xFFF0FAF5), // Default scaffold background
     ),
     home: const OrdersScreen(), // Start with the OrdersScreen
     debugShowCheckedModeBanner: false,
   );
 }
}


// --- Dummy Placeholder Screens for testing main() ---
class ProfileScreen extends StatelessWidget {
 const ProfileScreen({super.key});
 @override
 Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile')), body: const Center(child: Text('Profile Screen')));
}
class ShoppingCartScreen extends StatelessWidget {
 const ShoppingCartScreen({super.key});
 @override
 Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Cart')), body: const Center(child: Text('Shopping Cart Screen')));
}
class CustomerOrderDetailsScreen extends StatelessWidget {
 final String orderId;
 const CustomerOrderDetailsScreen({super.key, required this.orderId});
 @override
 Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Track Order $orderId')), body: Center(child: Text('Tracking Details for $orderId')));
}
*/

