import 'dart:math';

/// Cultural hospitality service for Egyptian market
class CulturalHospitalityService {
  static const List<String> _welcomeMessages = [
    'أهلاً وسهلاً بيك في اطلب! 🍽️',
    'مرحباً بك في أفضل تجربة طعام مصري! 🇪🇬',
    'أهلاً وسهلاً! جاهزين نخدمك أحلى الأكلات 🎉',
    'مرحباً بك في عالم الطعام المصري الأصيل 🌟',
    'أهلاً بيك! خلينا نختار لك أحلى الوجبات 😋',
  ];

  static const List<String> _orderConfirmationMessages = [
    'شكراً ليك! طلبك هيوصلك قريب إن شاء الله 🙏',
    'تم استلام طلبك بنجاح! سعيدين نخدمك 🎯',
    'شكراً لثقتك فينا! الطلب في الطريق إليك 🚚',
    'طلبك معانا هوصلك بالسلامة إن شاء الله ✨',
    'شكراً ليك! فريقنا هيبدأ في تحضير طلبك حالا ⏰',
  ];

  static const List<String> _deliveryGreetings = [
    'تفضل يا فندم! بالهنا والشفا 🍽️',
    'جايبالك الطلب سخن وطازج! استمتع بوجبتك 😊',
    'بالف هنا! يدوم الود والطعام الحلو 🙏',
    'تفضل الطلب! أكل طازج وحلو زي ما تحب 🎉',
    'جايب لك اللي يفرح قلبك! بالعافية عليك 🌟',
  ];

  static const List<String> _ramadanGreetings = [
    'رمضان كريم! 🌙',
    'كل عام وأنت بخير في رمضان مبارك ✨',
    'رمضان كريم عليك وعلى أسرتك 🙏',
    'صوم مقبول وإفطار شهي! 🕌',
    'اللهم بلغنا رمضان وأنت راضٍ عنا 🌙',
  ];

  static const List<String> _eidGreetings = [
    'عيد سعيد! 🎉',
    'كل عام وأنتم بخير في عيد الفطر المبارك 🌙',
    'تقبل الله منا ومنكم صالح الأعمال 🕌',
    'عيد مبارك عليك وعلى أسرتك الكريمة 🙏',
    'الله أكبر! عيد سعيد وكل عام وأنتم بخير 🎊',
  ];

  static const List<String> _hospitalityPhrases = [
    'بالهنا والشفا',
    'سعيدين بخدمتك',
    'أهلاً وسهلاً بيك',
    'تفضل يا فندم',
    'بالف هنا',
    'بالعافية عليك',
    'ربنا يخليك',
    'شكراً لثقتك فينا',
    'فرصة سعيدة نخدمك',
    'أمرك يا فندم',
  ];

  /// Get random welcome message
  static String getRandomWelcomeMessage() => _welcomeMessages[Random().nextInt(_welcomeMessages.length)];

  /// Get random order confirmation message
  static String getRandomOrderConfirmationMessage() => _orderConfirmationMessages[Random().nextInt(_orderConfirmationMessages.length)];

  /// Get random delivery greeting
  static String getRandomDeliveryGreeting() => _deliveryGreetings[Random().nextInt(_deliveryGreetings.length)];

  /// Get Ramadan greeting if it's Ramadan
  static String? getRamadanGreeting() {
    // This would check actual Ramadan dates in production
    // For now, return a greeting during Ramadan months
    final now = DateTime.now();
    if (now.month == 3 || now.month == 4) { // Ramadan typically in March/April
      return _ramadanGreetings[Random().nextInt(_ramadanGreetings.length)];
    }
    return null;
  }

  /// Get Eid greeting if it's Eid time
  static String? getEidGreeting() {
    // This would check actual Eid dates in production
    // For now, return a greeting during Eid months
    final now = DateTime.now();
    if (now.month == 4 || now.month == 6) { // Eid al-Fitr and Eid al-Adha
      return _eidGreetings[Random().nextInt(_eidGreetings.length)];
    }
    return null;
  }

  /// Get random hospitality phrase
  static String getRandomHospitalityPhrase() => _hospitalityPhrases[Random().nextInt(_hospitalityPhrases.length)];

