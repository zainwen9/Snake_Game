import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/snakepixel.dart';
import 'blankpixel.dart';
import 'foodpixel.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}
enum snake_Direction{UP,DOWN,LEFT,RIGHT}
class _homeState extends State<home> {
  //grid dimensions
  int rowsize=10;
  int totalnumberofsq=100;
  int currentScore=0;
  bool gameHasStarted=false;
  //snake pos
  List<int>snakepos=[0];

  // food position
  int foodpos=55;
  var currentDirection=snake_Direction.RIGHT;

  void startGame(){
    gameHasStarted=true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        //keep the snake moving
        moveSnake();

        if(gameOver()){
          timer.cancel();

          showDialog(context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  title: Center(child: Text('GAME OVER'),),
                  content: Column(
                    children: [
                      Text('Your Score is: '+currentScore.toString()),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter Name',
                            hintStyle: TextStyle(color: Colors.black)
                        ),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: (){
                        submitScore();
                        Navigator.pop(context);
                        newGame();
                      },
                      child: Text('Enter Name',style: TextStyle(color: Colors.white),),
                      color: Colors.black,
                    )
                  ],
                );
              });
        };
      });
    });
  }
  void newGame(){
    setState(() {
      List<int>snakepos=[0];
    });
    foodpos=55;
    currentScore=0;
    currentDirection=snake_Direction.RIGHT;
    gameHasStarted=false;
  }

  void submitScore(){}
  bool gameOver(){
    List<int> bodySmake=snakepos.sublist(0,snakepos.length-1);
    if(bodySmake.contains(snakepos.last)){
      return true;
    }
    return false;
  }

  void eatfood(){
    currentScore++;
    while(snakepos.contains(foodpos)){
      foodpos=Random().nextInt(totalnumberofsq);
    }
  }

  void moveSnake(){
    switch(currentDirection){
      case snake_Direction.RIGHT:{
        if(snakepos.last % rowsize ==9){
          snakepos.add(snakepos.last+1-rowsize);
        } else{
          snakepos.add(snakepos.last+1);
        }
      }
      break;

      case snake_Direction.LEFT:{

        if(snakepos.last % rowsize ==0){
          snakepos.add(snakepos.last-1+rowsize);
        }
        else{
          snakepos.add(snakepos.last-1);
        }
      }
      break;

      case snake_Direction.UP:{
        if(snakepos.last < rowsize){
          snakepos.add(snakepos.last-rowsize+totalnumberofsq);
        }
        else{
          snakepos.add(snakepos.last-rowsize);
        }
      }
      break;

      case snake_Direction.DOWN:{
        if(snakepos.last+rowsize>totalnumberofsq){
          snakepos.add(snakepos.last+rowsize-totalnumberofsq);
        }
        else{
          snakepos.add(snakepos.last+rowsize);
        }
      }
      break;
      default:
    }
    // eating food
    if(snakepos.last==foodpos){
      eatfood();
    }else{
      snakepos.removeAt(0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Score',style: TextStyle(color: Colors.white),),
                      Text(currentScore.toString(),
                        style: TextStyle(fontSize: 36,color: Colors.white),
                      ),
                    ],
                  ),
                  Text('HighScores',style: TextStyle(color: Colors.white),),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(details.delta.dy>0 && currentDirection!=snake_Direction.UP){
                    currentDirection=snake_Direction.DOWN;
                  }
                  else if(details.delta.dy<0&& currentDirection!=snake_Direction.DOWN){
                    currentDirection=snake_Direction.UP;
                  }
                },

                onHorizontalDragUpdate: (details){
                  if(details.delta.dx>0 && currentDirection!=snake_Direction.LEFT){
                    currentDirection=snake_Direction.RIGHT;
                  }
                  else if(details.delta.dx<0 && currentDirection!=snake_Direction.RIGHT){
                    currentDirection=snake_Direction.LEFT;
                  }
                },

                child: GridView.builder(
                  itemCount: totalnumberofsq,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:rowsize ),
                  itemBuilder: (context,index){
                    if(snakepos.contains(index)){
                      return const snakePixel();
                    }
                    else if(foodpos==index){
                      return foodpixels();
                    }
                    else{
                      return const blankPixel();
                    }
                  },
                ),
              ),),

            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: MaterialButton(
                        child: Text('PLAY'),
                        color: gameHasStarted?Colors.grey:Colors.white,
                        onPressed:gameHasStarted?(){}:startGame,
                      ),
                    ),
                    Column(
                      children: [
                        Text('Developed by:  Zain Mehmood',style: TextStyle(color: Colors.grey),),
                        Text('21-CS-109:  UET Taxila',style: TextStyle(color: Colors.grey),),
                      ],
                    ),

                  ],
                ))
          ],
        ),
      ),
    );
  }
}
