boolean config_drawborders = true;
// Draw borders on canvas

// Color palette
color crouge = color(213,2,8);
color cnoir = color(17,21,20);
color cbeige = color(208,196,170);

// Font
PFont constfont;

void setup() {
  size(800,800);
  ellipseMode(CENTER);
  constfont = createFont("font.otf", 500); // Initialise font 
  textAlign(CENTER);
  textFont(constfont);
  objects = new ArrayList<PerspObj>(); // Create arraylist for char objects
}

void draw() {
  background(cbeige);
  drawperspective(mouseX,mouseY,20);
  
  // Draw chars on the perspective
  for (int i = 0; i <= objects.size()-1; i++) {
    PerspObj curobj = objects.get(i); // Get the object on the list
    curobj.posz -= 0.005; // Decrement the z position of the object
    if (curobj.posz < 0) {
      objects.remove(i); // Delete from list if < 0
    } else {
      curobj.update(mouseX,mouseY); // Draws the object
    }
  }
  
  rectMode(CORNER);
  drawborders(40,10);
}

void drawborders(int bs, int bo) { // @bs = Border size ; @bo = Border Offset
  if (config_drawborders) {
    
    // Creates an overlay of rectangles to ensure we don't see other elements past borders.
    fill(cbeige);
    noStroke();
    rect(0,0,width,bs);
    rect(0,0,bs,height);
    rect(width-bs,0,bs,height);
    rect(0,height-bs,width,bs);
    
    // Dessine les bordures noir
    noFill();
    stroke(cnoir);
    strokeWeight(2);
    rect(bs,bs,width-bs*2,height-bs*2);
    rect(bs-bo,bs-bo,width-bs*2+bo*2,height-bs*2+bo*2);
  }
}

// Vars used on the class below
float dp_mx, dp_my;
float dp_sx, dp_sy;

// This class is used to create the char objects
class PerspObj {
  float posx, posy, posz, fontsize;
  char objchar;
  
  // Define all object proprieties
  PerspObj (char obchr, float px, float py, float pz, float fs) {
    posx = px;
    posy = py;
    posz = pz;
    fontsize = fs;
    objchar = obchr;
  }
  
  // Draws the object
  void update(float x, float y) {
    dp_mx = map(posz,0,1,x,posx); // Define the X position of the char (map between its initial position and mouseX) related to Z position
    dp_my = map(posz,0,1,y,posy); // Same but for Y
    float fs;
    fs = map(posz,0,1,0,fontsize); // Define the char size related to the Z pos
    fill(crouge);
    noStroke();
    textSize(fs);
    text(objchar,dp_mx,dp_my);
    fill(17,21,20,(1-posz)*255); // The more the char is far (posz), the more its color will be opaque
    text(objchar,dp_mx,dp_my); // Draws a second char at the same position but with the new color
  }
}

ArrayList<PerspObj> objects; // Creates the list of char objects

void keyPressed() {
  if (Character.isLetter(key) || Character.isDigit(key)) { // Checks if the key pressed is a digit or a letter
      objects.add(new PerspObj(key, random(0,width), random(0,height),1,300)); // Adds it to the list
  }
}


// Function that creates the perspective
void drawperspective(float x,float y,float nlayers) {
  fill(0,0,0,50);
  stroke(cnoir);
  strokeWeight(2);
  rectMode(CENTER);
  drawlines(x,y);
  for (float i=0.5; i<=nlayers ; i++) {
    
    dp_sx = map(i,0,nlayers,0,1);
    dp_sx = dp_sx * dp_sx * dp_sx * dp_sx; // easeInQuint
  
    dp_mx = map(dp_sx,1,0,width/2,x); // maps dp_sx between the horizontal center of the canvas (width/2) and mouseX.
    dp_my = map(dp_sx,1,0,height/2,y); // Same for Y
    
    rect(dp_mx,dp_my,dp_sx*width,dp_sx*height);

  }
}

// Draws the background perspective lines
void drawlines(float x,float y) {
  line(0,0,x,y);
  line(width,0,x,y);
  line(0,height,x,y);
  line(width,height,x,y); 
}
