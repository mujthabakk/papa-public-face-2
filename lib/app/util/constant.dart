import 'package:salon_user/app/backend/models/language_model.dart';
import 'package:salon_user/app/backend/models/locale_api_model.dart';
import 'package:salon_user/app/env.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;
  static const String defaultCurrencyCode =
      'INR'; // your currency code in 3 digit
  static const String defaultCurrencySide = 'left'; // default currency position
  static const String defaultCurrencySymbol = '₹'; // default currency symbol
  static const String defaultLanguageApp = 'en';
  static const int defaultMakeingOrder =
      0; // 0=> from multiple stores // 1 = single store only
  static const String defaultSMSGateway = '1'; // 2 = firebase // 1 = rest
  static const double defaultDeliverRadius = 50;
  static const int userLogin = 0;
  static const int defaultVerificationForSignup = 0; // 0 = email // 1= phone
  static const int defaultShippingMethod = 0;

  // API Routes

  static const String commonNotificationAll = 'api/v1/notifications/all';
  static const String readNotificationAll = 'api/v1/notifications/read';

  static const String getBannerData = 'api/v1/home/getBannerData';
  static const String getAppSettings = 'api/v1/settings/getDefault';

  static const String getLanguages = 'api/v1/locale/getLanguages';
  static const String getLocaleConfig = 'api/v1/locale/getConfig';
  static const String getUiStrings = 'api/v1/locale/getUiStrings';
  static const String saveUserPreference = 'api/v1/locale/saveUserPreference';
  static const String getActiveCountries = 'api/v1/cities/getActiveCountries';
  static const String getActiveStates = 'api/v1/cities/getActiveStates';
  static const String getAppSettingsByLanguageId =
      'api/v1/settings/getAppSettingsByLanguageId';

  static const String pricingGetTaxSettings = 'api/v1/pricing/getTaxSettings';
  static const String pricingCalculateAppointment =
      'api/v1/pricing/calculateAppointment';
  static const String pricingCalculateProductOrder =
      'api/v1/pricing/calculateProductOrder';
  static const String getFacilities = 'api/v1/facilities/getAll';
  static const String getFacilitiesNew = 'api/v1/facilities/index';

  static const String fetchAutoCompleteServices =
      '${Environments.apiBaseURL}api/v1/services/';

  static const String onlogin = 'api/v1/auth/login';
  static const String loginWithPhonePassword =
      'api/v1/auth/loginWithPhonePassword';
  static const String verifyPhoneFirebase =
      'api/v1/auth/verifyPhoneForFirebase';
  static const String verifyPhone = 'api/v1/otp/verifyPhone';
  static const String loginWithMobileToken = 'api/v1/auth/loginWithMobileOtp';
  static const String updateFCM = 'api/v1/profile/update';
  static const String getHomeData = 'api/v1/salon/getHomeData';
  static const String getAllCategories = 'api/v1/category/getAllCategories';
  static const String getDataFromCategories =
      'api/v1/salon/getDataFromCategory';
  static const String getTopFreelancer = 'api/v1/salon/getTopFreelancer';
  static const String getTopSalon = 'api/v1/salon/getTopSalon';
  static const String getTopPartners = 'api/v1/top_partners/getAll';
  static const String salonDetails = 'api/v1/salon/salonDetails';
  static const String getOwnerReviewsList = 'api/v1/owner_reviews/getMyReviews';

  static const String getWalletAmounts = 'api/v1/profile/getMyWallet';
  static const String getUserByID = 'api/v1/profile/getByID';
  static const String uploadImage = 'api/v1/uploadImage';
  static const String updateInfo = 'api/v1/profile/update';
  static const String getTopProducts = 'api/v1/products/topProducts';
  static const String getServicesById =
      'api/v1/freelancer_services/getByCategoryId';
  static const String getPackagesById = 'api/v1/packages/getPackageDetails';
  static const String getSlotsForBookings =
      'api/v1/timeslots/getSlotsByForBookings';
  static const String createUser = 'api/v1/auth/create_user_account';
  static const String getSpecislistById = 'api/v1/specialist/getSpecialist';
  static const String getCoupons = 'api/v1/offers/getActive';
  static const String getPublicHomeOffers = 'api/v1/offers/getPublicHome';
  static const String getAllOffers = 'api/v1/offers/getAll';
  static const String getTimedOffersHome = 'api/v1/timed_offers/getPublicHome';
  static const String getTimedOffersAll = 'api/v1/timed_offers/getAll';
  static const String getPayments = 'api/v1/payments/getPayments';
  static const String createAppointments = 'api/v1/appoinments/create';
  static const String getUserProfile = 'api/v1/profile/getByID';
  static const String updateProfile = 'api/v1/profile/update';
  static const String createStripeToken = 'api/v1/payments/createStripeToken';
  static const String createStripeCustomer = 'api/v1/payments/createCustomer';
  static const String addStripeCard = 'api/v1/payments/addStripeCards';
  static const String getStripeCards = 'api/v1/payments/getStripeCards';
  static const String stripeCheckout = 'api/v1/payments/createStripePayments';
  static const String payPalPayLink = 'api/v1/payments/payPalPay?amount=';
  static const String payTmPayLink = 'api/v1/payNow?amount=';
  static const String razorPayLink = 'api/v1/payments/razorPay?';
  static const String verifyRazorPayments =
      'api/v1/payments/VerifyRazorPurchase?id=';
  static const String payWithInstaMojo = 'api/v1/payments/instamojoPay';
  static const String paystackCheckout = 'api/v1/payments/paystackPay?';
  static const String flutterwaveCheckout = 'api/v1/payments/flutterwavePay?';
  static const String saveAddress = 'api/v1/address/save';
  static const String getSavedAddress = 'api/v1/address/getByUID';
  static const String updateAddress = 'api/v1/address/update';
  static const String deleteAddress = 'api/v1/address/delete';
  static const String getAddressById = 'api/v1/address/getById';
  static const String individualDetails = 'api/v1/individual/individualDetails';
  static const String getProducts = 'api/v1/product_categories/getHome';
  static const String getProductsByIdAndCateId = 'api/v1/products/getProducts';
  static const String getProductsInfo = 'api/v1/products/getProductInfo';
  static const String productCreate = 'api/v1/product_order/save';
  static const String getOwnerInfo = 'api/v1/profile/getOwnerInfo';
  static const String getAppoimentById = 'api/v1/appoinments/getMyList';
  static const String getAppoimentInfo = 'api/v1/appoinments/getInfo';
  static const String getProductOrderList = 'api/v1/product_order/getByUID';
  static const String getProductOrderInfo = 'api/v1/product_order/getInfo';
  static const String pageContent = 'api/v1/pages/getContent';
  static const String saveaContacts = 'api/v1/contacts/create';
  static const String sendMailToAdmin = 'api/v1/sendMailToAdmin';
  static const String openFirebaseVerification = 'api/v1/auth/firebaseauth?';
  static const String referralCode = 'api/v1/referral/redeemReferral';
  static const String sendVerificationMail = 'api/v1/sendVerificationOnMail';
  static const String verifyOTP = 'api/v1/otp/verifyOTP';
  static const String verifyMobileForeFirebase =
      'api/v1/auth/verifyPhoneForFirebaseRegistrations';
  static const String sendVerificationSMS = 'api/v1/verifyPhoneSignup';
  static const String getMyReferralCode = 'api/v1/referralcode/getMyCode';
  static const String resetWithEmail = 'api/v1/auth/verifyEmailForReset';
  static const String verifyOTPForReset = 'api/v1/otp/verifyOTPReset';
  static const String updatePasswordWithToken =
      'api/v1/password/updateUserPasswordWithEmail';
  static const String searchResult = 'api/v1/salon/getSearchResult';
  static const String getChatConversionList = 'api/v1/chats/getChatListBUid';
  static const String getChatRooms = 'api/v1/chats/getChatRooms';
  static const String createChatRooms = 'api/v1/chats/createChatRooms';
  static const String getChatList = 'api/v1/chats/getById';
  static const String sendMessage = 'api/v1/chats/sendMessage';
  static const String sendNotification = 'api/v1/notification/sendNotification';
  static const String getMyWalletBalance = 'api/v1/profile/getMyWalletBalance';
  static const String checkCod = 'api/v1/salon/check-cod';

  static const String checkPremium = 'api/v1/premium/check';

  static const String paymentsGeneratePaymentUrl =
      'api/v1/payments/generatePaymentUrl';
  static const String paymentsPayNow = 'api/v1/payments/payNow';
  static const String paymentsVerifyPayment = 'api/v1/payments/verifyPayment';
  static const String paymentsVerifyCheckoutPayment =
      'api/v1/payments/verifyCheckoutPayment';
  static const String paymentsGetPaymentOptions =
      'api/v1/payments/getPaymentOptions';
  static const String paymentsGetStatus = 'api/v1/payments/getStatus';
  static const String paymentsGetPaymentStatus =
      'api/v1/payments/getPaymentStatus';
  static const String paymentsSocketConfig = 'api/v1/payments/socketConfig';
  static const String paymentsGetCompleteServiceNotification =
      'api/v1/payments/getCompleteServiceNotification';
  // Partner-only (do NOT call from public app): payments/markCashPaid

  /// Pusher payment realtime (ws-ap2.pusher.com — never api-ap2.pusher.com)
  static const String paymentPusherKey = '69a6a1c7ee697669f24c';
  static const String paymentPusherCluster = 'ap2';
  static const String paymentPusherHost = 'ws-ap2.pusher.com';
  static const int paymentPusherPort = 443;
  static const String paymentPusherWsUrl = 'wss://ws-ap2.pusher.com';
  static const bool paymentPusherForceTls = true;
  // Channel is per-customer: `payment-status-<uid>` (e.g. payment-status-1617).
  // This prefix is only the fallback base when no uid is known yet.
  static const String paymentPusherChannel = 'payment-status';
  // Owner tapped "Service completed" → show the Pay Now modal (payment_url).
  static const String paymentPusherPayNowEvent = 'pay-now-popup';
  // Customer actually paid → mark paid only when payload.is_paid == true.
  static const String paymentPusherEvent = 'payment-completed';

  static const String upgradeGeneratePaymentUrl =
      'api/v1/upgrade/generatePaymentUrl';
  static const String upgradeVerifyPayment = 'api/v1/upgrade/verifyPayment';

  static const String updateAppointmentStatus = 'api/v1/appoinments/update';
  static const String updateProductOrder = 'api/v1/product_order/update';
  static const String getAppointmentsReceipt =
      'api/v1/appointments/orderInvoice?id=';
  static const String getAppointmentsInvoice =
      'api/v1/appointments/printInvoice?id=';
  static const String getProductOrderReceipt =
      'api/v1/product_order/orderInvoice?id=';
  static const String getProductInvoice =
      'api/v1/product_order/printInvoice?id=';
  static const String getOwnerReviews = 'api/v1/owner_reviews/getOwnerReviews';
  static const String saveOwnerReview = 'api/v1/owner_reviews/save';
  static const String updateOwnerReview =
      'api/v1/owner_reviews/updateOwnerReviews';

  static const String getServiceReviews =
      'api/v1/service_reviews/getServiceReview';
  static const String saveServiceReview = 'api/v1/service_reviews/save';
  static const String savePackageReview = 'api/v1/packages_reviews/save';
  static const String getProductsReview =
      'api/v1/products_reviews/getProductsReviews';
  static const String saveProductReview = 'api/v1/products_reviews/save';
  static const String updateProductReviews = 'api/v1/products/update';
  static const String registerComplaints =
      'api/v1/complaints/registerNewComplaints';
  static const String logout = 'api/v1/profile/logout';
  static const String getDelete = 'api/v1/user/delete-account';

  static const String spinnerGetStatus = 'api/v1/spinner/getStatus';
  static const String spinnerSpin = 'api/v1/spinner/spin';
  static const String spinnerRedeem = 'api/v1/spinner/redeem';
  static const String spinnerHistory = 'api/v1/spinner/history';
  static const String spinnerGetSettings = 'api/v1/spinner/getSettings';

  // API Routes

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: '',
        languageName: 'Arabic',
        nativeName: 'العربية',
        countryCode: 'QA',
        languageCode: 'ar',
        direction: 'rtl',
        isRtl: true),
    LanguageModel(
        imageUrl: '',
        languageName: 'Hindi',
        nativeName: 'हिन्दी',
        countryCode: 'IN',
        languageCode: 'hi'),
    LanguageModel(
        imageUrl: '',
        languageName: 'Spanish',
        nativeName: 'Español',
        countryCode: 'ES',
        languageCode: 'es'),
  ];

  static List<LocaleCountryItem> defaultCountries = [
    LocaleCountryItem(
      name: 'India',
      nameEn: 'India',
      code: 'IN',
      countryCode: '+91',
      languages: const ['en', 'hi'],
    ),
    LocaleCountryItem(
      name: 'Qatar',
      nameEn: 'Qatar',
      code: 'QA',
      countryCode: '+974',
      languages: const ['en', 'ar'],
    ),
    LocaleCountryItem(
      name: 'United Arab Emirates',
      nameEn: 'UAE',
      code: 'AE',
      countryCode: '+971',
      languages: const ['en', 'ar'],
    ),
  ];
}
