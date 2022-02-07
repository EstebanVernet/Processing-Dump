boolean config_drawborders = true;
// Dessine les bordures autour du canvas

// Color palette
color crouge = color(213,2,8);
color cnoir = color(17,21,20);
color cbeige = color(208,196,170);

// Font
PFont constfont;

void setup() {
  size(800,800);
  ellipseMode(CENTER);
  constfont = createFont("font.otf", 500); // Initialise la font 
  textAlign(CENTER);
  textFont(constfont);
  objects = new ArrayList<PerspObj>(); // Crée la arraylist pour les chars
}

void draw() {
  background(cbeige);
  drawperspective(mouseX,mouseY,20);
  
  // Dessine les chars dans la perspective
  for (int i = 0; i <= objects.size()-1; i++) {
    PerspObj curobj = objects.get(i); // Récupère l'objet de la liste
    curobj.posz -= 0.005; // Décrémente de 0.005 la position z de l'objet
    if (curobj.posz < 0) {
      objects.remove(i); // Supprime de la liste si z < 0
    } else {
      curobj.update(mouseX,mouseY); // Dessine l'objet
    }
  }
  
  rectMode(CORNER);
  drawborders(40,10); // à mettre en fin de programme
}

void drawborders(int bs, int bo) { // BS = Border size ; BO = Border Offset
  if (config_drawborders) {
    
    // Crée un "overlay" de rectangles beige pour ne pas voir les autres formes hors de ces bordures
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

// Variables utilisés dans la class
float dp_mx, dp_my;
float dp_sx, dp_sy;

// Cette classe crée un objet qui sera utilisé pour dessiner les charactères
class PerspObj {
  float posx, posy, posz, fontsize;
  char objchar;
  
  // Fonction pour créer l'objet et définir ses variables
  PerspObj (char obchr, float px, float py, float pz, float fs) {
    posx = px;
    posy = py;
    posz = pz;
    fontsize = fs;
    objchar = obchr;
  }
  
  // Fonction pour dessiner l'objet
  void update(float x, float y) {
    dp_mx = map(posz,0,1,x,posx); // définit la position X du charactère (map entre sa position initiale et le point de fuite qui est mouseX) par rapport à posz
    dp_my = map(posz,0,1,y,posy); // Même chose pour Y
    float fs;
    fs = map(posz,0,1,0,fontsize); // Définit la taille de la lettre par rapport à sa position z (profondeur)
    fill(crouge);
    noStroke();
    textSize(fs);
    text(objchar,dp_mx,dp_my);
    fill(17,21,20,(1-posz)*255); // Plus le charactère est loin (posz), plus cette couleur sera opaque
    text(objchar,dp_mx,dp_my); // Dessine un second caractère à la même position mais avec la couleur d'au dessus
  }
}

ArrayList<PerspObj> objects; // Déclare l'arraylist (liste d'objets)

void keyPressed() {
  if (Character.isLetter(key) || Character.isDigit(key)) { // Vérifie si le char est une lettre ou un nombre
      objects.add(new PerspObj(key, random(0,width), random(0,height),1,300)); // Ajoute l'objet à la liste
  }
}


// Fonction pour créer l'effet de perspective
void drawperspective(float x,float y,float nlayers) {
  fill(0,0,0,50);
  stroke(cnoir);
  strokeWeight(2);
  rectMode(CENTER);
  drawlines(x,y);
  for (float i=0.5; i<=nlayers ; i++) { // Boucle qui s'arrête quand i est plus petit que nlayers
    
    dp_sx = map(i,0,nlayers,0,1);
    dp_sx = dp_sx * dp_sx * dp_sx * dp_sx; // fonction easeInQuint
  
    dp_mx = map(dp_sx,1,0,width/2,x); // map la valeur dp_sx entre le centre horizontal (width/2) du canvas et la variable x (qui est égal à mouseX)
    dp_my = map(dp_sx,1,0,height/2,y); // Même chose, mais pour l'axe Y
    
    rect(dp_mx,dp_my,dp_sx*width,dp_sx*height); // dessine le rectangle

  }
}

// Dessine les lignes diagonales de la perspective
void drawlines(float x,float y) {
  line(0,0,x,y);
  line(width,0,x,y);
  line(0,height,x,y);
  line(width,height,x,y); 
}
