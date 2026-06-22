class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}

final List<CartItem> cartItems = [];

void addProductToCart(Product product, int quantity) {
  if (quantity <= 0) {
    return;
  }

  final index = cartItems.indexWhere((item) => item.product.id == product.id);

  if (index == -1) {
    cartItems.add(CartItem(product: product, quantity: quantity));
  } else {
    cartItems[index].quantity += quantity;
  }
}

void updateProductQuantity(int productId, int quantity) {
  if (quantity <= 0) {
    cartItems.removeWhere((item) => item.product.id == productId);
    return;
  }

  final index = cartItems.indexWhere((item) => item.product.id == productId);

  if (index != -1) {
    cartItems[index].quantity = quantity;
  }
}

void removeProductFromCart(int productId) {
  cartItems.removeWhere((item) => item.product.id == productId);
}

void clearCart() {
  cartItems.clear();
}

int get cartProductCount {
  return cartItems.fold(0, (total, item) => total + item.quantity);
}

double get cartTotalPrice {
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
}

String formatPrice(double price) {
  final parts = price.toStringAsFixed(2).split('.');
  final whole = parts[0];
  final decimal = parts[1];
  final buffer = StringBuffer();

  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);

    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()},$decimal TL';
}

String shortDescription(Product product) {
  return product.description.split('.').first;
}

List<Map<String, String>> productSpecs(Product product) {
  switch (product.id) {
    case 1:
      return [
        {'title': 'Ses', 'value': '7.1'},
        {'title': 'Mikrofon', 'value': 'Esnek'},
        {'title': 'Baglanti', 'value': 'USB'},
      ];
    case 2:
      return [
        {'title': 'Switch', 'value': 'Red'},
        {'title': 'RGB', 'value': '16.8M'},
        {'title': 'Baglanti', 'value': 'USB-C'},
      ];
    case 3:
      return [
        {'title': 'DPI', 'value': '26000'},
        {'title': 'Agirlik', 'value': '63g'},
        {'title': 'Tepki', 'value': '1ms'},
      ];
    case 4:
      return [
        {'title': 'Baglanti', 'value': 'BT'},
        {'title': 'Pil', 'value': '12 saat'},
        {'title': 'Motor', 'value': 'Cift'},
      ];
    default:
      return [
        {'title': 'Garanti', 'value': '2 yil'},
        {'title': 'Stok', 'value': 'Var'},
        {'title': 'Kargo', 'value': 'Hizli'},
      ];
  }
}

final List<Map<String, dynamic>> dummyProducts = [
  {
    'id': 1,
    'title': 'RGB Oyuncu Kulakligi',
    'price': 2499.90,
    'category': 'Kulaklik',
    'description':
        'Cevresel ses destegi, net mikrofon ve yumusak kulak pedleriyle uzun oyun seanslari icin tasarlandi.',
    'imageUrl':
        'https://images.unsplash.com/photo-1636487658834-26cd5ebb62fb?auto=format&fit=crop&w=900&q=80',
  },
  {
    'id': 2,
    'title': 'Mekanik RGB Klavye',
    'price': 1899.90,
    'category': 'Klavye',
    'description':
        'Mekanik switch yapisi, canli RGB aydinlatma ve saglam govdesiyle hizli oyun kontrolu sunar.',
    'imageUrl':
        'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?auto=format&fit=crop&w=900&q=80',
  },
  {
    'id': 3,
    'title': 'Ultra Hafif Mouse',
    'price': 1299.90,
    'category': 'Mouse',
    'description':
        'Yuksek DPI sensoru, programlanabilir tuslari ve hafif govdesiyle rekabetci oyunlarda hizli tepki verir.',
    'imageUrl':
        'https://images.unsplash.com/photo-1636489895903-931c009d3574?auto=format&fit=crop&w=900&q=80',
  },
  {
    'id': 4,
    'title': 'Kablosuz Oyun Kolu',
    'price': 2199.90,
    'category': 'Gamepad',
    'description':
        'Bluetooth baglanti, ergonomik tutus ve titresim destegiyle PC ve mobil oyunlarda konfor saglar.',
    'imageUrl':
        'https://images.unsplash.com/photo-1691534986201-e68427e5c741?auto=format&fit=crop&w=900&q=80',
  },
];
