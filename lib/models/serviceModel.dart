class ServiceModel {
  String title;
  String url;

  ServiceModel({this.title, this.url});
}

ServiceModel cleaning = ServiceModel(title: 'cleaning', url: '');
ServiceModel plumbing = ServiceModel(title: 'plumbing', url: '');
ServiceModel electrical = ServiceModel(title: 'electrical', url: '');
ServiceModel delivery = ServiceModel(title: 'delivery', url: '');

List<ServiceModel> appServices = [cleaning, plumbing, electrical, delivery];
