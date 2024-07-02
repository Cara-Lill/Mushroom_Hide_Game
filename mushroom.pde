/**
 * Mushroom class: loads and stores animations for mushroom character, switches mushroom states dependingg on user input and colitions,
 * and draws mushroom based on current animation frame and position
 */
public class Mushroom {
  //fields
  //arrays of mushroom animations:
  private ArrayList<PImage> getUp;
  private ArrayList<PImage> dazed;
  private ArrayList<PImage> idle;
  private ArrayList<PImage> hide;
  private ArrayList<PImage> lightJump;
  private ArrayList<PImage> lightJumpL;
  private ArrayList<PImage> regJump;
  private ArrayList<PImage> regJumpL;
  
  //starting state, height, width, position and velocity
  mushState state = mushState.start;
  private int hei = 75;
  private int wid = 75/2;
  private PVector pos = new PVector(250 - 75/2, height-15 - 50/2);
  private PVector vel = new PVector(0, 0);
  private float groundHei = 0;
  
  //movement constants
  private float gravity = 0.9f; //gravity affecting jumps
  //regular jump initial velocities (x and y)
  private float regYVelo = -17;
  private float regXVeloR = 6;
  private float regXVeloL = -6;
  //light jump initial velocities (x and y)
  private float ligYVelo = -15;
  private float ligXVeloR = 4;
  private float ligXVeloL = -4;
  
  private float frameNum = 0; //current animation frame
  
  //booleans affecting movement
  private boolean keyDown = false; //if key is held down
  private int keyTime = 0; //how long key has been held down for
  private boolean goingLeft = false; 
  //light or regular jump
  private boolean lightJ = false;
  private boolean regJ = false;
  private boolean stopHiding = false; //stopping hiding
  private boolean hidden = false;
  private boolean getDazed = false;
  
  private boolean gameOver = false;
  
  //constructor - loads all animations
  public Mushroom(){
    getUp = loadAnimation("getUp", 8);
    dazed = loadAnimation("dazed", 10);
    idle = loadAnimation("idle", 4);
    hide = loadAnimation("hide", 4);
    lightJump = loadAnimation("lightJump", 8);
    lightJumpL = loadAnimation("lightJumpL", 8);
    regJump = loadAnimation("regJump", 10);
    regJumpL = loadAnimation("regJumpL", 10);
  }
  
  /**
   * Loads animations given the name of animation and the number of frames
   */
  public ArrayList<PImage> loadAnimation (String aniName, int numFrames){
    ArrayList<PImage> animation = new ArrayList(); //create new array
    //add each frame to animation array and return
    for (int i = 0; i < numFrames; i++){ 
      PImage frame = loadImage("graphics/Shroom/" + aniName + "/frame" + i + ".png");
      animation.add(frame);
    }
    return animation; 
  }
  
