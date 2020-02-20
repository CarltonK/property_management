class Payment {
  String month;
  int rent;
  DateTime date;

  Payment({this.month, this.rent, this.date});
}

//Define custom Payments
//This will be replaced by network calls
Payment june =
    Payment(month: 'June', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment july =
    Payment(month: 'July', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment august =
    Payment(month: 'August', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment september =
    Payment(month: 'September', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment october =
    Payment(month: 'October', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment november =
    Payment(month: 'November', rent: 12000, date: DateTime.utc(2019, 6, 5));
Payment december =
    Payment(month: 'December', rent: 12000, date: DateTime.utc(2019, 6, 5));
