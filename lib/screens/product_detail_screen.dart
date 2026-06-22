import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    int quantity = 1;

    return StatefulBuilder(
      builder: (context, setState) {
        final totalPrice = product.price * quantity;
        final specs = productSpecs(product);

        Future<void> openCart() async {
          await Navigator.pushNamed(context, '/cart');
          setState(() {});
        }

        void addSelectedQuantityToCart() {
          addProductToCart(product, quantity);
          setState(() {});

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$quantity adet ${product.title} sepete eklendi.'),
              duration: const Duration(seconds: 1),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF4F6FA),
            surfaceTintColor: const Color(0xFFF4F6FA),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Geri',
            ),
            title: const Text(
              'Urun Detayi',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: openCart,
                      icon: const Icon(Icons.shopping_cart_outlined),
                      tooltip: 'Sepeti goruntule',
                    ),
                    if (cartProductCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB703),
                            borderRadius: BorderRadius.circular(20),
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
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: const Color(0xFFEDEFF3),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE3E7ED)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          color: Color(0xFF16171A),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        shortDescription(product),
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          color: Color(0xFF008E7A),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Aciklama',
                        style: TextStyle(
                          color: Color(0xFF16171A),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: Color(0xFF4B5563),
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Teknik Ozellikler',
                        style: TextStyle(
                          color: Color(0xFF16171A),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: specs
                            .map(
                              (spec) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _SpecBox(
                                    title: spec['title']!,
                                    value: spec['value']!,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Adet',
                            style: TextStyle(
                              color: Color(0xFF16171A),
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE3E7ED),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: quantity == 1
                                      ? null
                                      : () {
                                          setState(() {
                                            quantity--;
                                          });
                                        },
                                  icon: const Icon(Icons.remove),
                                  visualDensity: VisualDensity.compact,
                                ),
                                SizedBox(
                                  width: 34,
                                  child: Text(
                                    '$quantity',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFB8F3E6)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Toplam Tutar',
                              style: TextStyle(
                                color: Color(0xFF0F766E),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              formatPrice(totalPrice),
                              style: const TextStyle(
                                color: Color(0xFF008E7A),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: addSelectedQuantityToCart,
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Sepete Ekle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16171A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
        );
      },
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String title;
  final String value;

  const _SpecBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E7ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF16171A),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
