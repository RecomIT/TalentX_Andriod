import 'package:recom_app/views/pages/edit_settlement_page.dart';

class ConveyanceViewModel {
  int id;
  List<String> travel_date;
  List<String> purpose;
  List<String> mode_of_transport;
  List<double> transport;
  List<double> food;
  List<double> other;
  List<double> total;
  List<String> location;
  List<String> remarks;
  List<AttachmentModel> attachments;

  ConveyanceViewModel(){
    this.id=0;
    this.travel_date = <String>[];
    this.purpose= <String>[];
    this.mode_of_transport= <String>[];
    this.transport = <double>[];
    this.food= <double>[];
    this.other= <double>[];
    this.total= <double>[];
    this.location= <String>[];
    this.remarks= <String>[];
    this.attachments= <AttachmentModel>[];
  }

  // ConveyanceViewModel(){
  //   this.travel_date= <String>[];
  //   this.remarks=<String>[];
  // }
}