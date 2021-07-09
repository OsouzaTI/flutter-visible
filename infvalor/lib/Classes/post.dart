class Post {
  final String name;
  final String maior;
  final String menor;
  final String compra;
  final String venda;
  final String variacao;
  final String p_variacao;
  final String date;

  Post({
    required this.name,
    required this.maior,
    required this.menor,
    required this.compra,
    required this.venda,
    required this.variacao,
    required this.p_variacao,
    required this.date
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      maior: json['high'],
      menor: json['low'],
      compra: json['bid'],
      venda: json['ask'],
      variacao: json['varBid'],
      p_variacao: json['pctChange'],
      date: json['timestamp'],
    );
  }
}
