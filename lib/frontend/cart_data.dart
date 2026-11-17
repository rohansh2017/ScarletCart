

class CartItemInfo {
  final String id; // Add a unique ID (e.g., combination of name/price or a real product ID)
  final String name;
  final double price;
  int quantity; // Quantity needs to be managed here

  CartItemInfo({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1, // Default quantity to 1 when adding
  });
}

class CartService {
  // Static list to hold cart items - NOT RECOMMENDED FOR PRODUCTION APPS
  // Use Provider, Riverpod, Bloc etc. instead for proper state management.
  static final List<CartItemInfo> _items = [];

  // Static getter to access the items
  static List<CartItemInfo> get items => _items;

  // Static method to add an item
  static void addItem(String name, double price) {
    // Create a simple unique ID (replace with real product ID if available)
    final String id = '${name}_$price';

    // Check if item already exists
    int existingIndex = _items.indexWhere((item) => item.id == id);

    if (existingIndex != -1) {
      // Item exists, increment quantity
      _items[existingIndex].quantity++;
    } else {
      // Item doesn't exist, add new
      _items.add(CartItemInfo(id: id, name: name, price: price, quantity: 1));
    }
    // In a real app with state management, you'd notify listeners here.
    // For this static approach, pages need to manually fetch/refresh data.
    print("Item added: $name. Total items: ${_items.length}");
     _items.forEach((item) => print("  - ${item.name}: ${item.quantity}"));
  }

  // Static method to update quantity
  static void updateQuantity(String id, int newQuantity) {
     int index = _items.indexWhere((item) => item.id == id);
     if (index != -1) {
        if (newQuantity > 0) {
          _items[index].quantity = newQuantity;
        } else {
          // Remove if quantity becomes 0 or less
          removeItem(id);
        }
        print("Quantity updated for ID $id to $newQuantity");
     }
  }


  // Static method to remove an item by ID
  static void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
     print("Item removed with ID: $id. Total items: ${_items.length}");
  }

  // Calculate total items count (sum of quantities) - for badge
   static int get totalItemCount {
     return _items.fold(0, (sum, item) => sum + item.quantity);
   }

   // Calculate subtotal
   static double get subtotal {
     return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
   }
}