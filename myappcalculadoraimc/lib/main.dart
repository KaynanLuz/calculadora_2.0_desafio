import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC Calculator',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  List<IMCResult> results = [];

  double calcImc(double weight, double height) {
    var alt = ((height * height) / 10000);
    var res = weight / alt;
    return double.parse(res.toStringAsFixed(2));
  }

  String statusImc(double imc) {
    if (imc < 16) {
      return "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      return "Magreza moderada";
    } else if (imc >= 17 && imc < 18) {
      return "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      return "Saudável";
    } else if (imc >= 25 && imc < 30) {
      return "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      return "Obesidade Grau I";
    } else if (imc >= 35 && imc < 40) {
      return "Obesidade Grau II (Severa)";
    } else {
      return "Obesidade Grau III (Mórbida)";
    }
  }

  void calculateIMC() {
    String name = nameController.text;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;

    if (name.isNotEmpty && weight > 0 && height > 0) {
      double imc = calcImc(weight, height);
      String classification = statusImc(imc);

      setState(() {
        results.add(IMCResult(name, weight, height, imc, classification));
        nameController.clear();
        weightController.clear();
        heightController.clear();
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IMCResultScreen(results)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora IMC'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Peso (kg)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Altura (cm)'),
            ),
          ),
          ElevatedButton(
            onPressed: calculateIMC,
            child: Text('Calcular IMC'),
          ),
        ],
      ),
    );
  }
}

class IMCResultScreen extends StatelessWidget {
  final List<IMCResult> results;

  IMCResultScreen(this.results);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados do IMC'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          double imc = results[index].imc;
          String formattedIMC = imc.toStringAsFixed(2);

          return ListTile(
            title: Text('Nome: ${results[index].name}'),
            subtitle: Text(
                'Peso: ${results[index].weight} kg, Altura: ${results[index].height} cm\nIMC: $formattedIMC\nClassificação: ${results[index].classification}'),
          );
        },
      ),
    );
  }
}

class IMCResult {
  final String name;
  final double weight;
  final double height;
  final double imc;
  final String classification;

  IMCResult(this.name, this.weight, this.height, this.imc, this.classification);
}