  /**
   * Update Method, draws mushroom character based on position, state, and current frame 
   **/
  public void update(){
    imageMode(CORNERS); //draws from top left and bottom right corner
    ArrayList<Obstacle> colliding = getCollisions(pos); //array of obstacles that mushroom is colliding with
    
    //check if key is being held down or tapped
    if (keyDown){keyTime++;}
    //if held down, then do a regular jump
    if (keyDown && keyTime > 10 && keyTime != 0){ 
      if (state != mushState.jumping && state != mushState.falling && state != mushState.landing && state != mushState.hiding
          && state != mushState.start && state != mushState.dazed && !parallax.isTransitioning()){
        regJ = true;
        lightJ = false;
        //add left or right velocity
        if (goingLeft){vel.x = regXVeloL;} 
        else {vel.x = regXVeloR;}
        jump(); //call jump
      }
      keyTime = 0;
    }
    //if tapped, then do a light jump 
    else if (!keyDown && keyTime <= 10 && keyTime != 0){
      if (state != mushState.jumping && state != mushState.falling && state != mushState.landing && state != mushState.hiding
          && state != mushState.start && state != mushState.dazed && !parallax.isTransitioning()){
        regJ = false;
        lightJ = true;
        //add left or right velocity
        if (goingLeft){vel.x = ligXVeloL;}
        else {vel.x = ligXVeloR;}
        jump(); //call jump
      }
      keyTime = 0;
    }
    
    //check for collitions
    if (colliding.isEmpty()){ //if not colliding with anything then falling or jumping
      if (vel.y >= 0){ //falling when y is increasing
        if (state != mushState.falling){ //if not already falling then start falling
          //start frames for light and regular falling
          if (lightJ){frameNum = 3.5f;}
          else {frameNum = 4.9f;}
          state = mushState.falling;
          //match height to animation spritesheet
          hei = 80;
          wid = 80/2;
        }
      }
      vel.y += gravity; //add gravity to velocity
    }
    else { //if colliding with anything
      for (Obstacle obstacle : colliding){
        if (obstacle.nameGet().equals("ground")){ //check if collition is with ground
          if (state == mushState.falling && !getDazed){ //if state is falling then switch to landing
            if (lightJ) {frameNum = 7;}
            else {frameNum = 8;}
            state = mushState.landing;
            hei = 75;
            groundHei = obstacle.getPos().y - (obstacle.getSize().y/2); //set height above ground
            pos.y = groundHei;
            //set velocities to 0
            vel.y = 0;
            vel.x = 0;
          }
          else if (state == mushState.falling && getDazed){
            frameNum = 0;
            state = mushState.dazed;
            getDazed = false;
            hei = 100;
            wid = 100/2;
            pos.y = obstacle.getPos().y - (obstacle.getSize().y/2); //set height above ground
            vel.x = 0;
            vel.y = 0;
          }
        }
        if (obstacle.nameGet().equals("stump")){
          if (state == mushState.falling ){
            if (lightJ) {frameNum = 7;}
            else {frameNum = 8;}
            state = mushState.landing;
            pos.y = obstacle.getPos().y - (obstacle.getSize().y/2 - 10); //set height above ground
            //set velocities to 0
            vel.y = 0;
            vel.x = 0;
          }
          if (state == mushState.jumping ){
            vel.y += gravity; //add gravity to velocity
          }
        }
        if (obstacle.nameGet().equals("puddle")){
          PVector obPos = obstacle.getPos();
          PVector obSize = obstacle.getSize();
          if (levelNum == 1){
            if (state == mushState.falling && (pos.x - (wid/4)) > (obPos.x - (obSize.x/2)) && (pos.x + (wid/4)) < (obPos.x + (obSize.x/2)) && (pos.y + hei/2) > obSize.y){
              obstacle.animate();
              if (lightJ) {frameNum = 7;}
              else {frameNum = 8;}
              state = mushState.landing;
              pos.y = groundHei; //set height above ground
              //set velocities to 0
              vel.y = 0;
              vel.x = 0;
            }
            if (state == mushState.jumping) {
              if ((pos.x - (wid/4)) > (obPos.x - (obSize.x/2)) && (pos.x + (wid/4)) < (obPos.x + (obSize.x/2)) && (pos.y + hei/2) > obSize.y){
                obstacle.animate();
              }
              vel.y += gravity; //add gravity to velocity
            }
          } else { parallax.triggerAppearStateMonster(); }
        }
        if (obstacle.nameGet().equals("stick")){
          if (levelNum == 1){
            if (state == mushState.falling){
              if (!obstacle.isBroken()){
                getDazed = true;
              }
              obstacle.animate();
            }
            if (state == mushState.jumping) {
              vel.y += gravity; //add gravity to velocity
            }
          } else { parallax.triggerAppearStateMonster(); }
        } 
      }
    }
    
    if ((pos.x - wid/2) + parallax.getOffset()  <= worldStart){
      vel.x *= -1;
      getDazed = true;
    }
    if (pos.x > (width - 200) && (state == mushState.idle || state == mushState.dazed)){parallax.transitionTrigger(true);}
    else if (pos.x < 200 && (state == mushState.idle || state == mushState.dazed) && parallax.getOffset() > 0){parallax.transitionTrigger(false);}
    
    if (parallax.isTransitioning()){
      if (state != mushState.dazed){
        state = mushState.idle;
      }
    }
    
    PImage frame = null; //initiate frame
    if (state == mushState.start){frame = animate(getUp, 0.07, getUp.size());} //wake up animation
    if (state == mushState.dazed){frame = animate(dazed, 0.05, dazed.size());} //dazed animation
    //animation if falling natually (default to regular falling and landing)
    if (state == mushState.idle){frame = animate(idle, 0.02f, idle.size());}
    if (state == mushState.falling && !regJ && !lightJ && !goingLeft){frame = animate(regJump, 0.05f, 8);}
    if (state == mushState.landing && !regJ && !lightJ && !goingLeft){frame = animate(regJump, 0.05f, regJump.size());}
    if (state == mushState.falling && !regJ && !lightJ && goingLeft){frame = animate(regJumpL, 0.05f, 8);}
    if (state == mushState.landing && !regJ && !lightJ && goingLeft){frame = animate(regJumpL, 0.05f, regJumpL.size());}
    //regular right jump animation
    if (state == mushState.jumping && regJ && !goingLeft){frame = animate(regJump, 0.17f, 5);}
    if (state == mushState.falling && regJ && !goingLeft){frame = animate(regJump, 0.1f, 8);}
    if (state == mushState.landing && regJ && !goingLeft){frame = animate(regJump, 0.1f, regJump.size());}
    //regular left jump animation
    if (state == mushState.jumping && regJ && goingLeft){frame = animate(regJumpL, 0.17f, 5);}
    if (state == mushState.falling && regJ && goingLeft){frame = animate(regJumpL, 0.1f, 8);}
    if (state == mushState.landing && regJ && goingLeft){frame = animate(regJumpL, 0.1f, regJumpL.size());}
    //light right jump animation
    if (state == mushState.jumping && lightJ && !goingLeft){frame = animate(lightJump, 0.17f, 4);}
    if (state == mushState.falling && lightJ && !goingLeft){frame = animate(lightJump, 0.17f, 7);}
    if (state == mushState.landing && lightJ && !goingLeft){frame = animate(lightJump, 0.05f, lightJump.size());}
    //light left jump animation
    if (state == mushState.jumping && lightJ && goingLeft){frame = animate(lightJumpL, 0.17f, 4);}
    if (state == mushState.falling && lightJ && goingLeft){frame = animate(lightJumpL, 0.17f, 7);}
    if (state == mushState.landing && lightJ && goingLeft){frame = animate(lightJumpL, 0.05f, lightJumpL.size());}
    //hiding and stop hiding animations
    if (state == mushState.hiding && !stopHiding){frame = animate(hide, 0.1f, hide.size()-1); }
    if (state == mushState.hiding && stopHiding){frame = animate(hide, -0.1f, 0);}
    
    pushMatrix();
    if (state == mushState.landing){
      image(frame, pos.x - (wid), pos.y - hei + 5, pos.x + (wid), pos.y); //draws image using frame and position
    }
    else {image(frame, pos.x - (wid), pos.y - hei, pos.x + (wid), pos.y);} //draws image using frame and position
    popMatrix();
    
    //add velocities to position
    if (canMove(vel.x)) {
      pos.x += vel.x;
    }
    pos.y += vel.y;
  }
  
