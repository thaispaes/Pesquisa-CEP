import 'package:flutter/material.dart';
import 'package:pesquisa_cep/models/result_cep.dart';
import 'package:pesquisa_cep/services/via_cep_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_rich_text/easy_rich_text.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();
  late ResultCep _response = ResultCep();
  bool _loading = false;
  bool _enableField = true;
  String? _result;
  bool _setVisible = false;


  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        title: const Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultCep()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Insira o CEP desejado",
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FloatingActionButton(
        onPressed: _searchCep,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: _loading ? _circularLoading() : Text('Consultar'),

      ),
    );
  }

  Widget _buildResultCep() {
    return Visibility(
      visible: _setVisible == true,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              EasyRichText(
                  _response.cep != null ? "CEP: ${_response.cep}" : 'CEP: Null'
              ),
              EasyRichText(
                  _response.logradouro != null ? "Logradouro: ${_response.logradouro}" : 'Logradouro: Null'
              ),
              EasyRichText(
                  _response.localidade != null ? "Localidade: ${_response.localidade}" : 'Localidade: Null'
              ),
              EasyRichText(
                  _response.complemento != null ? "Complemento: ${_response.complemento}" : 'Complemento: Null'
              ),
              EasyRichText(
                  _response.bairro != null ? "Bairro: ${_response.bairro}" : 'Bairro: Null'
              ),
              EasyRichText(
                  _response.uf != null ? "UF: ${_response.uf}" : 'UF: Null'
              ),
              EasyRichText(
                  _response.unidade != null ? "Unidade: ${_response.uf}" : 'Unidade: Null'
              ),
              EasyRichText(
                  _response.ibge != null ? "IBGE: ${_response.ibge}" : 'IBGE: Null'
              ),
              EasyRichText(
                  _response.gia != null ? "GIA: ${_response.gia}" : 'GIA: Null'
              ),
            ],
          ),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    try {
      final resultCep = await ViaCepService.fetchCep(cep: cep);
      print(resultCep.localidade); // Exibindo somente a localidade no terminal

      setState(() {
          _response = resultCep;
          _setVisible = true;
      });

      _searching(false);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Ocorreu um erro: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
