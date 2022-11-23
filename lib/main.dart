import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() { runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp( debugShowCheckedModeBanner: false, title: 'Flutter Demo',theme: ThemeData(primarySwatch: Colors.blue,),home: const MyHomePage(title: 'Flutter Demo Home Page'),);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
static List<int> snakePosition = [45,65,85,105,45];
int numberOfSquares = 460;

static var randomNumber = Random();
int food = randomNumber.nextInt(400);
void generateNewFood(){
  food = randomNumber.nextInt(400);
}

void startGame(){
  snakePosition = [45,65,85,105,125];
  const duration = const Duration(milliseconds: 300);
  Timer.periodic(duration, (timer) {
   updateSnake();
   if(gameOver()){
    timer.cancel();
    _showGameOverScreen();
   } 
   });
}

var direction = 'down';
void updateSnake(){
  setState(() {
    switch (direction){
      case 'down':
        if (snakePosition.last>440){
          snakePosition.add(snakePosition.last + 20 - 460);
        }else {
          snakePosition.add(snakePosition.last + 20);
        }

        break;

      case 'up':
        if(snakePosition.last <20){
          snakePosition.add(snakePosition.last - 20 + 760);
        } else{
         snakePosition.add(snakePosition.last - 20); 
        }
        break;

      case 'left':
        if ((snakePosition.last + 1) % 20==0){
          snakePosition.add(snakePosition.last - 1 + 20);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }

        break;

      case 'right':
        if ((snakePosition.last + 1) % 20 ==0){
          snakePosition.add(snakePosition.last + 1 - 20);
        } else{
          snakePosition.add(snakePosition.last +1);
        }
        break;
    
        default:
    }

    if (snakePosition.last == food){
      generateNewFood();
    }else{
      snakePosition.removeAt(0);
    }
  });
}

bool gameOver(){
  for (int i=0; i < snakePosition.length; i++){
    int count = 0;
    for(int j=0; j<snakePosition.length; j++){
      if(snakePosition[i] == snakePosition[j]){
        count += 1;
      }
      if (count == 2){
        return true;
      }
    }
  }
  return false;
}

void _showGameOverScreen(){
  showDialog(context: context, 
  builder: (BuildContext context){
    return AlertDialog(
      title: Text('Gamer Over'),
      content: Text('Sua Pontuação é: '+snakePosition.length.toString()),
      actions: [
        TextButton(
          child: Text('Jogar Novamente'),
          onPressed: (){
            startGame();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
  );
}



@override 
Widget build(BuildContext context){
  return Scaffold(

    backgroundColor: Colors.black,
    body: Column(
      children: [
        Expanded(
          child: GestureDetector(

            onVerticalDragUpdate: (details){
              if (direction != 'up' && details.delta.dy > 0 ){
                direction ='down';
              }else if(direction != 'down' && details.delta.dy < 0 ){
                direction ='up';
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direction != 'left' && details.delta.dx > 0){
                direction = 'right';
              }else if(direction != 'right' && details.delta.dx < 0){
                direction = 'left';
              }
            },

            child: Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 20), 
                itemBuilder: (BuildContext context, int index){
                  if (snakePosition.contains(index)){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if(index == food){
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(color: Colors.green,)),
                    );
                  }else{
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                       // child: Container(color: Colors.grey[900],)),
                        child: Container(color: Colors.black,)),

                    );
                  }
                }),
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0), 
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: startGame,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Iniciar',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                const Text(
                  "@Angraz Tecnologia",
                  style: TextStyle(color: Colors.white, fontSize:14),
                ),
              ],
          ),
        )
      ],
    )
  );
}



}
