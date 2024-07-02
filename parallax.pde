/**
 * Parallax Class: 
 * manages the layers position and initiation
 */
public class Parallax {
  //fields - array of layers, layer speeds (manually set), and layer y-positions (manually set)
  private Layer[] layers = new Layer[7];
  private Monster monster = new Monster();
  private float[] layerSpeeds = {5, 4, 3, 2, 1.5, 1, 0.9};
  private int[] layerYPos = {0, 0, 0, 0, 0, 568, 568};
  private int offSet = 0; //off set for parallax effect (manually set)
  private int offsetStop = 250;
  private boolean forward = false;
  private boolean transitioning = false;
  
  //constructor
  public Parallax() { 
   for (int i=0; i<layers.length; i++){ //go through array to initilise all layers
     if (i != 4){ //layer 4 has an animations, so it need a different layer constructor
       layers[i] = new Layer(loadImage("graphics/Background/layer" + i + ".png"), 250, layerYPos[i], layerSpeeds[i]); //if no animation, use Layer constructor 1
     }
     else { 
       //else, create new image array for all frames of animation
       PImage[] layer4 = new PImage[3];
       PImage spritesheet = loadImage("graphics/Background/layer4.png"); //load sprite sheet
       for (int j =0; j < layer4.length; j++){ //go through and get each frame from sprite sheet and add it to image array
         layer4[j] = spritesheet.get(j * 250, 0, 250, 150);
       }
       layers[i] = new Layer(layer4, 250, layerYPos[i], layerSpeeds[i]); //as there is animation, use Layer constructor 2
     }
   }
  }
  
  /**
   * Update method, updates each layer, resulting in layers being drawn
   */
  public void update(){
    background(85, 98, 107); //background light greyish blue
    //for each layer (minus foreground), update with off set
    for (int i=0; i < layers.length-1; i++){
       if (i == 1) {
         if (!monster.isSearching()){
           monster.update();
         }
       }
       if (i == 3){
         if (monster.isSearching()){
           monster.update();
         }
       }
       layers[i].update(offSet);
    }
    if (transitioning){
      if (forward){
        if (mushroom.getX() > offsetStop) {offsetUpdate(20);}
        else {transitioning = false;}
      }
      else if (!forward){
        if (mushroom.getX() < width - offsetStop) {offsetUpdate(-20);}
        else {transitioning = false;}
      }
    }
  }
  
  public void transitionTrigger(boolean forward){
    if (!transitioning) {
      transitioning = true;
      this.forward = forward;
    }
  }
  
  public boolean isTransitioning() {
    return transitioning;
  }
  
  public int getOffset(){
    return offSet;
  }
  
  /**
   * Foreground Update method, updates foreground, resulting in foreground being drawn
   */
  public void updateForeground() {
    layers[6].update(offSet);
    if (monster.isBlackout()){
      fill(0);
      rect(0, 0, 1000, 700);
    }
  }
  
  /**
   * Offset Update method, increases offset which is used to calculate background and obstacle movement
   */
  public void offsetUpdate(int value){
    offSet += value; //increase offset by set value
    //update the position of every obstacle using set value
    for(Obstacle obstacle : obstacles){
      obstacle.posUpdate(value);
    }
    mushroom.posUpdate(value);
  }
  
  public float getLayerXPos(int index) {
    return layers[index].getXPos();
  }
  
  public boolean gameOver(){
    return monster.isGameOver();
  }
  
  public void triggerAppearStateMonster() {
    monster.triggerAppearState(); 
  }
}
