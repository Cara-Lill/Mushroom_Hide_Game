Parallax parallax;
Mushroom mushroom;
//Initial world variables
int worldStart = 0;
int worldEnd;
int levelNum;
boolean gameStarted = false;
boolean midGame = false;
boolean gameWon = false;
boolean gameLost = false;
float frameNum = 0;
int aniNum = 0;
boolean animFinished = false;
boolean hasImageLoaded = false;
boolean imageFinished = false;
//States
enum mushState {start, idle, jumping, falling, landing, hiding, dazed}
enum monsState {notThere, appear, disappear, standing, blackout, searching}
//Mushroom Animations
ArrayList<PImage> celebrate = new ArrayList<PImage>();
ArrayList<PImage> idle = new ArrayList<PImage>();
boolean getDazed = false;
boolean dazing = false;
ArrayList<PImage> dazed = new ArrayList<PImage>();
//Obstacles
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<PImage> puddleAni = new ArrayList<PImage>();
ArrayList<PImage> stickAni = new ArrayList<PImage>();
PImage stumpImg;
PImage boulderImg;
//GUI
PImage lvlOne;
PImage lvlTwo;
PImage exit;
PImage restart;
PImage scoreButton;
boolean scoreboardOn = false;
PImage scoreboard;
PImage pauseOff;
PImage pauseOn;
PImage fail;
PImage gameOver;
//Times
ArrayList<PImage> digits = new ArrayList<PImage>();
PImage decimal;
int startTime;

int[] highscore = {0, 0};
boolean scoreChecked = false;

public void setup() {
  size(1000,700);
  frameRate(60);
  noSmooth();
  
  String[] lines = loadStrings("highscores.txt");
  highscore[0] = Integer.valueOf(lines[0]);
  highscore[1] = Integer.valueOf(lines[1]);
  
  for (int i = 0; i < 8; i++){
    PImage celeImg = loadImage("graphics/Shroom/celebrate/frame" + i + ".png");
    celebrate.add(celeImg);
  }
  for (int i = 0; i < 4; i++){
    PImage idleImg = loadImage("graphics/Shroom/idle/frame" + i + ".png");
    idle.add(idleImg);
  }
  for (int i = 0; i < 10; i++){
    PImage dazedImg = loadImage("graphics/Shroom/dazed/frame" + i + ".png");
    dazed.add(dazedImg);
  }
  
  boulderImg = loadImage("graphics/Obstacles/boulder.png");
  stumpImg = loadImage("graphics/Obstacles/stump.png");
  for (int i = 0; i < 3; i++){
    PImage puddleImg = loadImage("graphics/Obstacles/puddle"+i+".png");
    puddleAni.add(puddleImg);
  }
  for (int i = 0; i < 2; i++){
    PImage stickImg = loadImage("graphics/Obstacles/stick"+i+".png");
    stickAni.add(stickImg);
  }
  
  for (int i = 0; i < 10; i++){
    PImage digit = loadImage("graphics/GUI/digit"+i+".png");
    digits.add(digit);
  }
  decimal = loadImage("graphics/GUI/decimal.png");
  lvlOne = loadImage("graphics/GUI/level1.png");
  lvlTwo = loadImage("graphics/GUI/level2.png");
  exit = loadImage("graphics/GUI/exit.png");
  restart = loadImage("graphics/GUI/restart.png");
  scoreButton = loadImage("graphics/GUI/scoreButton.png");
  scoreboard = loadImage("graphics/GUI/scoreboard.png");
  pauseOff = loadImage("graphics/GUI/pauseOff.png");
  pauseOn = loadImage("graphics/GUI/pauseOn.png");
  fail = loadImage("graphics/Monster/fail.png");
  gameOver = loadImage("graphics/GUI/gameOver.png");
}