  /// Get culturally appropriate response based on time of day
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'صباح الخير! أهلاً بيك في اطلب ☀️';
    } else if (hour < 17) {
      return 'مساء الخير! سعيدين نشوفك في اطلب 🌅';
    } else {
      return 'مساء النور! أهلاً بيك في اطلب في المساء 🌙';
    }
  }

  /// Get culturally appropriate waiting message
  static String getWaitingMessage() {
    final messages = [
      'بنجهز طلبك حالا... يرجى الانتظار قليلاً ⏳',
      'فريقنا بيحضر طلبك بعناية... لحظات ويوصلك 🕐',
      'شكراً لصبرك! طلبك هيوصلك قريب إن شاء الله 🙏',
      'بنأكد من جودة طلبك... لحظة ونكمل لك الطلب ✨',
    ];

    return messages[Random().nextInt(messages.length)];
  }

  /// Get culturally appropriate error message
  static String getErrorMessage(String errorType) {
    switch (errorType) {
      case 'network':
        return 'عذراً، في مشكلة في الاتصال بالإنترنت 📡\nجرب تاني بعد شوية';
      case 'location':
        return 'محتاجين نعرف موقعك عشان نقدر نوصلك الطلب 📍\nفعل خدمات الموقع من الإعدادات';
      case 'payment':
        return 'عذراً، في مشكلة في الدفع 💳\nجرب طريقة دفع تانية أو اتصل بالدعم';
      case 'restaurant_closed':
        return 'عذراً، المطعم مقفول دلوقتي 🏪\nجرب مطعم تاني أو انتظر لما يفتح';
      default:
        return 'عذراً، حصل خطأ غير متوقع 😔\nجرب تاني أو اتصل بالدعم الفني';
    }
  }

  /// Get culturally appropriate success message
  static String getSuccessMessage(String action) {
    switch (action) {
      case 'order_placed':
        return 'تم الطلب بنجاح! 🎉\nفريقنا هيبدأ في التحضير حالا';
      case 'payment_successful':
        return 'تم الدفع بنجاح! ✅\nشكراً لثقتك فينا';
      case 'address_saved':
        return 'تم حفظ العنوان بنجاح! 📍\nهيسهل عليك الطلب المرة الجاية';
      case 'favorite_added':
        return 'تم إضافة المطعم للمفضلة! ❤️\nهيظهر في قسم المفضلة';
      default:
        return 'تم بنجاح! ✅';
    }
  }

  /// Get culturally appropriate notification title
  static String getNotificationTitle(String type) {
    switch (type) {
      case 'order_confirmed':
        return 'طلبك تم تأكيده ✅';
      case 'order_preparing':
        return 'طلبك قيد التحضير 👨‍🍳';
      case 'order_ready':
        return 'طلبك جاهز للتوصيل 🚚';
      case 'order_on_way':
        return 'طلبك في الطريق إليك 🛵';
      case 'order_delivered':
        return 'طلبك وصل! بالهنا والشفا 🍽️';
      case 'prayer_time':
        return 'حان وقت الصلاة 🕌';
      default:
        return 'اطلب - إشعار جديد 🔔';
    }
  }

  /// Get culturally appropriate notification body
  static String getNotificationBody(String type, {String? details}) {
    switch (type) {
      case 'order_confirmed':
        return 'طلبك رقم ${details ?? '#XXXX'} تم تأكيده وفريقنا هيبدأ في التحضير';
      case 'order_preparing':
        return 'الشيف بيحضر طلبك بعناية... هيخلص قريب إن شاء الله 👨‍🍳';
      case 'order_ready':
        return 'طلبك جاهز! السائق هيوصلك خلال دقائق معدودة 🚚';
      case 'order_on_way':
        return 'السائق ${details ?? 'محمد'} في الطريق إليك... انتظر الجرس 🛵';
      case 'order_delivered':
        return 'طلبك وصل بالسلامة! بالهنا والشفا وتقبل الله صالح الأعمال 🍽️';
      case 'prayer_time':
        return 'حان وقت صلاة ${details ?? 'الفجر'}... ربنا يتقبل منك ومنا 🙏';
      default:
        return details ?? 'لديك إشعار جديد من اطلب';
    }
  }

  /// Get culturally appropriate promotional message
  static String getPromotionalMessage(String occasion) {
    switch (occasion) {
      case 'ramadan':
        return 'رمضان كريم! عرض خاص: خصم 20% على جميع الوجبات الرئيسية 🌙✨';
      case 'eid':
        return 'عيد سعيد! احتفل مع اطلب بخصم 15% على جميع الطلبات 🎉';
      case 'national_holiday':
        return 'عيد تحرير سيناء مبارك! احتفل معنا بخصم خاص 🇪🇬';
      case 'weekend':
        return 'ويك إند سعيد! استمتع بوجبتك المفضلة مع خصم 10% 😊';
      default:
        return 'عرض خاص ليك النهارده! خصم 10% على طلبك الأول 🎁';
    }
  }

  /// Get culturally appropriate support message
  static String getSupportMessage() {
    final messages = [
      'فريق الدعم متاح 24/7 عشان يساعدك في أي حاجة تحتاجها 📞',
      'لو عندك أي استفسار أو مشكلة، فريقنا جاهز يساعدك في أي وقت 💬',
      'بنقدر ثقتك فينا وفريق الدعم موجود عشان يضمن لك أحسن تجربة 🤝',
      'أي سؤال أو اقتراح، فريق الدعم سعيد يسمع منك ويساعدك 🙋‍♂️',
    ];

    return messages[Random().nextInt(messages.length)];
  }

  /// Get culturally appropriate rating request
  static String getRatingRequestMessage() {
    final messages = [
      'لو عجبتك الخدمة، قيمنا بخمس نجوم عشان نستمر في تطوير الخدمة ⭐⭐⭐⭐⭐',
      'رأيك مهم بالنسبة لنا! قيم تجربتك وقلنا رأيك في الخدمة 💭',
      'سعيدين بخدمتك ونتمنى تقييمنا لو عجبتك الوجبة والخدمة 🌟',
      'لو الخدمة عجبتك، قيمنا بخمس نجوم عشان نستمر في التميز ⭐',
    ];

    return messages[Random().nextInt(messages.length)];
  }

  /// Get culturally appropriate loyalty message
  static String getLoyaltyMessage(int orderCount) {
    if (orderCount >= 50) {
      return 'عميل مميز! شكراً لثقتك المستمرة فينا من أول $orderCount طلب 🌟';
    } else if (orderCount >= 20) {
      return 'عميل وفي! سعيدين بيك معانا من $orderCount طلب سابق 💝';
    } else if (orderCount >= 10) {
      return 'شكراً ليك! $orderCount طلب معانا ومستمرين مع بعض 😊';
    } else if (orderCount >= 5) {
      return 'بتصير من عملاءنا المميزين! $orderCount طلب سابق معانا 🎯';
    } else {
      return 'شكراً لثقتك فينا! نتمنى نكون عند حسن ظنك دايماً 🙏';
    }
  }

  /// Get culturally appropriate seasonal message
  static String getSeasonalMessage() {
    final month = DateTime.now().month;
    final day = DateTime.now().day;

    // Ramadan (typically March/April)
    if (month == 3 || month == 4) {
      return 'رمضان كريم! جرب وجباتنا الخاصة بشهر رمضان المبارك 🌙';
    }

    // Eid al-Fitr (typically April/May)
    if ((month == 4 && day >= 20) || (month == 5 && day <= 5)) {
      return 'عيد سعيد! احتفل مع اطلب بعروض خاصة في العيد 🎉';
    }

    // Summer
    if (month >= 6 && month <= 8) {
      return 'صيف سعيد! جرب مشروباتنا الباردة ووجباتنا الخفيفة 🏖️';
    }

    // Winter
    if (month >= 12 || month <= 2) {
      return 'شتاء دافئ! جرب حساءنا الساخن ووجباتنا الشتوية المميزة ❄️';
    }

    return 'استمتع بأحلى الوجبات في أي وقت مع اطلب 😋';
  }

  /// Get culturally appropriate food blessing
  static String getFoodBlessing() {
    final blessings = [
      'بالهنا والشفا وربنا يديمها نعمة في حياتك 🍽️',
      'بالعافية عليك وربنا يحفظك ويحميك 🙏',
      'بالف هنا وهنا وشفا وعافية عليك وعلى أسرتك 💝',
      'ربنا يديم الخير والبركة في بيتك وأسرتك 🌟',
      'بالهنا والشفا وتقبل الله صالح الأعمال 🕌',
    ];

    return blessings[Random().nextInt(blessings.length)];
  }

  /// Get culturally appropriate apology message
  static String getApologyMessage(String issue) {
    switch (issue) {
      case 'late_delivery':
        return 'عذراً على التأخير! بنعتذر عن أي إزعاج سببناه لك ⏰';
      case 'wrong_order':
        return 'عذراً على الخطأ في الطلب! بنصلح الموضوع حالا ونعوضك عن أي إزعاج 🛠️';
      case 'cold_food':
        return 'عذراً لو الطعام وصل بارد! بنهتم بجودة الطعام ونعتذر عن التقصير 🌡️';
      case 'missing_item':
        return 'عذراً لو في حاجة ناقصة في الطلب! بنكملها لك حالا ونعتذر عن الإزعاج 📦';
      default:
        return 'عذراً على أي إزعاج! بنعتذر عن التقصير وفريقنا هيحل المشكلة حالا 🙏';
    }
  }

  /// Get culturally appropriate celebration message
  static String getCelebrationMessage(String occasion) {
    switch (occasion) {
      case 'first_order':
        return 'أهلاً بيك في عائلة اطلب! 🎉\nأول طلب ليك ودايماً معانا إن شاء الله';
      case 'milestone_order':
        return 'تهانينا! وصلت لـ $occasion طلب مع اطلب 🎊\nشكراً لثقتك المستمرة فينا';
      case 'birthday':
        return 'عيد ميلاد سعيد! 🎂\nنتمنى لك سنة سعيدة مليانة بالخير والبركة';
      default:
        return 'تهانينا! 🎉\nفرصة سعيدة ودايماً مبسوط مع اطلب';
    }
  }

  /// Get culturally appropriate weather-based message
  static String getWeatherBasedMessage(String weather) {
    switch (weather.toLowerCase()) {
      case 'hot':
      case 'sunny':
        return 'جو حر النهارده! جرب مشروباتنا الباردة وسلطاتنا الطازجة 🥤';
      case 'cold':
      case 'rainy':
        return 'جو برد النهارده! جرب حساءنا الساخن ووجباتنا الشتوية الدافئة ☕';
      case 'rainy':
        return 'مطر خير النهارده! استمتع بوجبتك في البيت مع اطلب 🌧️';
      default:
        return 'استمتع بوجبتك في أي جو مع اطلب 😊';
    }
  }

  /// Get culturally appropriate traffic message
  static String getTrafficMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 7 && hour <= 9) {
      return 'زحمة صباحية متوقعة... بس فريقنا هيوصلك الطلب في وقته 🚗';
    } else if (hour >= 17 && hour <= 19) {
      return 'زحمة مسائية متوقعة... بس السائقين عندنا متميزين وهيوصلوك 🚛';
    } else {
      return 'فريقنا ملتزم بالوقت وهيوصلك طلبك بالسلامة ⏰';
    }
  }

  /// Get culturally appropriate new user onboarding message
  static String getNewUserOnboardingMessage() {
    final messages = [
      'مرحباً بيك في اطلب! خلينا نختار لك أحلى المطاعم في منطقتك 🗺️',
      'أهلاً وسهلاً! أول مرة مع اطلب؟ هتعيش تجربة طعام مميزة معانا 🎯',
      'مرحباً بك في عائلتنا! جاهزين نقدم لك أحسن خدمة طعام في مصر 🇪🇬',
      'سعيدين بانضمامك لنا! خلينا نستكشف مع بعض أحلى الأكلات المصرية 🍽️',
    ];

    return messages[Random().nextInt(messages.length)];
  }

  /// Get culturally appropriate re-engagement message
  static String getReengagementMessage(int daysSinceLastOrder) {
    if (daysSinceLastOrder >= 30) {
      return 'فات كتير من أول ما طلبت معانا! 😊\nجرب أكلاتنا الجديدة واستمتع بالخصومات';
    } else if (daysSinceLastOrder >= 14) {
      return 'بنشتاق لك! جرب وجباتنا الجديدة واستمتع بعروض خاصة للعملاء الوفيين 💝';
    } else if (daysSinceLastOrder >= 7) {
      return 'أسبوع من أول طلبك الأخير! جرب حاجة جديدة من قائمتنا المتنوعة 😋';
    } else {
      return 'بنتمنى نكون عند حسن ظنك دايماً! جرب وجباتنا الجديدة 🎁';
    }
  }
}