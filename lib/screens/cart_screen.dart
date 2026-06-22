import 'package:flutter/material.dart';

import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void decreaseQuantity(CartItem item) {
    setState(() {
      updateProductQuantity(item.product.id, item.quantity - 1);
    });
  }

  void increaseQuantity(CartItem item) {
    setState(() {
      updateProductQuantity(item.product.id, item.quantity + 1);
    });
  }

  void removeItem(CartItem item) {
    setState(() {
      removeProductFromCart(item.product.id);
    });
  }

  void clearAllItems() {
    setState(() {
      clearCart();
    });
  }

  void checkout() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sepet onaylandi.'),
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB703),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cartProductCount urun sepette',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(cartTotalPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyCart() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE3E7ED)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF008E7A),
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sepetin bos',
              style: TextStyle(
                color: Color(0xFF16171A),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Oyuncu aksesuarlarini ekleyerek setini hazirlayabilirsin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Alisverise Don'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E7ED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imageUrl,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 76,
                  height: 76,
                  color: const Color(0xFFEDEFF3),
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF16171A),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => removeItem(item),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  formatPrice(item.product.price),
                  style: const TextStyle(
                    color: Color(0xFF008E7A),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE3E7ED)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => decreaseQuantity(item),
                            child: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(Icons.remove, size: 16),
                            ),
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          InkWell(
                            onTap: () => increaseQuantity(item),
                            child: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(Icons.add, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatPrice(item.totalPrice),
                      style: const TextStyle(
                        color: Color(0xFF16171A),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: checkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF16171A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Siparisi Tamamla - ${formatPrice(cartTotalPrice)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = List<CartItem>.from(cartItems);
    final isEmpty = items.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FA),
        surfaceTintColor: const Color(0xFFF4F6FA),
        elevation: 0,
        title: const Text(
          'Sepet',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          if (!isEmpty)
            IconButton(
              onPressed: clearAllItems,
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Sepeti temizle',
            ),
        ],
      ),
      body: SafeArea(
        child: isEmpty
            ? buildEmptyCart()
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    buildSummaryCard(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return buildCartItem(items[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildCheckoutButton(),
                  ],
                ),
              ),
      ),
    );
  }
}