public void gameStart(){
  obstacles.clear();
  scoreChecked = false;
  gameStarted = true;
  startTime = millis();
  midGame = true;
  gameWon = false;
  gameLost = false;
  hasImageLoaded = false;
  //initiate parallax and all layers, fighter, and create the ground that fighter collides with
  parallax = new Parallax(); 
  mushroom = new Mushroom();
  worldEnd = 7000;
  
  Obstacle ground = new Obstacle("ground", width/2, height-15, 1500, 50);
  obstacles.add(ground); //add the ground to obstacles
  Obstacle boulder = new Obstacle("boulder", 0 - boulderImg.width, height - (boulderImg.height *2.25), boulderImg.width, boulderImg.height, boulderImg);
  obstacles.add(boulder);

  int currentX = 1300;
  int currentObject = 0;
  int duplicationCount = 0;
  while (currentX < worldEnd - 500){
    int type = (int)random(1,4);
    if (type == currentObject) { duplicationCount++; }
    else { duplicationCount = 0; }
    if (duplicationCount > 1) {
      while (type == currentObject) {
        type = (int)random(1,4);
      }
    }
    switch(type) {
      case 1:
        Obstacle stump = new Obstacle("stump", currentX - parallax.getOffset(), height-80, 70, 124, stumpImg);
        obstacles.add(stump);
        currentObject = 1;
        break;
      case 2:
        Obstacle puddle = new Obstacle("puddle", currentX - parallax.getOffset(), height-45, 124, 36, puddleAni);
        obstacles.add(puddle);
        currentObject = 2;
        break;
      case 3:
        Obstacle stick = new Obstacle("stick", currentX - parallax.getOffset(), height-55, 60, 44, stickAni);
        obstacles.add(stick);
        currentObject = 3;
        break;
      default:
        break;
    }
    int nextX = (int)random(200, 600);
    currentX += nextX;
  }
}

public void draw() {
  imageMode(CENTER);
  
  if (!gameStarted){
    fill(0);
    rect(0,0,width,height);
    if (!getDazed && !dazing) {
      PImage frame = idle.get(round(frameNum));
      frameNum += 0.01;
      if (round(frameNum) >= idle.size()){
        frameNum = 0;
      }
      image(frame, width/2,  height/2- 125, frame.width * 15, frame.height * 15);
    }
    else if (getDazed){
      frameNum = 0;
      dazing = true;
      getDazed = false;
    }
    else {
      PImage frame = dazed.get(round(frameNum));
      frameNum += 0.1;
      if (round(frameNum) >= dazed.size()){
        frameNum = 0;
        dazing = false;
      }
      image(frame, width/2 - 8, height/2-163, frame.width * 15, frame.height * 15);
    }
    stroke(255);
    strokeWeight(2);
    line(width/2 -275, height/2 - 12, width/2 +275,  height/2 -12);
    image(lvlOne,  width/2 -115,  height/2 + 70, lvlOne.width * 5, lvlOne.height * 5);
    image(lvlTwo,  width/2 +115,  height/2 + 70, lvlOne.width * 5, lvlOne.height * 5);
    image(exit,  width/2 - 160,  height - 150, exit.width * 5, exit.height * 5);
    image(scoreButton,  width/2 + 115,  height - 150, scoreButton.width * 5, scoreButton.height * 5);
    if (scoreboardOn){
      drawScoreBoard();
    }
  }
  else {
    if (!parallax.gameOver() && !gameWon && !gameLost) {
      parallax.update(); //update parallax
      //update all obstacles
      for (Obstacle obstacle : obstacles) {
        obstacle.update();
      }
      mushroom.update(); //update mushroom
      parallax.updateForeground(); //update forground
      if ((mushroom.getX() > worldEnd - parallax.getOffset() && mushroom.getX() > width - 200)){
        gameWon = true;
        midGame = false;
        //animFinished = false;
      }
      if (parallax.gameOver()){
        gameLost = true;
        midGame = false;
      }
      
      String[] digitsStringsArray = String.valueOf(nf((millis()-startTime)/10)).split("");
      ArrayList<String> digitsStrings = new ArrayList<String>();
      for (int i = 0; i < digitsStringsArray.length; i++) {
        if (i == 0 && digitsStringsArray.length < 3){digitsStrings.add("0");}
        if (i == digitsStringsArray.length - 2) {digitsStrings.add(".");}
        digitsStrings.add(digitsStringsArray[i]);
      }
      
      imageMode(CORNER);
      int xPadding = 20;
      int i = 0;
      while (i < digitsStrings.size()) {
        if (!digitsStrings.get(i).equals(".")) {
          image(digits.get(Integer.valueOf(digitsStrings.get(i))), 5 + 35*i + xPadding, 10, digits.get(0).width*4, digits.get(0).height*4);
        } else {
          image(decimal, 5 + 35*i + xPadding, 17, decimal.width*3, decimal.height*3); 
          xPadding -= 10;
        }
        i++;
      }
      imageMode(CENTER);
    }
    else if (gameWon){
      if (!scoreChecked) {
         if (highscore[levelNum-1] > millis()-startTime || highscore[levelNum-1] == 0) {
           highscore[levelNum-1] = millis()-startTime;
           String[] lines = {String.valueOf(highscore[0]), String.valueOf(highscore[1])};
           saveStrings("highscores.txt", lines);
         }
         scoreChecked = true;
      }
      fill(0);
      rect(0,0,width,height);
      PImage frame = celebrate.get(round(frameNum));
      frameNum += 0.1;
      if (round(frameNum) >= celebrate.size()){
       frameNum = 0;
      }
      image(frame, width/2, height/2 - 169, frame.width * 15, frame.height * 15);
      stroke(255);
      strokeWeight(2);
      line(width/2 -275, height/2 - 12, width/2 +275,  height/2 -12);
      image(restart, width/2, height/2 +70, restart.width*5, restart.height*5);
      image(exit,  width/2 - 160,  height - 150, exit.width * 5, exit.height * 5);
      image(scoreButton,  width/2 + 115,  height - 150, scoreButton.width * 5, scoreButton.height * 5);
       if (scoreboardOn){
        drawScoreBoard();
      }
    }
    else {
      if (!hasImageLoaded){
        fill(0);
        rect(0,0,width,height);
        image(fail, width/2, height/2, fail.width * 10, fail.height * 10);
        hasImageLoaded = true;
        imageFinished = true;
      }
      else {
        if (imageFinished){
          delay(500);
          imageFinished = false;
        }
        fill(0);
        rect(0,0,width,height);
        image(gameOver, width/2, height/2 - 70, gameOver.width * 10, gameOver.height * 10);
        image(restart, width/2, height/2 +70, restart.width*5, restart.height*5);
        image(exit,  width/2 - 160,  height - 150, exit.width * 5, exit.height * 5);
        image(scoreButton,  width/2 + 115,  height - 150, scoreButton.width * 5, scoreButton.height * 5);
        if (scoreboardOn){
          drawScoreBoard();
        }
      }
    }
  }
}

