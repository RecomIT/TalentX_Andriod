 class  DateService{
  DateService();

  DateTime getDateFromDDMMMYYYY(String date) {
  var dateArrey= date.trim().split('-');

    int day=int.parse(dateArrey[0]);
    int month= getMonthNo(dateArrey[1].toString());
    int year=int.parse(dateArrey[2]);
    return DateTime(year,month,day);
  }

  int getMonthNo(String name)
  {
    int month;
    switch (name) {
    case 'Jan':
      month=1;
      break;
     case 'Feb':
       month=2;
    break;
    case 'Mar':
      month=3;
  break;
  case 'Apr':
    month=4;
  break;
  case 'May':
    month=5;
  break;
  case 'Jun':
    month=6;
  break;
  case 'Jul':
    month=7;
  break;
  case 'Aug':
    month=8;
  break;
  case 'Sep':
    month=9;
  break;
  case 'Oct':
    month=10;
    break;
    case 'Nov':
      month=11;
  break;
      default:month=12;
  }
    return month;
  }
}
