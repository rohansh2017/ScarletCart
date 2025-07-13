import 'package:flutter/material.dart';
import 'package:scarletcart/frontend/product_info.dart'; // Assuming this path is correct


class FrequentPurchasedCard extends StatelessWidget {
 final String productName;
 final String productPrice;
 // 1. Change parameter to imageUrl
 final String imageUrl; // URL of the image


 // 2. Update constructor to accept imageUrl
 const FrequentPurchasedCard({
   super.key,
   required this.productName,
   required this.productPrice,
   required this.imageUrl, // Require the image URL
 });


 @override
 Widget build(BuildContext context) {
   final screenSize = MediaQuery.of(context).size;
   const double refWidth = 393;
   const double refHeight = 852;
   final double widthScale = screenSize.width / refWidth;
   final double heightScale = screenSize.height / refHeight;
   final double scaleFactor =
       (widthScale < heightScale ? widthScale : heightScale);


   final BorderRadius imageBorderRadius = BorderRadius.circular(8);


   return Padding(
     padding: EdgeInsets.all(16 * scaleFactor),
     child: GestureDetector(
       onTap: () {
         // print(productName);
         // print(productPrice);
         // print(imageUrl);
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => ProductDetailsPage(productName: productName,productPrice: productPrice,imageUrl:imageUrl),
           ),
         );
       },
       child: Container(
         height: 165 * scaleFactor,
         width: 154 * scaleFactor,
         decoration: BoxDecoration(
           color: const Color.fromARGB(255, 235, 253, 242),
           borderRadius: BorderRadius.circular(8),
           border: Border.all(
             width: 1,
             color: const Color.fromARGB(255, 23, 74, 44),
           ),
         ),
         child: Padding(
           padding: EdgeInsets.all(10 * scaleFactor),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // --- Image Container ---
               Center(
                 child: Container(
                   height: 69 * scaleFactor,
                   width: 127 * scaleFactor,
                   decoration: BoxDecoration(
                     borderRadius: imageBorderRadius,
                     border: Border.all(
                       width: 1,
                       color: const Color.fromARGB(255, 23, 74, 44),
                     ),
                   ),
                   child: ClipRRect(
                     borderRadius: imageBorderRadius,
                     // 3. Use Image.network
                     child: Image.network(
                       imageUrl, // Use the imageUrl parameter
                       fit: BoxFit.cover,
                       // 4. Add a loading builder for better UX
                       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                         if (loadingProgress == null) {
                           // Image is fully loaded, return it
                           return child;
                         }
                         // Image is still loading, show a progress indicator
                         return Center(
                           child: CircularProgressIndicator(
                             strokeWidth: 2.0,
                             valueColor: const AlwaysStoppedAnimation<Color>(
                               Color.fromARGB(255, 23, 74, 44),
                             ),
                             // Optionally show download progress
                             value: loadingProgress.expectedTotalBytes != null
                                 ? loadingProgress.cumulativeBytesLoaded /
                                     loadingProgress.expectedTotalBytes!
                                 : null, // Indeterminate if total size unknown
                           ),
                         );
                       },
                       // 5. Keep the error builder for network errors or invalid URLs
                       errorBuilder: (context, error, stackTrace) {
                         // Display a placeholder icon if image fails to load
                         return Container(
                           color: Colors.grey[300],
                           child: Icon(
                             Icons.broken_image_outlined, // Icon indicating broken link
                             color: Colors.grey[600],
                             size: 30 * scaleFactor,
                           ),
                         );
                       },
                     ),
                   ),
                 ),
               ),
               // --- Product Name ---
               Padding(
                 padding: EdgeInsets.only(top: 8 * scaleFactor, bottom: 8 * scaleFactor),
                 child: Text(
                   productName,
                   textAlign: TextAlign.left,
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                     fontSize: 14 * scaleFactor,
                     fontFamily: 'Outfit',
                     color: const Color.fromARGB(255, 23, 74, 44),
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
               // --- Price and Add Button ---
               Expanded(
                 child: Stack(
                   children: [
                     // --- Price Text ---
                     Positioned(
                       left: 0,
                       bottom: 4 * scaleFactor,
                       child: Text(
                         productPrice,
                         style: TextStyle(
                           fontSize: 13 * scaleFactor,
                           fontFamily: 'Outfit',
                           color: const Color.fromARGB(255, 23, 74, 44),
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                     // --- Add Button ---
                     Positioned(
                       bottom: 0,
                       right: 0,
                       child: Container(
                         height: 23 * scaleFactor,
                         width: 23 * scaleFactor,
                         decoration: const BoxDecoration(
                           color: Color.fromARGB(255, 108, 196, 142),
                           shape: BoxShape.circle,
                         ),
                         child: Center(
                           child: Text(
                             '+',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 13.5 * scaleFactor,
                               fontWeight: FontWeight.w700,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
 }
}



