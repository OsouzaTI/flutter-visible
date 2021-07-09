import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  Color c1 = const Color(0xFF2196f3);
  Color c2 = const Color(0xFF3babf7);
  Color c3 = const Color(0xFF2c98e0);
  Color c4 = const Color(0xFF2196f3);

  List<String> titulos = [
    "Auxílio Emergencial",
    "Transferir dinheiro",
    "Extrato",
    "Realizar Pagamentos",
    "Receber dinheiro",
    "FGTS",
  ];

  List<String> subTitulos = [
    "Consulte seu benefício",
    "Transferências até 250 reais",
    "Verifique seu extrato",
    "Pagamentos até 250 reais",
    "Seu QRCode",
    "Veja seu saldo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: logoCaixaTem(),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Container(          
              padding: EdgeInsets.all(5.0),
              color: const Color(0xFF2196f3),
              child: customContainer(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titulos.length,                
                itemBuilder: (context, index)=>customCard(
                  titulos[index],
                  subTitulos[index]
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget logoCaixaTem() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset("images/caixa.png")),
        ),
        Text(
          "CAIXA",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(
          "Tem",
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  Widget customContainer(){
    double leftPadding = 18;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(          
        margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
        decoration: BoxDecoration(
          color: c2,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(  
          mainAxisAlignment: MainAxisAlignment.spaceAround,      
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(2, 2, leftPadding, 2),
              color: c3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.white),
                    onPressed: () {},
                  ),
                  Text(
                    "Mostrar Saldo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(2, 2, leftPadding, 2),
              color: c3,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.white),
                    onPressed: () {},
                  ),
                  Text(
                    "Mostrar Saldo",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customCard(String _title, String _subtitle){
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("images/person.png")
                  )
                ),
              ),
              Expanded(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300],
                        width: 1,
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_title ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(_subtitle ?? ''),                    
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "19:35",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Transform.rotate(
                            angle: pi/4,
                            child: Icon(Icons.push_pin, color: Colors.grey,)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

}