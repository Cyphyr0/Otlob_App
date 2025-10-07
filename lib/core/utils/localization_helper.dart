import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../theme/app_typography.dart';

/// Localization Helper
///
/// Provides easy access to localized strings and RTL-aware text styles
/// throughout the application.
///
/// Usage:
/// ```dart
/// Text(
///   LocalizationHelper.of(context).home_featured_restaurants,
///   style: LocalizationHelper.of(context).textTheme.headlineMedium,
/// )
/// ```
class LocalizationHelper {
  final BuildContext context;

  const LocalizationHelper._(this.context);

  /// Get the LocalizationHelper instance for the current context
  static LocalizationHelper of(BuildContext context) {
    return LocalizationHelper._(context);
  }

  // ============================================================================
  // APP INFO STRINGS
  // ============================================================================

  String get app_name => 'app_name'.tr();
  String get app_description => 'app_description'.tr();

  /// Get the current locale
  Locale get currentLocale => context.locale;

  /// Check if the current locale is Arabic
  bool get isArabic => currentLocale.languageCode == 'ar';

  /// Check if the current locale is English
  bool get isEnglish => currentLocale.languageCode == 'en';

  /// Get RTL-aware text theme
  TextTheme get textTheme => AppTypography.getResponsiveTextTheme(context);

  /// Get appropriate text style based on current locale
  TextStyle getResponsiveStyle(TextStyle englishStyle, TextStyle arabicStyle) {
    return AppTypography.getResponsiveTextStyle(englishStyle, arabicStyle, context);
  }

  // ============================================================================
  // NAVIGATION STRINGS
  // ============================================================================

  String get nav_home => 'navigation.home'.tr();
  String get nav_favorites => 'navigation.favorites'.tr();
  String get nav_tawseya => 'navigation.tawseya'.tr();
  String get nav_cart => 'navigation.cart'.tr();
  String get nav_profile => 'navigation.profile'.tr();

  // ============================================================================
  // COMMON STRINGS
  // ============================================================================

  String get common_loading => 'common.loading'.tr();
  String get common_error => 'common.error'.tr();
  String get common_retry => 'common.retry'.tr();
  String get common_cancel => 'common.cancel'.tr();
  String get common_confirm => 'common.confirm'.tr();
  String get common_save => 'common.save'.tr();
  String get common_edit => 'common.edit'.tr();
  String get common_delete => 'common.delete'.tr();
  String get common_add => 'common.add'.tr();
  String get common_remove => 'common.remove'.tr();
  String get common_search => 'common.search'.tr();
  String get common_filter => 'common.filter'.tr();
  String get common_sort => 'common.sort'.tr();
  String get common_next => 'common.next'.tr();
  String get common_previous => 'common.previous'.tr();
  String get common_continue => 'common.continue'.tr();
  String get common_back => 'common.back'.tr();
  String get common_close => 'common.close'.tr();
  String get common_open => 'common.open'.tr();
  String get common_yes => 'common.yes'.tr();
  String get common_no => 'common.no'.tr();
  String get common_ok => 'common.ok'.tr();
  String get common_done => 'common.done'.tr();
  String get common_submit => 'common.submit'.tr();
  String get common_reset => 'common.reset'.tr();

  // ============================================================================
  // AUTHENTICATION STRINGS
  // ============================================================================

  String get auth_login => 'auth.login'.tr();
  String get auth_signup => 'auth.signup'.tr();
  String get auth_logout => 'auth.logout'.tr();
  String get auth_forgot_password => 'auth.forgot_password'.tr();
  String get auth_phone_verification => 'auth.phone_verification'.tr();
  String get auth_enter_phone => 'auth.enter_phone'.tr();
  String get auth_enter_otp => 'auth.enter_otp'.tr();
  String get auth_resend_otp => 'auth.resend_otp'.tr();
  String get auth_verify => 'auth.verify'.tr();
  String get auth_welcome_back => 'auth.welcome_back'.tr();
  String get auth_create_account => 'auth.create_account'.tr();
  String get auth_phone_number => 'auth.phone_number'.tr();
  String get auth_password => 'auth.password'.tr();
  String get auth_confirm_password => 'auth.confirm_password'.tr();
  String get auth_full_name => 'auth.full_name'.tr();
  String get auth_email => 'auth.email'.tr();

