/**
 * Obstacle Class:
 * describes obstacles that the fighter can collide with.
 */
public class Obstacle {
  //fields, name, vectors of position and size, sprite image
  private ArrayList<PImage> animation = new ArrayList();
  private String name;
  private PVector pos;
  private PVector size;
  private PImage sprite;
  private boolean animate = false;
  private boolean broken = false;
  private float frameNum;
  
  //constructor 1 - for obstacles without image
  public Obstacle(String name, float x, float y, float w, float h){
    this.name = name;
    this.pos = new PVector(x, y);
    this.size = new PVector(w, h);
  }
  
  //constructor 1 - for obstacles with image
  public Obstacle(String name, float x, float y, float w, float h, PImage img){
    this.name = name;
    this.pos = new PVector(x, y);
    this.size = new PVector(w, h);
    this.sprite = img;
  }
  
  //constructor 2 - for obstacles with image animation
  public Obstacle(String name, float x, float y, float w, float h, ArrayList<PImage> imgs){
    this.name = name;
    this.pos = new PVector(x, y);
    this.size = new PVector(w, h);
    this.animation = imgs;
  }
  
  /**
   * Update method, draws obstacles when called
   */
  public void update(){
    if (!animation.isEmpty()){
      if (!animate){
        sprite = animation.get(round(frameNum));
      }
      else {
        sprite = animation.get(round(frameNum));
        frameNum += 0.1;
        if (round(frameNum) >= animation.size()){
          if (name.equals("puddle")){
            frameNum = 0;
            animate = false;
          }
          else if (name.equals("stick")){
            frameNum = 1;
            broken = true;
            animate = false;
          }
        }
      }
    }
    
    if (sprite != null){ //if there is a sprite, then draw it
      imageMode(CENTER); //draw from center
      pushMatrix();
      translate(pos.x, pos.y);
      if (name.equals("puddle")){scale(6);}
      else if (name.equals("stick")){scale(5);}
      else {scale(4);}
      image(sprite, 0, 0);
      popMatrix();
    }
  }
  
  /**
   * Get Position Method, returns position vector
   */
  public PVector getPos(){
    return pos;
  }
  
  /**
   * Get Name Method, returns obstacle name
   */
  public String nameGet(){
    return name;
  }
  
  /**
   * Get Size Method, returns size vector
   */
  public PVector getSize(){
    return size;
  }
  
  public void animate(){
    animate = true;
  }
  
  public boolean isBroken(){
    return broken;
  }
  
  /**
   * Position Update Method, adds set value onto x position of obstacle
   */
  public void posUpdate (int value){
    if (!name.equals("ground"))
      pos.x -= value;
  }
}
