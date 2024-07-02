/**
 * Layer Class: 
 * contains all layer information and displays layer images
 */
public class Layer {
  //field - array of imgs, index for images, image width, y position and speed
  private PImage[] imgs;
  private float imgIndex = 0;
  private int imgWidth;
  private int yPos;
  private float speed;
  private float xPos;
  
  //constructor 1, for static layer
  public Layer(PImage img, int imgWidth, int yPos, float speed){
    PImage[] imgs = new PImage[1];
    imgs[0] = img;
    this.imgs = imgs;
    this.imgWidth = imgWidth;
    this.yPos = yPos;
    this.speed = speed;
  }
  
  //constructor 2, for animated layer
  public Layer(PImage[] imgs, int imgWidth, int yPos, float speed){
    this.imgs = imgs;
    this.imgWidth = imgWidth;
    this.yPos = yPos;
    this.speed = speed;
  }
  
  /*
   * Update method, displays all layer images and layer image animation
   */
  public void update(int offSet){
    //displays layer image by index, x and y position, and resizes images by a scale of 4
    imageMode(CORNER);
    int multImgWidth = imgWidth * 4; //variable storing scaled up image width
    //x calculation based on offset, speed and layer width
    xPos = -(offSet/speed) % multImgWidth;
    //if movement is positive (to right)
    if (xPos > 0){
      xPos -= multImgWidth; //minus image width from x
    }
    //draw images using calculated x position
    image(imgs[round(imgIndex)], xPos, yPos, imgs[round(imgIndex)].width*4, imgs[round(imgIndex)].height*4);
    image(imgs[round(imgIndex)], xPos + multImgWidth, yPos, imgs[round(imgIndex)].width*4, imgs[round(imgIndex)].height*4);
    //for layers with animation, incriment index and if index reaches the length of the image array, reset index to 0
    imgIndex += 0.1f; 
    if (round(imgIndex) >= imgs.length) { imgIndex = 0; }
  }
  
  /*
   * GetWid method, returns width of layer
   */
  public int getWid(){
    return this.imgWidth;
  }
  
  /*
   * GetSpeed method, returns speed of layer shift 
   */
  public float getSpeed(){
    return this.speed;
  }
  
  public float getXPos() {
    return xPos;
  }
}