  // ============================================================================
  // HOME STRINGS
  // ============================================================================

  String get home_featured_restaurants => 'home.featured_restaurants'.tr();
  String get home_nearby_restaurants => 'home.nearby_restaurants'.tr();
  String get home_popular_cuisines => 'home.popular_cuisines'.tr();
  String get home_quick_orders => 'home.quick_orders'.tr();
  String get home_see_all => 'home.see_all'.tr();
  String get home_categories => 'home.categories'.tr();
  String get home_restaurants => 'home.restaurants'.tr();
  String get home_cuisines => 'home.cuisines'.tr();
  String get home_distance => 'home.distance'.tr();
  String get home_delivery_time => 'home.delivery_time'.tr();
  String get home_min_order => 'home.min_order'.tr();
  String get home_rating => 'home.rating'.tr();
  String get home_reviews => 'home.reviews'.tr();
  String get home_delivery_fee => 'home.delivery_fee'.tr();
  String get home_free_delivery => 'home.free_delivery'.tr();
  String get home_closed => 'home.closed'.tr();
  String get home_open => 'home.open'.tr();
  String get home_busy => 'home.busy'.tr();

  // ============================================================================
  // RESTAURANT STRINGS
  // ============================================================================

  String get restaurant_menu => 'restaurant.menu'.tr();
  String get restaurant_reviews => 'restaurant.reviews'.tr();
  String get restaurant_info => 'restaurant.info'.tr();
  String get restaurant_photos => 'restaurant.photos'.tr();
  String get restaurant_about => 'restaurant.about'.tr();
  String get restaurant_location => 'restaurant.location'.tr();
  String get restaurant_hours => 'restaurant.hours'.tr();
  String get restaurant_contact => 'restaurant.contact'.tr();
  String get restaurant_delivery_areas => 'restaurant.delivery_areas'.tr();
  String get restaurant_minimum_order => 'restaurant.minimum_order'.tr();
  String get restaurant_estimated_delivery => 'restaurant.estimated_delivery'.tr();
  String get restaurant_cuisine_type => 'restaurant.cuisine_type'.tr();
  String get restaurant_price_range => 'restaurant.price_range'.tr();
  String get restaurant_features => 'restaurant.features'.tr();
  String get restaurant_special_offers => 'restaurant.special_offers'.tr();
  String get restaurant_add_to_cart => 'restaurant.add_to_cart'.tr();
  String get restaurant_customize => 'restaurant.customize'.tr();
  String get restaurant_special_instructions => 'restaurant.special_instructions'.tr();
  String get restaurant_quantity => 'restaurant.quantity'.tr();
  String get restaurant_total => 'restaurant.total'.tr();
  String get restaurant_view_menu => 'restaurant.view_menu'.tr();
  String get restaurant_call_now => 'restaurant.call_now'.tr();
  String get restaurant_get_directions => 'restaurant.get_directions'.tr();

  // ============================================================================
  // CART STRINGS
  // ============================================================================

  String get cart_your_order => 'cart.your_order'.tr();
  String get cart_empty_cart => 'cart.empty_cart'.tr();
  String get cart_add_items => 'cart.add_items'.tr();
  String get cart_subtotal => 'cart.subtotal'.tr();
  String get cart_delivery_fee => 'cart.delivery_fee'.tr();
  String get cart_tax => 'cart.tax'.tr();
  String get cart_discount => 'cart.discount'.tr();
  String get cart_total => 'cart.total'.tr();
  String get cart_promo_code => 'cart.promo_code'.tr();
  String get cart_apply_promo => 'cart.apply_promo'.tr();
  String get cart_remove_promo => 'cart.remove_promo'.tr();
  String get cart_checkout => 'cart.checkout'.tr();
  String get cart_continue_shopping => 'cart.continue_shopping'.tr();
  String get cart_order_summary => 'cart.order_summary'.tr();
  String get cart_delivery_address => 'cart.delivery_address'.tr();
  String get cart_payment_method => 'cart.payment_method'.tr();
  String get cart_place_order => 'cart.place_order'.tr();
  String get cart_estimated_delivery => 'cart.estimated_delivery'.tr();
  String get cart_order_notes => 'cart.order_notes'.tr();
  String get cart_special_requests => 'cart.special_requests'.tr();

  // ============================================================================
  // FAVORITES STRINGS
  // ============================================================================

