final static int MIN_ALPHA = 0;
final static int MAX_ALPHA = 360;

int alpha;

HScrollbar hs1;
boolean startDrawing;


void setup() {
  size(640, 360);
  noStroke();
    
  hs1 = new HScrollbar(0, 8, width, 16, 1);
  startDrawing = false;
}

void draw() {
  background(255);
  
  hs1.update();
  hs1.display();
  
  hs1.getAlpha();
    
  if (startDrawing) {
    System.out.println("we would begin printing here");
  } else {
    //System.out.println("slider position has not been selected");
  }
}

void mouseReleased() {
  // the mouse has to be bellow the slider clusters
  if (mouseY > 20) {
    alpha = hs1.getAlpha();
    startDrawing = true;
    System.out.println("I AM GOING TO DRAW NOW!!!!!");
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy, 1 : follows mouse exactly, higher means it is slower
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    
    //System.out.println("I AM IN UPDATE");
    
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      //System.out.println("mousePressed && over");
      locked = true;
    }
    if (!mousePressed) {
      //System.out.println("!mousePressed");
      locked = false;
    }
    if (locked) {
      System.out.println("locked");
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  int getAlpha() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    
    System.out.println("Pos: " + spos * ratio);
    
    int value = (int) (spos * ratio);
    
    return (int) map(value, 0, width, MIN_ALPHA, MAX_ALPHA);
  }
}
