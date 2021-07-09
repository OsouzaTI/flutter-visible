class ChannelModel {
  Map<String, dynamic> channels;
  ChannelModel(){
    channels = new Map();
  }
}

class Channel {
  String title;
  String logo;
  String link;
  String category;
  Channel(this.title, this.logo, this.link, this.category);
}