  String get favorites_your_favorites => 'favorites.your_favorites'.tr();
  String get favorites_no_favorites => 'favorites.no_favorites'.tr();
  String get favorites_add_favorites => 'favorites.add_favorites'.tr();
  String get favorites_recent_orders => 'favorites.recent_orders'.tr();
  String get favorites_order_again => 'favorites.order_again'.tr();
  String get favorites_remove_favorite => 'favorites.remove_favorite'.tr();

  // ============================================================================
  // TAWSEYA STRINGS
  // ============================================================================

  String get tawseya_tawseya_voting => 'tawseya.tawseya_voting'.tr();
  String get tawseya_vote_for_restaurants => 'tawseya.vote_for_restaurants'.tr();
  String get tawseya_current_period => 'tawseya.current_period'.tr();
  String get tawseya_voting_ends => 'tawseya.voting_ends'.tr();
  String get tawseya_vote_count => 'tawseya.vote_count'.tr();
  String get tawseya_top_restaurants => 'tawseya.top_restaurants'.tr();
  String get tawseya_your_votes => 'tawseya.your_votes'.tr();
  String get tawseya_vote_now => 'tawseya.vote_now'.tr();
  String get tawseya_already_voted => 'tawseya.already_voted'.tr();
  String get tawseya_voting_closed => 'tawseya.voting_closed'.tr();
  String get tawseya_next_round => 'tawseya.next_round'.tr();
  String get tawseya_results => 'tawseya.results'.tr();
  String get tawseya_winners => 'tawseya.winners'.tr();
  String get tawseya_participants => 'tawseya.participants'.tr();

  // ============================================================================
  // PROFILE STRINGS
  // ============================================================================

  String get profile_my_profile => 'profile.my_profile'.tr();
  String get profile_edit_profile => 'profile.edit_profile'.tr();
  String get profile_personal_info => 'profile.personal_info'.tr();
  String get profile_delivery_addresses => 'profile.delivery_addresses'.tr();
  String get profile_order_history => 'profile.order_history'.tr();
  String get profile_payment_methods => 'profile.payment_methods'.tr();
  String get profile_notifications => 'profile.notifications'.tr();
  String get profile_preferences => 'profile.preferences'.tr();
  String get profile_language => 'profile.language'.tr();
  String get profile_theme => 'profile.theme'.tr();
  String get profile_privacy => 'profile.privacy'.tr();
  String get profile_help_support => 'profile.help_support'.tr();
  String get profile_about => 'profile.about'.tr();
  String get profile_terms => 'profile.terms'.tr();
  String get profile_privacy_policy => 'profile.privacy_policy'.tr();
  String get profile_contact_us => 'profile.contact_us'.tr();
  String get profile_logout => 'profile.logout'.tr();
  String get profile_delete_account => 'profile.delete_account'.tr();
  String get profile_account_settings => 'profile.account_settings'.tr();
  String get profile_notification_settings => 'profile.notification_settings'.tr();
  String get profile_email_notifications => 'profile.email_notifications'.tr();
  String get profile_sms_notifications => 'profile.sms_notifications'.tr();
  String get profile_push_notifications => 'profile.push_notifications'.tr();

  // ============================================================================
  // ORDER STRINGS
  // ============================================================================

  String get orders_order_status => 'orders.order_status'.tr();
  String get orders_track_order => 'orders.track_order'.tr();
  String get orders_order_placed => 'orders.order_placed'.tr();
  String get orders_confirmed => 'orders.confirmed'.tr();
  String get orders_preparing => 'orders.preparing'.tr();
  String get orders_ready => 'orders.ready'.tr();
  String get orders_on_the_way => 'orders.on_the_way'.tr();
  String get orders_delivered => 'orders.delivered'.tr();
  String get orders_cancelled => 'orders.cancelled'.tr();
  String get orders_order_details => 'orders.order_details'.tr();
  String get orders_order_number => 'orders.order_number'.tr();
  String get orders_order_date => 'orders.order_date'.tr();
  String get orders_estimated_arrival => 'orders.estimated_arrival'.tr();
  String get orders_delivery_address => 'orders.delivery_address'.tr();
  String get orders_contactless_delivery => 'orders.contactless_delivery'.tr();
  String get orders_order_again => 'orders.order_again'.tr();
  String get orders_rate_order => 'orders.rate_order'.tr();
  String get orders_report_issue => 'orders.report_issue'.tr();
  String get orders_order_total => 'orders.order_total'.tr();
  String get orders_payment_status => 'orders.payment_status'.tr();
  String get orders_paid => 'orders.paid'.tr();
  String get orders_pending => 'orders.pending'.tr();
  String get orders_failed => 'orders.failed'.tr();
  String get orders_refunded => 'orders.refunded'.tr();