  /**
   * Returns current animation frame 
   */
  public PImage animate(ArrayList<PImage> ani, float increase, int end){
    PImage frame = ani.get(round(frameNum)); //get frame of animation at current frame
    frameNum += increase; //increase current frame index
    //if current frame is outside of specified range change it based on current state
    if (round(frameNum) >= end && !stopHiding){
      //if falling or hiding, hold last frame
      if (state == mushState.falling || state == mushState.hiding){
        frameNum = end;
        if (state == mushState.hiding){hidden = true;}
      }
      else if (state == mushState.landing || state == mushState.start || state == mushState.dazed){ //if landing or start, switch to idle state when finished
        state = mushState.idle;
        frameNum = 0;
        hei = 75; wid = 75/2;
      }
      else {frameNum = 0;} //else, reset current frame of animation
    }
    //getting out of hiding works backwards to normal method
    else if (round(frameNum) <= end && stopHiding){
      frameNum = 0;
      state = mushState.idle; //change to idle state when finished
      stopHiding = false;
      hidden = false;
    }
    if (state == mushState.hiding && round(frameNum) != end){hidden = false;}
    return frame; //return frame
  }
  
  /**
   * If key is being pressed or not, set boolean
   */
  public void isKeyDown(boolean value){
    keyDown = value;
  }
  
  /**
   * Going left, set boolean
   */
  public void leftKey(boolean value){
    if (state != mushState.jumping && state != mushState.falling){
      goingLeft = value;
    }
  }
  
  /**
   * Initial jump animation
   */
  public void jump(){
    frameNum = 0;
    hei = 80;
    wid = 80/2;
    //different initial velocity based on if light or regular jump
    if (state != mushState.jumping){
      state = mushState.jumping;
      if (lightJ){vel.y = ligYVelo;}
      else {vel.y = regYVelo;}
    }
  }
  
