import 'package:flutter/material.dart';
import 'package:tic_tac/Logic/game_logic.dart';
import 'package:tic_tac/Logic/player_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  bool isSwitch = false;
  int turn = 0;
  String result = '';
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ...firstBlock(),
                    SizedBox(
                      height: 20,
                    ),
                    _expanded(context),
                    SizedBox(
                      height: 20,
                    ),
                    ...lastBlock(),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...firstBlock(),
                          const SizedBox(height: 20),
                          ...lastBlock(),
                        ],
                      ),
                    ),
                    _expanded(context),
                  ],
                ),
              ),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SwitchListTile.adaptive(
          title: Text(
            '2 Players',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              fontFamily: 'PFA',
            ),
          ),
          value: isSwitch,
          onChanged: (value) {
            setState(() {
              isSwitch = value;
            });
          },
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: TextStyle(
          fontFamily: 'PFA',
          fontSize: 54,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        "$result".toUpperCase(),
        style: TextStyle(
          fontFamily: 'PFA',
          fontSize: 40,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25, bottom: 20),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              Player.playerX = [];
              Player.playerO = [];
              gameOver = false;
              activePlayer = 'X';
              turn = 0;
              result = '';
            });
          },
          icon: Icon(
            Icons.replay_circle_filled_outlined,
            size: 35,
          ),
          label: Text(
            'Repeat Game',
            style: TextStyle(
              fontFamily: 'PFA',
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              fixedSize: MaterialStateProperty.all<Size>(Size(225, 55)),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).splashColor)),
        ),
      )
    ];
  }

  Widget _expanded(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
          children: List.generate(
            9,
            (index) => InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: gameOver ? null : () => _onTap(index),
              child: Container(
                child: Center(
                  child: Text(
                    Player.playerX.contains(index)
                        ? 'X'
                        : Player.playerO.contains(index)
                            ? 'O'
                            : '',
                    style: TextStyle(
                      fontFamily: 'PFA',
                      color: Player.playerX.contains(index)
                          ? Colors.blueAccent
                          : Colors.redAccent,
                      fontSize: 72,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((!Player.playerX.contains(index) || Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) || Player.playerO.isEmpty)) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitch && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();

      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the Winner'.toUpperCase();
      } else if (!gameOver && turn == 9) {
        result = 'It\'s Draw'.toUpperCase();
      }
    });
  }
}