  // ============================================================================
  // PAYMENT STRINGS
  // ============================================================================

  String get payment_payment_methods => 'payment.payment_methods'.tr();
  String get payment_add_payment_method => 'payment.add_payment_method'.tr();
  String get payment_credit_card => 'payment.credit_card'.tr();
  String get payment_debit_card => 'payment.debit_card'.tr();
  String get payment_cash_on_delivery => 'payment.cash_on_delivery'.tr();
  String get payment_digital_wallet => 'payment.digital_wallet'.tr();
  String get payment_card_number => 'payment.card_number'.tr();
  String get payment_expiry_date => 'payment.expiry_date'.tr();
  String get payment_cvv => 'payment.cvv'.tr();
  String get payment_card_holder_name => 'payment.card_holder_name'.tr();
  String get payment_save_card => 'payment.save_card'.tr();
  String get payment_remove_card => 'payment.remove_card'.tr();
  String get payment_set_default => 'payment.set_default'.tr();
  String get payment_payment_failed => 'payment.payment_failed'.tr();
  String get payment_payment_successful => 'payment.payment_successful'.tr();
  String get payment_retry_payment => 'payment.retry_payment'.tr();
  String get payment_choose_payment => 'payment.choose_payment'.tr();
  String get payment_secure_payment => 'payment.secure_payment'.tr();
  String get payment_payment_processing => 'payment.payment_processing'.tr();

  // ============================================================================
  // LOCATION STRINGS
  // ============================================================================

  String get location_current_location => 'location.current_location'.tr();
  String get location_set_location => 'location.set_location'.tr();
  String get location_delivery_address => 'location.delivery_address'.tr();
  String get location_add_address => 'location.add_address'.tr();
  String get location_edit_address => 'location.edit_address'.tr();
  String get location_remove_address => 'location.remove_address'.tr();
  String get location_set_as_default => 'location.set_as_default'.tr();
  String get location_address_book => 'location.address_book'.tr();
  String get location_search_location => 'location.search_location'.tr();
  String get location_use_current_location => 'location.use_current_location'.tr();
  String get location_enter_address => 'location.enter_address'.tr();
  String get location_street => 'location.street'.tr();
  String get location_building => 'location.building'.tr();
  String get location_floor => 'location.floor'.tr();
  String get location_apartment => 'location.apartment'.tr();
  String get location_city => 'location.city'.tr();
  String get location_governorate => 'location.governorate'.tr();
  String get location_postal_code => 'location.postal_code'.tr();
  String get location_special_instructions => 'location.special_instructions'.tr();
  String get location_delivery_instructions => 'location.delivery_instructions'.tr();
  String get location_save_address => 'location.save_address'.tr();
  String get location_address_saved => 'location.address_saved'.tr();
  String get location_location_permission => 'location.location_permission'.tr();
  String get location_enable_location => 'location.enable_location'.tr();
  String get location_location_required => 'location.location_required'.tr();

  // ============================================================================
  // SEARCH STRINGS
  // ============================================================================

  String get search_search_restaurants => 'search.search_restaurants'.tr();
  String get search_search_results => 'search.search_results'.tr();
  String get search_no_results => 'search.no_results'.tr();
  String get search_try_different_search => 'search.try_different_search'.tr();
  String get search_popular_searches => 'search.popular_searches'.tr();
  String get search_recent_searches => 'search.recent_searches'.tr();
  String get search_clear_history => 'search.clear_history'.tr();
  String get search_search_filters => 'search.search_filters'.tr();
  String get search_cuisine => 'search.cuisine'.tr();
  String get search_price_range => 'search.price_range'.tr();
  String get search_rating => 'search.rating'.tr();
  String get search_delivery_time => 'search.delivery_time'.tr();
  String get search_features => 'search.features'.tr();
  String get search_sort_by => 'search.sort_by'.tr();
  String get search_relevance => 'search.relevance'.tr();
  String get search_distance => 'search.distance'.tr();
  String get search_delivery_fee => 'search.delivery_fee'.tr();
  String get search_estimated_time => 'search.estimated_time'.tr();

