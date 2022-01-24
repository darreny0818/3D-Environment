//Darren Yang
//Jan 14th, 2022
//1-4, Programming 12

import java.awt.Robot;

//Color Pallette
color black = #000000; //bookshelves
color white = #FFFFFF; //empty space
color blue = #7092BE;  //bricks

//Textures
PImage bricks, mossystone, glass, bookshelf, oakplanks;

//Map variables
int gridSize;
PImage map;

//Robot for mouse control
Robot rbt;

boolean wkey, akey, skey, dkey;
boolean skipFrame;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 7*height/10;
  eyeZ = 0;
  focusX = width/2;
  focusY = height/2;
  focusZ = 10;
  tiltX = 0;
  tiltY = 1;
  tiltZ = 0;
  leftRightHeadAngle = radians(270);
  noCursor();
  skipFrame = false;

  //Initialize map
  map = loadImage("map.png");
  gridSize = 100;

  //Textures
  bricks = loadImage("bricks.png");
  bookshelf = loadImage("bookshelf.png");
  glass = loadImage("glass.png");
  oakplanks = loadImage("oakplanks.png");
  mossystone = loadImage("mossystone.png");

  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);
  drawFloor(-2050, 1950, height, gridSize);              //Floor
  drawFloor(-2050, 1950, height-gridSize*11, gridSize);  //Ceiling
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawFocalPoint() { //focus dot
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, glass, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }

  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  } else if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  } else {
    skipFrame = false;
  }
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == black) {
        int i = 1;
        while (i < 11) {
          texturedCube(x*gridSize-2050, height-gridSize*i, y*gridSize-2050, bricks, gridSize);
          i++;
        }
      }
      if (c == blue) {
        int n = 1;
        while (n < 11) {
          texturedCube(x*gridSize-2050, height-gridSize*n, y*gridSize-2050, bookshelf, gridSize);
          n++;
        }
      }
    }
  }
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
