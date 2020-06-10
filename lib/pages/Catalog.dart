import 'package:Artesanias/db/dbmanager.dart';
import 'package:Artesanias/pages/Detail.dart';
import 'package:Artesanias/pages/add_producto.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

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

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: dbmanager.getStudentList(),
                    builder: (context,snapshot){
                      if(snapshot.hasData) {
                        studlist = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: studlist == null ?0 : studlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            Student st = studlist[index];
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(color: Colors.red),
                              onDismissed: (diretion) {
                                dbmanager.deleteStudent(st.id);
                              },
                              child: Card(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => DetailScreen()));
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: width*0.6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Nombre: ${st.name}',style: TextStyle(fontSize: 15),),
                                            Text('Decripcion: ${st.course}', style: TextStyle(fontSize: 15, color: Colors.black54),),
                                            Text('Costo: ${st.costo}',style: TextStyle(fontSize: 15),),
                                            Text('Largo: ${st.largo}',style: TextStyle(fontSize: 15),),
                                            Text('Ancho: ${st.ancho}',style: TextStyle(fontSize: 15),),
                                          ],
                                        ),
                                      ),

                                      IconButton(onPressed: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                              true,
                                              student: st,
                                            )
                                        ));
                                        },icon: Icon(Icons.edit, color: Colors.blueAccent,),),
                                      IconButton(onPressed: (){
                                        dbmanager.deleteStudent(st.id);
                                        setState(() {
                                          studlist.removeAt(index);
                                        });
                                      },
                                        icon: Icon(Icons.delete, color: Colors.red,),)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },

                        );
                      }
                      return new CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen(false)));
        },
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