  // ============================================================================
  // ERROR STRINGS
  // ============================================================================

  String get errors_network_error => 'errors.network_error'.tr();
  String get errors_connection_failed => 'errors.connection_failed'.tr();
  String get errors_server_error => 'errors.server_error'.tr();
  String get errors_timeout_error => 'errors.timeout_error'.tr();
  String get errors_unauthorized => 'errors.unauthorized'.tr();
  String get errors_forbidden => 'errors.forbidden'.tr();
  String get errors_not_found => 'errors.not_found'.tr();
  String get errors_internal_error => 'errors.internal_error'.tr();
  String get errors_unknown_error => 'errors.unknown_error'.tr();
  String get errors_retry_later => 'errors.retry_later'.tr();
  String get errors_check_connection => 'errors.check_connection'.tr();
  String get errors_something_wrong => 'errors.something_wrong'.tr();
  String get errors_failed_to_load => 'errors.failed_to_load'.tr();
  String get errors_no_data => 'errors.no_data'.tr();
  String get errors_invalid_input => 'errors.invalid_input'.tr();
  String get errors_required_field => 'errors.required_field'.tr();
  String get errors_invalid_format => 'errors.invalid_format'.tr();
  String get errors_too_short => 'errors.too_short'.tr();
  String get errors_too_long => 'errors.too_long'.tr();
  String get errors_invalid_email => 'errors.invalid_email'.tr();
  String get errors_invalid_phone => 'errors.invalid_phone'.tr();
  String get errors_password_mismatch => 'errors.password_mismatch'.tr();
  String get errors_weak_password => 'errors.weak_password'.tr();

  // ============================================================================
  // SUCCESS STRINGS
  // ============================================================================

  String get success_login_successful => 'success.login_successful'.tr();
  String get success_signup_successful => 'success.signup_successful'.tr();
  String get success_order_placed => 'success.order_placed'.tr();
  String get success_payment_successful => 'success.payment_successful'.tr();
  String get success_address_saved => 'success.address_saved'.tr();
  String get success_profile_updated => 'success.profile_updated'.tr();
  String get success_password_changed => 'success.password_changed'.tr();
  String get success_logout_successful => 'success.logout_successful'.tr();
  String get success_item_added => 'success.item_added'.tr();
  String get success_item_removed => 'success.item_removed'.tr();
  String get success_favorite_added => 'success.favorite_added'.tr();
  String get success_favorite_removed => 'success.favorite_removed'.tr();
  String get success_vote_cast => 'success.vote_cast'.tr();
  String get success_review_submitted => 'success.review_submitted'.tr();

  // ============================================================================
  // CURRENCY STRINGS
  // ============================================================================

  String get currency_egp => 'currency.egp'.tr();
  String get currency_symbol => 'currency.symbol'.tr();

  // ============================================================================
  // DATE TIME STRINGS
  // ============================================================================

  String get date_time_today => 'date_time.today'.tr();
  String get date_time_tomorrow => 'date_time.tomorrow'.tr();
  String get date_time_yesterday => 'date_time.yesterday'.tr();
  String get date_time_minutes => 'date_time.minutes'.tr();
  String get date_time_hours => 'date_time.hours'.tr();
  String get date_time_days => 'date_time.days'.tr();
  String get date_time_weeks => 'date_time.weeks'.tr();
  String get date_time_months => 'date_time.months'.tr();
  String get date_time_years => 'date_time.years'.tr();
  String get date_time_ago => 'date_time.ago'.tr();
  String get date_time_in => 'date_time.in'.tr();
  String get date_time_now => 'date_time.now'.tr();
  String get date_time_just_now => 'date_time.just_now'.tr();
  String get date_time_minute_ago => 'date_time.minute_ago'.tr();
  String get date_time_hour_ago => 'date_time.hour_ago'.tr();
  String get date_time_day_ago => 'date_time.day_ago'.tr();
  String get date_time_week_ago => 'date_time.week_ago'.tr();
  String get date_time_month_ago => 'date_time.month_ago'.tr();
  String get date_time_year_ago => 'date_time.year_ago'.tr();
}