public void drawScoreBoard() {
  image(scoreboard, width/2, height/2, scoreboard.width*5, scoreboard.height*5);
  String[] digitsStringsArray1 = String.valueOf(nf((highscore[0])/10)).split("");
  String[] digitsStringsArray2 = String.valueOf(nf((highscore[1])/10)).split("");
  ArrayList<String> digitsStrings1 = new ArrayList<String>();
  ArrayList<String> digitsStrings2 = new ArrayList<String>();
  for (int i = 0; i < digitsStringsArray1.length; i++) {
    if (i == 0 && digitsStringsArray1.length < 3){digitsStrings1.add("0");}
    if (i == digitsStringsArray1.length - 2) {digitsStrings1.add(".");}
    digitsStrings1.add(digitsStringsArray1[i]);
  }
  for (int i = 0; i < digitsStringsArray2.length; i++) {
    if (i == 0 && digitsStringsArray2.length < 3){digitsStrings2.add("0");}
    if (i == digitsStringsArray2.length - 2) {digitsStrings2.add(".");}
    digitsStrings2.add(digitsStringsArray2[i]);
  }
  
  imageMode(CORNER);
  int xPadding = 20;
  int i = 0;
  while (i < digitsStrings1.size()) {
    if (!digitsStrings1.get(i).equals(".")) {
      image(digits.get(Integer.valueOf(digitsStrings1.get(i))), 450 + 45*i + xPadding, 300, digits.get(0).width*5, digits.get(0).height*5);
    } else {
      image(decimal, 450 + 45*i + xPadding - 10, 300, decimal.width*5, decimal.height*5); 
      xPadding -= 20;
    }
    i++;
  }
  xPadding = 20;
  i = 0;
  while (i < digitsStrings2.size()) {
    if (!digitsStrings2.get(i).equals(".")) {
      image(digits.get(Integer.valueOf(digitsStrings2.get(i))), 450 + 45*i + xPadding, 420+8, digits.get(0).width*5, digits.get(0).height*5);
    } else {
      image(decimal, 450 + 45*i + xPadding - 10, 420+8, decimal.width*5, decimal.height*5); 
      xPadding -= 20;
    }
    i++;
  }
  imageMode(CENTER); 
}

