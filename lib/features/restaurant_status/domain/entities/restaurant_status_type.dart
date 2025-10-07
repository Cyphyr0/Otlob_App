enum RestaurantStatusType {
  open('Open', 'مفتوح'),
  closed('Closed', 'مغلق'),
  renovation('Under Renovation', 'تحت الترميم'),
  repairs('Under Repairs', 'تحت الإصلاح'),
  maintenance('Maintenance', 'صيانة'),
  permanentlyClosed('Permanently Closed', 'مغلق نهائياً');

  const RestaurantStatusType(this.englishName, this.arabicName);

  final String englishName;
  final String arabicName;

  String getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return arabicName;
      default:
        return englishName;
    }
  }

  bool get isOperational => this == RestaurantStatusType.open;

  bool get isTemporarilyUnavailable => this == RestaurantStatusType.renovation ||
           this == RestaurantStatusType.repairs ||
           this == RestaurantStatusType.maintenance;

  bool get isPermanentlyUnavailable => this == RestaurantStatusType.permanentlyClosed;
}