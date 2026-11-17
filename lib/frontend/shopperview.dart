import 'package:flutter/material.dart';
import 'package:scarletcart/frontend/frequent_purchased_card.dart';
import 'shopper_home_dropdown.dart';
import 'package:scarletcart/frontend/cart_page.dart';
import 'package:scarletcart/frontend/orders_screen.dart';
import 'package:scarletcart/frontend/profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int cartItemCount = 3;
  // Add a text controller to capture search input
  final TextEditingController _searchController = TextEditingController();
  // Add a search term state variable
  String _searchTerm = '';

  // Define a list of all products
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Whole Wheat Bread',
      'price': '\$4.25',
      'imageUrl': 'https://www.seriouseats.com/thmb/hc5bL7SCUS-UOKnfR50TUEhRBSg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__2018__12__20181220-wheat-bread-loaf-vicky-wasik-30-264ac9dff1b94f2bafb1647b8601fd4a.jpg',
    },
    {
      'name': 'Fresh Lemons',
      'price': '\$3.25',
      'imageUrl': 'https://www.pearsonranch.com/cdn/shop/collections/California_Lemons.png?v=1738000043',
    },
    {
      'name': 'Apples',
      'price': '\$3.75',
      'imageUrl': 'https://hips.hearstapps.com/hmg-prod/images/apples-at-farmers-market-royalty-free-image-1627321463.jpg?crop=1.00xw:0.631xh;0.00160xw,0.206xh&resize=1200:*',
    },
    {
      'name': 'Watermelon',
      'price': '\$4.99',
      'imageUrl': 'https://publish.purewow.net/wp-content/uploads/sites/2/2021/07/types-of-melons-watermelon.jpg?fit=728%2C524',
    },
    {
      'name': 'Grapes',
      'price': '\$6.25',
      'imageUrl': 'https://www.thespruceeats.com/thmb/Cubrt02YUcdvq7wtedPYlMsqYFY=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/what-are-grapes-5193263-hero-01-80564d77b6534aa8bfc34f378556e513.jpg',
    },
    {
      'name': 'Blueberries',
      'price': '\$4.25',
      'imageUrl': 'https://media.post.rvohealth.io/wp-content/uploads/2020/08/blueberries_fresh_fullframe_732x549_thumb-732x549.jpg',
    },
  ];

  // Filtered products based on search term
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered products with all products
    _filteredProducts = List.from(_allProducts);
    
    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Search functionality
  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text.toLowerCase();
      if (_searchTerm.isEmpty) {
        // If search is empty, show all products
        _filteredProducts = List.from(_allProducts);
      } else {
        // Filter products based on search term
        _filteredProducts = _allProducts
            .where((product) =>
                product['name'].toLowerCase().contains(_searchTerm))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double refWidth = 393; //width of iphone 16
    const double refHeight = 852; //height of iphone 16
    final double widthScale = screenSize.width / refWidth;
    final double heightScale = screenSize.height / refHeight;
    final double scaleFactor =
        (widthScale < heightScale ? widthScale : heightScale);
    String name = "User";
    int cartItemCount = 3;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 255, 247),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50 * scaleFactor),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 235, 253, 242),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: const Color.fromARGB(255, 23, 74, 44),
              size: 24 * scaleFactor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Homepage',
            style: TextStyle(
              fontSize: 22 * (scaleFactor),
              color: const Color.fromARGB(255, 23, 74, 44),
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: const Color.fromARGB(255, 23, 74, 44),
                size: 24 * scaleFactor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.list_alt,
                color: const Color.fromARGB(255, 23, 74, 44),
                size: 24 * scaleFactor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color.fromARGB(255, 23, 74, 44),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ShoppingCartScreen()),
                    );
                  },
                  tooltip: 'Shopping cart',
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green,
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
          ],
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: screenSize.width,
                        height: screenSize.height * (200.5 / refHeight),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 235, 253, 242),
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 23, 74, 44),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 28 * scaleFactor,
                        top: 45 * scaleFactor,
                      ),
                      child: Text(
                        "Hey, $name!",
                        style: TextStyle(
                          fontSize: 22 * (scaleFactor),
                          color: const Color.fromARGB(255, 23, 74, 44),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 95 * scaleFactor,
                        ),
                        child: Container(
                          width: 318 * scaleFactor,
                          height: 40 * scaleFactor,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 108, 196, 142),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromARGB(255, 23, 74, 44),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 14 * scaleFactor,
                                  bottom: 3 * scaleFactor,
                                ),
                                child: TextField(
                                  controller: _searchController, // Use the controller here
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search a Product or Store',
                                    hintStyle: TextStyle(
                                        fontSize: 16 * scaleFactor),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16 * scaleFactor),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 8 * scaleFactor),
                                  child: Icon(
                                    Icons.search,
                                    color:
                                        const Color.fromARGB(255, 23, 74, 44),
                                    size: 24 * scaleFactor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8 * scaleFactor,
                      left: 8 * scaleFactor,
                      child: Padding(
                        padding: EdgeInsets.all(8 * scaleFactor),
                        child: Text(
                          'Delivery To',
                          style: TextStyle(
                            color: const Color(0xFF174A2C),
                            fontSize: 14 * scaleFactor,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1 * scaleFactor,
                      right: 1 * scaleFactor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 8 * scaleFactor,
                        ),
                        child: const DropdownButtonExample(),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 17 * scaleFactor,
                      top: 10 * scaleFactor,
                    ),
                    child: Text(
                      _searchTerm.isEmpty ? 'Frequently Purchased' : 'Search Results',
                      style: TextStyle(
                        color: const Color(0xFF174A2C),
                        fontSize: 24 * scaleFactor,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(10 * scaleFactor),
                    child: _filteredProducts.isEmpty
                        ? Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18 * scaleFactor,
                                color: const Color.fromARGB(255, 23, 74, 44),
                              ),
                            ),
                          )
                        : _buildProductGrid(scaleFactor),
                  ),
                ),
                SizedBox(
                  height: 110 * scaleFactor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build product grid based on filtered products
  Widget _buildProductGrid(double scaleFactor) {
    // Create rows of products with 2 items per row
    List<Widget> rows = [];
    for (int i = 0; i < _filteredProducts.length; i += 2) {
      List<Widget> rowChildren = [];
      
      // Add first product
      rowChildren.add(
        Expanded(
          child: FrequentPurchasedCard(
            productName: _filteredProducts[i]['name'],
            productPrice: _filteredProducts[i]['price'],
            imageUrl: _filteredProducts[i]['imageUrl'],
          ),
        ),
      );
      
      // Add spacing
      rowChildren.add(SizedBox(width: 10 * scaleFactor));
      
      // Add second product if it exists
      if (i + 1 < _filteredProducts.length) {
        rowChildren.add(
          Expanded(
            child: FrequentPurchasedCard(
              productName: _filteredProducts[i + 1]['name'],
              productPrice: _filteredProducts[i + 1]['price'],
              imageUrl: _filteredProducts[i + 1]['imageUrl'],
            ),
          ),
        );
      } else {
        // Add empty space to maintain grid layout
        rowChildren.add(Expanded(child: Container()));
      }
      
      // Add row to rows list
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowChildren,
        ),
      );
      
      // Add spacing between rows
      if (i + 2 < _filteredProducts.length) {
        rows.add(SizedBox(height: 10 * scaleFactor));
      }
    }
    
    return Column(children: rows);
  }
}