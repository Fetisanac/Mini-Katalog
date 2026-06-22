import 'package:flutter/material.dart';

import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  String selectedCategory = 'Tum';

  List<Product> get products {
    return dummyProducts
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  List<Product> get filteredProducts {
    final query = searchText.trim().toLowerCase();

    return products
        .where((product) {
          final matchesCategory =
              selectedCategory == 'Tum' || product.category == selectedCategory;
          final matchesSearch = query.isEmpty ||
              product.title.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query);

          return matchesCategory && matchesSearch;
        })
        .toList();
  }

  void addToCart(Product product) {
    addProductToCart(product, 1);
    setState(() {});

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} sepete eklendi.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> openCart() async {
    await Navigator.pushNamed(context, '/cart');

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openDetails(Product product) async {
    await Navigator.pushNamed(
      context,
      '/details',
      arguments: product,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Widget buildCartButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF16171A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: openCart,
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 21,
            ),
            tooltip: 'Sepeti goruntule',
          ),
        ),
        if (cartProductCount > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB703),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$cartProductCount',
                style: const TextStyle(
                  color: Color(0xFF16171A),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildSearchBox() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Oyuncu aksesuari ara',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildSetupBanner() {
    return Container(
      height: 86,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF00D1B2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.sports_esports,
              color: Color(0xFF0F172A),
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SETUP FIRSATI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Klavye, mouse ve ses ekipmanlari bir arada.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryChips() {
    const categories = ['Tum', 'Kulaklik', 'Klavye', 'Mouse', 'Gamepad'];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return InkWell(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00D1B2) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00D1B2)
                      : const Color(0xFFE3E7ED),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF4B5563),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE3E7ED)),
      ),
      child: InkWell(
        onTap: () => openDetails(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFEDEFF3),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 42,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF16171A),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shortDescription(product),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPrice(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF008E7A),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: IconButton(
                          onPressed: () => addToCart(product),
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB703),
                            foregroundColor: const Color(0xFF16171A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_shopping_cart, size: 17),
                          tooltip: 'Sepete ekle',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Gear',
                          style: TextStyle(
                            color: Color(0xFF16171A),
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Oyuncu ekipmanlarini kesfet.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildCartButton(),
                ],
              ),
              const SizedBox(height: 16),
              buildSearchBox(),
              const SizedBox(height: 12),
              buildSetupBanner(),
              const SizedBox(height: 12),
              buildCategoryChips(),
              const SizedBox(height: 12),
              Expanded(
                child: visibleProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'Urun bulunamadi.',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : GridView.builder(
                        itemCount: visibleProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.66,
                        ),
                        itemBuilder: (context, index) {
                          return buildProductCard(visibleProducts[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