public void mousePressed(){
  if (!midGame && !gameWon && !gameLost && mouseX > (width/2 -115 -((lvlOne.width*5)/2)) && mouseX < (width/2 -115 +((lvlOne.width*5)/2)) &&
      mouseY > (height/2 +70 -((lvlOne.height*5)/2)) && mouseY < (height/2 +70 +((lvlOne.height*5)/2))){
    levelNum = 1;
    gameStart();
  }
  if (!midGame && !gameWon && !gameLost && mouseX > (width/2 +115 -((lvlTwo.width*5)/2)) && mouseX < (width/2 +115 +((lvlTwo.width*5)/2)) &&
      mouseY > (height/2 +70 -((lvlTwo.height*5)/2)) && mouseY < (height/2 +70 +((lvlTwo.height*5)/2))){
    levelNum = 2;
    gameStart();
  }
  if (!midGame && !scoreboardOn && mouseX > (width/2 -160 -(exit.width*5)/2) && mouseX < (width/2 -160 +(exit.width*5)/2) &&
      mouseY > (height-150 -(exit.height*5)/2) && mouseY < (height-150 +(exit.height*5)/2)){
    if (gameWon || gameLost){
      frameNum = 0;
      gameStarted = false;
      if (gameWon){gameWon = false;}
      if(gameLost){
        gameLost = false;
        hasImageLoaded = false;
      }
    }
    else {exit();}
  }
  if (!midGame && mouseX > (width/2 +115 -(scoreButton.width*5)/2) && mouseX < (width/2 +115 +(scoreButton.width*5)/2) &&
      mouseY > (height-150 -(scoreButton.height*5)/2) && mouseY < (height-150 +(scoreButton.height*5)/2)){
    scoreboardOn = true;
  }
  if (!midGame && scoreboardOn && mouseX > (width/2 -65 +(scoreboard.width*5)/2) && mouseX < (width/2 -30 +(scoreboard.width*5)/2) &&
      mouseY > (height/2 +30 -(scoreboard.height*5)/2) && mouseY < (height/2 +65 -(scoreboard.height*5)/2)){
    scoreboardOn = false;
  }
  if (!scoreboardOn && mouseX > (width/2 -(idle.get(0).width*15)/2) && mouseX < (width/2 +(idle.get(0).width*15)/2) &&
      mouseY > (height/2 -125 -(idle.get(0).height*15)/2) && mouseY < (height/2 -125 +(idle.get(0).height*15)/2)){
    getDazed = true;
  }
  if (!midGame && (gameWon || gameLost) && mouseX > (width/2 -(restart.width*5)/2) && mouseX < (width/2 +(restart.width*5)/2) &&
      mouseY > (height/2 +70 -(restart.height*5)/2) && mouseY < (height/2 +70 +(restart.height*5)/2)){
    gameStart(); 
  }
}

public void keyPressed(){ 
  if (keyCode == 68 || keyCode == 39){
    mushroom.isKeyDown(true);
    mushroom.leftKey(false);
  }
  if (keyCode == 65 || keyCode == 37){
    mushroom.isKeyDown(true);
    mushroom.leftKey(true);
  }
  if (keyCode == 83 || keyCode == 40){
    mushroom.hide();
  }
}

public void keyReleased(){
  if (keyCode == 68 || keyCode == 39){
    mushroom.isKeyDown(false);
  }
  if (keyCode == 65 || keyCode == 37){
    mushroom.isKeyDown(false);
  }
  if (keyCode == 83 || keyCode == 40){
    mushroom.stopHiding();
  }
}

public boolean isTransitioning(){
  return parallax.isTransitioning();
}
