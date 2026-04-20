import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static const String appName = 'PapaBear';
  static const String companyName = 'PapaBear';
  static const String googleMapsKey = 'AIzaSyAm5bmta_KNZlZBGUlmpmrr-oWP1QYI4_I';

  //static const String apiBaseURL = 'https://leadfutureai.com/';
  static const String apiBaseURL = 'https://adminpapa.papabear4u.com/';

  static const String websiteURL = 'https://adminpapa.papabear4u.com/';

  //   static const String apiBaseURL = 'https://giatraders.com/';

  // static const String websiteURL = 'https://giatraders.com/';
  static const String imageURL =
      'https://papa-bear.blr1.digitaloceanspaces.com/';

  // static const String apiBaseURL =
  //     'https://multi-salon-api.initappz.com/public/';
  // static const String websiteURL = 'https://papabear.techinwallet.com/';
  // static const String imageURL =
  //     'https://multi-salon-api.initappz.com/public/storage/images/';

  /// Razorpay Key ID loaded from .env file (RAZORPAY_KEY)
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY'] ?? '';
}
