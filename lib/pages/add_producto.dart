import 'package:Artesanias/db/dbmanager.dart';
import 'package:Artesanias/pages/Catalog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool edit;
  final Student student;

  HomeScreen(this.edit, {this.student})
      : assert(edit == true || student ==null);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DbStudentManager dbmanager = new DbStudentManager();

  final _nameController = TextEditingController();
  final _desController = TextEditingController();
  final _costoController = TextEditingController();
  final _largoController = TextEditingController();
  final _anchoController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  Student student;
  List<Student> studlist;
  int updateIndex;

  void initState() {
    super.initState();
    //if you press the button to edit it must pass to true,
    //instantiate the name and phone in its respective controller, (link them to each controller)
    if(widget.edit == true){
      _nameController.text = widget.student.name;
      _desController.text = widget.student.course;
      _costoController.text = widget.student.costo;
      _largoController.text = widget.student.largo;
      _anchoController.text = widget.student.ancho;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite Demo'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                      labelText: 'Nombre',
                    ),
                    controller: _nameController,
                    validator: (val) =>
                    val.isNotEmpty ? null : 'Ingresa un nombre',
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                      labelText: 'Descripción',
                    ),
                    controller: _desController,
                    validator: (val) =>
                    val.isNotEmpty ? null : 'Ingresa una descripción',
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(
                        Icons.attach_money,
                      ),
                      labelText: 'Costo',
                    ),
                    keyboardType: TextInputType.number,
                    controller: _costoController,
                    validator: (val) =>
                    val.isNotEmpty ? null : 'Ingresa un costo',
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(
                        Icons.transform,
                      ),
                      labelText: 'Largo',
                    ),
                    keyboardType: TextInputType.number,
                    controller: _largoController,
                    validator: (val) =>
                    val.isNotEmpty ? null : 'Ingresa una medida',
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      prefixIcon: Icon(
                        Icons.transform,
                      ),
                      labelText: 'Ancho',
                    ),
                    keyboardType: TextInputType.number,
                    controller: _anchoController,
                    validator: (val) =>
                    val.isNotEmpty ? null : 'Ingresa una medida',
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      _submitStudent(context);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => IntroScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitStudent(BuildContext context) {
    if(_formKey.currentState.validate()){
      if(student==null) {
        Student st = new Student(
          name: _nameController.text,
          course: _desController.text,
          costo: _costoController.text,
          largo: _largoController.text,
          ancho: _anchoController.text,
        );
        dbmanager.insertStudent(st).then((id)=>{
          _nameController.clear(),
          _desController.clear(),
          _costoController.clear(),
          _largoController.clear(),
          _anchoController.clear(),
          print('Student Added to Db ${id}')
        });
      } else {
        student.name = _nameController.text;
        student.course = _desController.text;
        student.costo = _costoController.text;
        student.largo = _largoController.text;
        student.ancho = _anchoController.text;

        dbmanager.updateStudent(student).then((id) =>{
          setState((){
            studlist[updateIndex].name = _nameController.text;
            studlist[updateIndex].course= _desController.text;
            studlist[updateIndex].costo = _costoController.text;
            studlist[updateIndex].largo = _largoController.text;
            studlist[updateIndex].ancho = _anchoController.text;
          }),
          _nameController.clear(),
          _desController.clear(),
          _costoController.clear(),
          _largoController.clear(),
          _anchoController.clear(),
          student=null
        });
      }
    }
  }
}
