public class Monster {
  //fields 
  private ArrayList<PImage> appear;
  private ArrayList<PImage> disappear;
  private PImage standing;
  private ArrayList<PImage> searching;
  monsState state = monsState.notThere;
  
  private PVector distPos = new PVector(0, 350);
  private PVector searchPos = new PVector(500, height - 367);
  private int time = 0;
  private int thereTime = 50;
  private int blackTime = 10;
  private int searchTime = 200;
  private int holdTime = 40;
  private float xChange = 0;
  private float frameNum = 0;
  private int pad = 0;
  private boolean blackout = false;
  private boolean searched = false;
  private boolean search = false;
  
  //constructor
  public Monster(){
    appear = loadAnimation("appear", "distance", 5);
    disappear = loadAnimation("disappear", "distance", 6);
    standing = loadImage("graphics/Monster/distance/standing.png");
    searching = loadAnimation("frames", "searching", 3);
  }
  
  /**
   * Loads animations given the name of animation and the number of frames 
   */
  public ArrayList<PImage> loadAnimation (String aniName, String distance, int numFrames){
    ArrayList<PImage> animation = new ArrayList(); //create new array
    //add each frame to animation array and return
    for (int i = 0; i < numFrames; i++){ 
      PImage frame = loadImage("graphics/Monster/" + distance + "/"+ aniName + "/frame" + i + ".png");
      animation.add(frame);
    }
    return animation; 
  }
  
  public void update(){
    imageMode(CENTER);
    if (state == monsState.notThere && time == 0){
      if (levelNum == 1){time = (int)random(450, 650);}
      else {time = (int)random(300, 500);}
    }
    if (state == monsState.notThere && time > 1){
      time--;
    }
    else if (state == monsState.notThere && time == 1){
      state = monsState.appear;
      time--;
      xChange = (int)random(650, 830);
    }
    
    PImage frame = null;
    if (state == monsState.appear){
      frame = appear.get(round(frameNum));
      frameNum += 0.13;
      pad = 55;
      if (round(frameNum) >= appear.size()){
        frameNum = 0;
        state = monsState.standing;
        pad = 0;
      }
    }
    if (state == monsState.standing){
      frame = standing;
      if (thereTime == 0){
        state = monsState.disappear;
        thereTime = 50;
      }
      else{
        if (!isTransitioning()){
          thereTime--;
        }
      }
    }
    if (state == monsState.disappear){
      frame = disappear.get(round(frameNum));
      frameNum += 0.13;
      pad = -55;
      if (round(frameNum) >= disappear.size()){
        frameNum = 0;
        state = monsState.blackout;
      }
    }
    if (state == monsState.blackout){
      if (blackTime > 0){
        blackTime--;
        blackout = true;
      }
      else if (searched == false){
        state = monsState.searching;
        search = true;
        blackout = false;
        blackTime = 10;
      }
      else {
        state = monsState.notThere;
        blackout = false;
        searched = false;
        blackTime = 10;
      }
    }
    if (state == monsState.searching){
      if (searchTime == 200){
        if (holdTime > 0){
          frame = searching.get(round(frameNum));
          holdTime--;
        }
        else if (holdTime == 0){
          holdTime = 40;
          frame = searching.get(round(frameNum));
          frameNum = 1;
          searchTime--;
        }
      }
      else if (searchTime > 0){
        frame = searching.get(round(frameNum));
        frameNum += 0.01;
        searchTime--;
        if (round(frameNum) >= searching.size()){
          frameNum = 1;
        }
      }
      else {
        frameNum = 0;
        if (holdTime > 0){
          frame = searching.get(round(frameNum));
          holdTime--;
        }
        else if (holdTime == 0){
          holdTime = 40;
          searched = true;
          search = false;
          searchTime = 200;
          state = monsState.blackout;
        }
      }
    }
    

    distPos.x = parallax.getLayerXPos(1) + xChange - pad;
    if ((distPos.x < 100 || distPos.x > width -100) && state == monsState.appear){
      distPos.x = parallax.getLayerXPos(1) + xChange - pad;
      thereTime = 100;
    }
    if ((distPos.x < - 95|| distPos.x > width + 95) && state == monsState.standing){
      state = monsState.notThere;
      time = 0;
      thereTime = 100;
    }
    
    pushMatrix();
    if (state != monsState.notThere && state != monsState.searching && state != monsState.blackout){
      translate(distPos.x, distPos.y);
      scale(2);
      image(frame, 0, 0);
    }
    if (state == monsState.searching){
      translate(searchPos.x, searchPos.y);
      scale(2);
      image(frame, 0, 0);
    }
    popMatrix();
  }
  
  public boolean isBlackout(){
    return blackout;
  }
  
  public boolean isSearching(){
     return search;
  }
  
  public boolean isGameOver(){
    if (state == monsState.searching){
       if (!mushroom.isHidden()){return true;}
    }
    return false;
  }
  
  public void triggerAppearState() {
    if (state == monsState.notThere || state == monsState.appear || state == monsState.disappear || state == monsState.standing) {
      frameNum = 0;
      state = monsState.blackout;
    }
  }
}