  /**
   * Initiate hide animation when called
   */
  public void hide(){
    if (state != mushState.jumping && state != mushState.falling && state != mushState.landing && state != mushState.hiding
        && state != mushState.start && state != mushState.dazed && !parallax.isTransitioning()){
      frameNum = 0;
      state = mushState.hiding;
    }
  }
  
  /**
   * If stopping hiding, then set boolean 
   */
  public void stopHiding(){
    if (state == mushState.hiding){
      stopHiding = true;
    }
  }
  
  public void posUpdate(int value){
    pos.x -= value;
  }
  
  public float getX(){
    return pos.x;
  }
  
  public boolean isHidden(){
    return hidden;
  }
  
  public boolean gameOver(){
    return gameOver;
  }
  
  public boolean canMove(float velo){
    pos.x += velo;
    for (Obstacle obs : getCollisions(pos)){
      if (!obs.nameGet().equals("ground")) {
        PVector obsPos = obs.getPos();
        PVector obsSize = obs.getSize();
        if (pos.y > obsPos.y - obsSize.y/2 + 11){
          pos.x -= velo;
          return false;
        }
      }
    }
    pos.x -= velo;
    return true;
  }
  
  /**
   * Get Collisions Method, returns list of all obstacles that the fighter is colliding with
   */
  public ArrayList<Obstacle> getCollisions(PVector pos) { 
    float topY = pos.y - hei;
    float botY = pos.y;
    float lefX = pos.x - wid/2;
    float rigX = pos.x + wid/2;
    ArrayList<Obstacle> collisions = new ArrayList<Obstacle>(); //initiate collisions list
    for (Obstacle obstacle : obstacles) { //for each obstacle
      PVector obsPos = obstacle.getPos();
      PVector obsSize = obstacle.getSize();
      float obstopY = obsPos.y - obsSize.y/2;
      float obsBot = obsPos.y + obsSize.y/2;
      float obslefX = obsPos.x - obsSize.x/2;
      float obsRig = obsPos.x + obsSize.x/2;
      //rectMode(CORNERS);
      //fill(255, 255, 255, 75);
      //rect(obslefX, obstopY, obsRig, obsBot);
      //rectMode(CORNER);
      if(lefX > obslefX && rigX < obsRig) { // If vertically aligned with obstacle.
        if(botY >= obstopY && botY < obsBot) { // If collide with topY of obstacle.
          // topY collision with obstacle.
          collisions.add(obstacle);
        }
        else if(topY <= obsBot && topY > obstopY) { // If collide with botY of obstacle.
          // botY collision with obstacle.
          collisions.add(obstacle);
        }
      }
      else if(topY > obstopY - hei/2 && botY < obsBot + hei/2) { // If horizontally aligned with obstacle.
        if(rigX >= obslefX && rigX < obsRig) { // If collide with left of obstacle.
          // left collision with obstacle.
          collisions.add(obstacle);
        }
        else if(lefX <= obsRig && lefX > obslefX) { // If collide with right of obstacle.
          // right collision with obstacle.
          collisions.add(obstacle);
        }
      }
      else if(botY >= obstopY && botY < obsBot) { // If colliding with top of obstacle.
        if(rigX >= obslefX && rigX < obsRig) { // If colliding with left of obstacle.
          // top left collision with obstacle.
          collisions.add(obstacle);
        }
        else if(lefX <= obsRig && lefX > obslefX) { // If colliding with right obstacle.
          // top right collision with obstacle.
          collisions.add(obstacle);
        }
      }
      else if(topY <= obsBot && topY > obstopY) { // If colliding with bottom of obstacle.
        if(rigX >= obslefX && rigX < obsRig) { // If colliding with left of obstacle.
          // bottom left collision with obstacle.
          collisions.add(obstacle);
        }
        else if(lefX <= obsRig && lefX > obslefX) { // If colliding with right of obstacle.
          collisions.add(obstacle);
        }
      }
    }
    //rectMode(CORNERS);
    //fill(255, 255, 255, 75);
    //println(lefX + " " + topY + " " + rigX + " " + botY);
    //rect(lefX, topY, rigX, botY);
    //rectMode(CORNER);
    return collisions;
  }
  
}
