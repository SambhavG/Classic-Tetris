
//Empty space is 0
//occupied space by static piece is 1
//occupied space by moving piece is 2



float[][] grid = new float[23][10];

int[][] ipiece = //index 0
{{0,0,0,0},
 {2,2,2,2}};
 
int[][] opiece = //index 1
{{0,2,2,0},
 {0,2,2,0}}; 
 
int[][] tpiece = //index 2
{{0,2,0,0},
 {2,2,2,0}}; 
 
int[][] spiece = //index 3
{{0,2,2,0},
 {2,2,0,0}};
 
int[][] zpiece = //index 4
{{2,2,0,0},
 {0,2,2,0}}; 
 
int[][] jpiece = //index 5
{{2,0,0,0},
 {2,2,2,0}}; 
 
int[][] lpiece = //index 6
{{0,0,2,0},
 {2,2,2,0}}; 
 
int[][][] pieces = {ipiece, opiece, tpiece, spiece, zpiece, jpiece, lpiece}; 
 
void drawTetris(int xcoord, int ycoord, int boxSize) {
  //i is row, j is column
  for (int i = 3; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      if (floor(grid[i][j]) == 1) {
        
        int resultIndex = 3; //init
        if (grid[i][j] == 1.0) {
          resultIndex = 0;
        } else if (grid[i][j] == 1.1) {
          resultIndex = 1;
        } else if (grid[i][j] == 1.2) {
          resultIndex = 2;
        } else if (grid[i][j] == 1.3) {
          resultIndex = 3;
        } else if (grid[i][j] == 1.4) {
          resultIndex = 4;
        } else if (grid[i][j] == 1.5) {
          resultIndex = 5;
        } else if (grid[i][j] == 1.6) {
          resultIndex = 6;
        }
        
        drawBox(boxSize*j + xcoord, boxSize*(i-3) + ycoord, boxSize, resultIndex);
        //rect(boxSize*j + xcoord, boxSize*(i-3) + ycoord, boxSize, boxSize);
      }
      if (grid[i][j] == 2) {
        drawBox(boxSize*j + xcoord, boxSize*(i-3) + ycoord, boxSize, pieceIndex);
        //rect(boxSize*j + xcoord, boxSize*(i-3) + ycoord, boxSize, boxSize);
      }
    }
  }

}

void drawNextPiece() {
  
  //look at pieces[index]
  //loop through rows, then columns
  //drawBox if it equals 2
  for (int i = 0; i < pieces[nextPiece].length; i++) {
    for (int j = 0; j < pieces[nextPiece][i].length; j++) {
      if (pieces[nextPiece][i][j] == 2) {
        int boxwidth = 20;
        if (nextPiece == 0 || nextPiece == 1) {
          drawBox(610 + boxwidth*j,350 + boxwidth*i,boxwidth,nextPiece);
        } else {
          drawBox(608 + floor(boxwidth/2) + boxwidth*j,350 + boxwidth*i,boxwidth,nextPiece);
        }
      }
    }
  }
}

void spawnPiece() {
  pieceIndex = nextPiece;

  for (int i = 1; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
      grid[i][j+3] = pieces[pieceIndex][i-1][j];
      centerOfRotation[0] = 2;
      centerOfRotation[1] = 4;
    }
  }
  statistics[pieceIndex]++;
  nextPiece = floor(random(0, pieces.length));
  
}


int[][] findLocationsOfDrop() { //returns every point with value 2
  int[][] locations = new int[4][2];
  int numFound = 0;
  
  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[i].length; j++) {
      if (grid[22-i][j] == 2) {
        locations[numFound][0] = 22-i;
        locations[numFound][1] = j;
        numFound++;
      }
    }
  }
  
  return locations;
}

boolean canDropPiece() { //returns if piece can be moved 1 space down
  int[][] locations = findLocationsOfDrop();
  
  boolean canDrop = true;
  for (int[] loc : locations) {
    if (loc[0] == 22) {
      canDrop = false;
    } else if (floor(grid[loc[0]+1][loc[1]]) == 1) {
      canDrop = false;
    }
  }
  return canDrop;
}

void dropPiece() { //drops piece 1 space down
  int[][] locations = findLocationsOfDrop();
  
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]] = 0;
  }
  for (int[] loc : locations) {
    grid[loc[0]+1][loc[1]]=2;
  }
  centerOfRotation[0]++;
}

void freezePiece() { //solidifies piece
  int[][] locations = findLocationsOfDrop();
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]] = 1.0 + ((float)pieceIndex/10);
  }
}

void movePiece(int direction) {
  //direction is -1 for left, 1 for right
  int[][] locations = findLocationsOfDrop();
  
  //Exits this code block if the piece can not be moved in the given direction
  if (direction == 1) {
    for (int[] loc : locations) {
      if (loc[1] == 9) {
        return;
      }
      if (floor(grid[loc[0]][loc[1]+1]) == 1) {
        return;
      }
    }
  }
  if (direction == -1) {
    for (int[] loc : locations) {
      if (loc[1] == 0) {
        return;
      }
      if (floor(grid[loc[0]][loc[1]-1]) == 1) {
        return;
      }
    }
  }
  
  
  //Moves piece if the exit code did not run
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]] = 0;
  }
  
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]+direction] = 2;
  }
  centerOfRotation[1]+=direction;
}



void rotatePieceCW() {
  int[][] locations = findLocationsOfDrop();
  
  int c1 = centerOfRotation[0];
  int c2 = centerOfRotation[1];
  
  if (pieceIndex == 1) { //exit for O piece
    return;
  }
  
  boolean CanRotateAboutCenter = true;
  
  for (int[] loc : locations) {
    if (c2+(c1-loc[0]) == -1 || c2+(c1-loc[0]) == -2 || c2+(c1-loc[0]) == 10 || c2+(c1-loc[0]) == 11 || c1 + (loc[1]-c2) == 23 || c1 + (loc[1]-c2) == 24) {
      CanRotateAboutCenter = false;
    }
    if (CanRotateAboutCenter == true) {
      if (floor(grid[ c1 + (loc[1]-c2) ][c2+(c1-loc[0]) ]) == 1) {
        CanRotateAboutCenter = false;
      }
    }
  }
  if (CanRotateAboutCenter == true) {
    for (int[] loc : locations) {
      grid[loc[0]][loc[1]] = 0;
    }
    for (int[] loc : locations) {
      grid[c1+(loc[1]-c2)][c2+(c1-loc[0])] = 2;
    }
    return;
  }
  /*
  boolean someTestSucceded = false;
  int newc1 = 0;
  int newc2 = 0;
  
  for (int[] loc : locations) {
    c1 = loc[0];
    c2 = loc[1];
    
    CanRotateAboutCenter = true;
    
    for (int[] loci : locations) {
      if (c2+(c1-loci[0]) == -1 || c2+(c1-loci[0]) == -2 || c2+(c1-loci[0]) == 10 || c2+(c1-loci[0]) == 11 || c1 + (loci[1]-c2) == 23 || c1 + (loci[1]-c2) == 24) {
        CanRotateAboutCenter = false;
      }
      if (CanRotateAboutCenter == true) {
        if (floor(grid[ c1 + (loci[1]-c2) ][c2+(c1-loci[0]) ]) == 1) {
          CanRotateAboutCenter = false;
        }
      }  
    }
    
    if (CanRotateAboutCenter == true) {
        someTestSucceded = true;
        newc1 = c1;
        newc2 = c2;
        break;
    }
  }
  
  if (someTestSucceded == false) {return;}
  
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]] = 0;
  }
  for (int[] loc : locations) {
    grid[newc1+(loc[1]-newc2)][newc2+(newc1-loc[0])] = 2; 
  }
  int placeholder = centerOfRotation[0];
  centerOfRotation[0] = newc1 + centerOfRotation[1] - newc2;
  centerOfRotation[1] = newc2 + newc1 - placeholder;
  */
}

void rotatePieceCCW() {
  int[][] locations = findLocationsOfDrop();
  
  int c1 = centerOfRotation[0];
  int c2 = centerOfRotation[1];
  
  if (pieceIndex == 1) { //exit for O piece
    return;
  }
  
  boolean CanRotateAboutCenter = true;
  
  for (int[] loc : locations) {
    if (c2-c1+loc[0] == -1 || c2-c1+loc[0] == -2 || c2-c1+loc[0] == 10 || c2-c1+loc[0] == 11 || c1-loc[1]+c2 == 23 || c1-loc[1]+c2 == 24) {
      CanRotateAboutCenter = false;
    }
    if (CanRotateAboutCenter == true) {
      if (floor(grid[c1-loc[1]+c2][c2-c1+loc[0]]) == 1) {
        CanRotateAboutCenter = false;
      }
    }
  }
  if (CanRotateAboutCenter == true) {
    for (int[] loc : locations) {
      grid[loc[0]][loc[1]] = 0;
    }
    for (int[] loc : locations) {
      grid[c1-loc[1]+c2][c2-c1+loc[0]] = 2;
    }
    return;
  }
  /*
  boolean someTestSucceded = false;
  int newc1 = 0;
  int newc2 = 0;
  
  for (int[] loc : locations) {
    c1 = loc[0];
    c2 = loc[1];
    
    CanRotateAboutCenter = true;
    
    for (int[] loci : locations) {
      if (c2-c1+loci[0] == -1 || c2-c1+loci[0] == -2 || c2-c1+loci[0] == 10 || c2-c1+loci[0] == 11 || c1-loci[1]+c2 == 23 || c1-loci[1]+c2 == 24) {
        CanRotateAboutCenter = false;
      }
      if (CanRotateAboutCenter == true) {
        if (floor(grid[c1-loc[1]+c2][c2-c1+loc[0]]) == 1) {
          CanRotateAboutCenter = false;
        }
      }  
    }
    
    if (CanRotateAboutCenter == true) {
        someTestSucceded = true;
        newc1 = c1;
        newc2 = c2;
        break;
    }
  }
  
  if (someTestSucceded == false) {return;}
  
  for (int[] loc : locations) {
    grid[loc[0]][loc[1]] = 0;
  }
  for (int[] loc : locations) {
    grid[newc1-loc[1]+newc2][newc2-newc1+loc[0]] = 2; 
  }
  int placeholder = centerOfRotation[0];
    centerOfRotation[0] = newc1 - centerOfRotation[1] + newc2;
    centerOfRotation[1] = newc2 - newc1 + placeholder;
  */
}

void dropPieceCompletely() {
  while (canDropPiece()) {
    dropPiece();
  }
}

void fastDrop() {
  if (canDropPiece()) {
    dropPiece();
  }
  if (canDropPiece()) {
    dropPiece();
  }
  
}

void removeLine(int line) {
  for (int i = 0; i < grid[line].length; i++) {
    grid[line][i] = 0;
  }
  for (int i = line; i > 3; i--) {
    for (int j = 0; j < grid[i].length; j++) {
      grid[i][j] = grid[i-1][j];
    }
  }
}

boolean isLineFull(int line) {
  boolean fullLine = true;
  for (float num : grid[line]) {
    if (floor(num) != 1) {
      fullLine = false;
    }
  }
  return fullLine;
}

void checkAndClearLines() {
  
  for (int i = 3; i < grid.length-3; i++) {
    if (isLineFull(i) && isLineFull(i+1) && isLineFull(i+2) && isLineFull(i+3)) {
      removeLine(i);
      removeLine(i+1);
      removeLine(i+2);
      removeLine(i+3);
      score+=1200*(level+1);
      linesCleared+=4;
    }
  }
  
  for (int i = 3; i < grid.length-2; i++) {
    if (isLineFull(i) && isLineFull(i+1) && isLineFull(i+2)) {
      removeLine(i);
      removeLine(i+1);
      removeLine(i+2);
      score+=300*(level+1);
      linesCleared+=3;
    }
  }
  
  for (int i = 3; i < grid.length-1; i++) {
    if (isLineFull(i) && isLineFull(i+1)) {
      removeLine(i);
      removeLine(i+1);
      score+=100*(level+1);
      linesCleared+=2;
    }
  }
  
  for (int i = 3; i < grid.length; i++) {
    if (isLineFull(i)) {
      removeLine(i);
      score+=40*(level+1);
      linesCleared+=1;
    }
  }
  
}


boolean isGameLost() {
  for (int i = 0; i < grid[2].length; i++) {
    if (floor(grid[3][i]) == 1) {
      return true;
    }
  }
  return false;
}

void checkLevel() {
  if (level < floor(linesCleared/10)) {
    level = floor(linesCleared/10);
  }
}

void playAgainText() {
  int n = -100;
  fill(255,255,255);
  rect(180,250+n,460,400);
  fill(0,0,0);
  rect(190,260+n,440,380);
  fill(255,255,255);
  text("Score: " + score, 200, 280+n);
  text("Press enter\nto play again", 200,350+n);
  text("Press number \nkey for lvl\n0-9 or shift\nfor lvl 10-19", 200, 530+n);
}

void setSpeed() {
  boolean done = false;
  switch(level) {
    case 0:
      speed = 48;
      done = true;
    break;
    case 1:
      speed = 43;
      done = true;
    break;
    case 2:
      speed = 38;
      done = true;
    break;
    case 3:
      speed = 33;
      done = true;
    break;
    case 4:
      speed = 28;
      done = true;
    break;
    case 5:
      speed = 23;
      done = true;
    break;
    case 6:
      speed = 18;
      done = true;
    break;
    case 7:
      speed = 13;
      done = true;
    break;
    case 8:
      speed = 8;
      done = true;
    break;
    case 9:
      speed = 6;
      done = true;
    break;
    default:
      speed = 0;
    break;
  }
  
  if (done == false) {
    if (level >= 10 && level <= 12) {
      speed = 5;
    }
    if (level >= 13 && level <= 15) {
      speed = 4;
    }
    if (level >= 16 && level <= 18) {
      speed = 3;
    }
    if (level >= 19 && level <= 28) {
      speed = 2; 
    }
    if (level >= 29) {
      speed = 1;
    }
    
    
    
  }
  
  
  
}

void drawBox(int x, int y, int size, int index) {
  /*
  
  T (i2) - color 1 white core
  J (i5) - color 1 solid
  Z (i4) - color 2 solid
  O (i1) - color 1 white core
  S (i3) - color 1 solid
  L (i6) - color 2 solid
  I (i0) - color 1 white core
  
  
  
  */
  color color1 = color(0,0,0);
  color color2 = color(0,0,0);
  
  int levelIndex = level%10;
  
  switch(levelIndex) {
    case 0:
      color1 = color(0,88,248);
      color2 = color(60,188,252);
    break;
    case 1:
      color1 = color(0,168,0);
      color2 = color(184,248,24);
    break;
    case 2:
      color1 = color(216,0,204);
      color2 = color(248,120,248);
    break;
    case 3:
      color1 = color(0,88,248);
      color2 = color(88,216,84);
    break;
    case 4:
      color1 = color(228,0,88);
      color2 = color(88,248,152);
    break;
    case 5:
      color1 = color(88,248,152);
      color2 = color(104,136,252);
    break;
    case 6:
      color1 = color(248,56,0);
      color2 = color(124,124,124);
    break;
    case 7:
      color1 = color(104,68,252);
      color2 = color(168,0,32);
    break;
    case 8:
      color1 = color(0,88,248);
      color2 = color(248,56,0);
    break;
    case 9:
      color1 = color(248,56,0);
      color2 = color(252,160,68);
    break;
  }
  
  
  noStroke();
  switch(index) {
    case 0:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color1); //blue
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/4,y+size/4,size/2,size/2);
      rect(x+size/18, y+size/18, size/6, size/6);
    break;
    
    case 1:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color1); //blue
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/4,y+size/4,size/2,size/2);
      rect(x+size/18, y+size/18, size/6, size/6);
    break;
    
    case 2:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color1); //blue
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/4,y+size/4,size/2,size/2);
      rect(x+size/18, y+size/18, size/6, size/6);
    break;
    
    case 3:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color1); //blue
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/18, y+size/18, size/6, size/6);
      rect(x+4*size/18, y+4*size/18, size/6, size/6);
      rect(x+4*size/18, y+7*size/18, size/6, size/6);
      rect(x+7*size/18, y+4*size/18, size/6, size/6);
    break;
    
    case 4:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color2); //red
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/18, y+size/18, size/6, size/6);
      rect(x+4*size/18, y+4*size/18, size/6, size/6);
      rect(x+4*size/18, y+7*size/18, size/6, size/6);
      rect(x+7*size/18, y+4*size/18, size/6, size/6);
    break;
    
    case 5:
      fill(0,0,0); //black
      rect(x,y,size,size);
      fill(color1); //blue
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/18, y+size/18, size/6, size/6);
      rect(x+4*size/18, y+4*size/18, size/6, size/6);
      rect(x+4*size/18, y+7*size/18, size/6, size/6);
      rect(x+7*size/18, y+4*size/18, size/6, size/6);
    break;
    
    case 6:
      fill(0,0,0); //black
      rect(x,y,size,size); 
      fill(color2); //red
      rect(x+size/18, y+size/18, 8*size/9, 8*size/9);
      fill(255,255,255); //white
      rect(x+size/18, y+size/18, size/6, size/6);
      rect(x+4*size/18, y+4*size/18, size/6, size/6);
      rect(x+4*size/18, y+7*size/18, size/6, size/6);
      rect(x+7*size/18, y+4*size/18, size/6, size/6);
    break;
    
  }
  stroke(1);
}

void displayTexts() {
  //fill(0,0,0);
  textSize(30);
  textAlign(CENTER, CENTER);
  text(linesCleared, 490, 57);
  text(level, 653, 510);
  textAlign(LEFT, CENTER);
  text(highScore, 600, 115);
  text(score, 600, 190);
  //statistics
  fill(128,0,0);
  text(statistics[0], 160, 580);//i
  text(statistics[1], 160, 430);//o
  text(statistics[2], 160, 270);//t
  text(statistics[3], 160, 480);//s
  text(statistics[4], 160, 380);//z
  text(statistics[5], 160, 330);//j
  text(statistics[6], 160, 530);//l

  
}

void displayPause() {
  int n = -100;
  fill(255,255,255);
  rect(180,250+n,460,300);
  fill(0,0,0);
  rect(190,260+n,440,280);
  fill(255,255,255);
  text("Game paused\n\nPress p to\nunpause game", 200, 280);
}

void drawStatisticsPieces() {
  int boxSize = 18;
  
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 4; j++) {
      if (pieces[0][i][j] == 2) {
        drawBox(boxSize*j + 75, boxSize*i + 555, boxSize, 0);
      }
      
      if (pieces[1][i][j] == 2) {
        drawBox(boxSize*j + 70, boxSize*i + 415, boxSize, 1);
      }
      
      if (pieces[2][i][j] == 2) {
        drawBox(boxSize*j + 80, -boxSize*i + 282, boxSize, 2);
      }
      
      if (pieces[3][i][j] == 2) {
        drawBox(boxSize*j + 80, boxSize*i + 465, boxSize, 3);
      }
      
      if (pieces[4][i][j] == 2) {
        drawBox(boxSize*j + 80, boxSize*i + 365, boxSize, 4);
      }
      
      if (pieces[5][i][j] == 2) {
        drawBox(-boxSize*j + 115, -boxSize*i + 330, boxSize, 5);
      }
      
      if (pieces[6][i][j] == 2) {
        drawBox(-boxSize*j + 115, -boxSize*i + 530, boxSize, 6);
      }
      
    }
  }
  
}

int setLevel(char key1, int adjustment) {
  if (key1 == '0') {
    return 0+adjustment;
  }
  if (key1 == '1') {
    return 1+adjustment;
  }
  if (key1 == '2') {
    return 2+adjustment;
  }
  if (key1 == '3') {
    return 3+adjustment;
  }
  if (key1 == '4') {
    return 4+adjustment;
  }
  if (key1 == '5') {
    return 5+adjustment;
  }
  if (key1 == '6') {
    return 6+adjustment;
  }
  if (key1 == '7') {
    return 7+adjustment;
  }
  if (key1 == '8') {
    return 8+adjustment;
  }
  if (key1 == '9') {
    return 9+adjustment;
  }
  return 0;
}


PImage backgroundPlate;

void setup() {
  size(800,700);
  nextPiece = floor(random(0, pieces.length));
  spawnPiece();
  backgroundPlate = loadImage("Modified tetris board.jpg");
  PFont font;
  font = createFont("emulogic.ttf", 5);
  textFont(font);
  frameRate(60);

}




int frame = 0;
int prevFrame = -1;
int[] centerOfRotation = {0,0};
int pieceIndex = -1;
int speed = 2;
int speedCounter = 0;
int score = 0;
int highScore = 0;
boolean gameLost = false;
int nextPiece = 0;
int linesCleared = 0;
int level = 0;
int[] statistics = {0,0,0,0,0,0,0};
boolean isFastDrop = false;
boolean paused = false;
int startingLevel = 0;
boolean isShift = false;
int lastMillis = 0;
int currentMillis = 0;

void keyPressed() {
  if (key == 'a') {
    movePiece(-1);
  }
  if (key == 'd') {
    movePiece(1);
  }
  if (key == 'j') {
    rotatePieceCW();
  }
  if (key == 'l') {
    rotatePieceCCW();
  }
  if (key == 's') {
    dropPieceCompletely();
    speedCounter = 0;
  }
  if (key == 'w') {
    isFastDrop = true;
  }
  if (key == 'p' && !gameLost) {
    paused = !paused;
  }
  
  if (keyCode == ENTER && gameLost == true) {
    grid = new float[23][10];
    gameLost = false;
    if (score > highScore) {
      highScore = score;
    }
    nextPiece = floor(random(0, pieces.length));
    setSpeed();
    spawnPiece();
    score = 0;
    level = 0;
    print("enterpressed");
  }

  char key1 = key;
  
  if (gameLost == true) {
    if (key == ')' || key == '!' || key == '@' || key == '#' || key == '$' || key == '%' || key == '^' || key == '&' || key == '*' || key == '(') {
      if (key1 == ')') {
        level = 10;
      }
      if (key1 == '!') {
        level = 11;
      }
      if (key1 == '@') {
        level = 12;
      }
      if (key1 == '#') {
        level = 13;
      }
      if (key1 == '$') {
        level = 14;
      }
      if (key1 == '%') {
        level = 15;
      }
      if (key1 == '^') {
        level = 16;
      }
      if (key1 == '&') {
        level = 17;
      }
      if (key1 == '*') {
        level = 18;
      }
      if (key1 == '(') {
        level = 19;
      }
      grid = new float[23][10];
      gameLost = false;
      if (score > highScore) {
        highScore = score;
      }
      nextPiece = floor(random(0, pieces.length));
      spawnPiece();
      setSpeed();
      score = 0;
      linesCleared = 0;
    } else if (key == '0' || key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9') {
      level = setLevel(key1,0);
      grid = new float[23][10];
      gameLost = false;
      if (score > highScore) {
        highScore = score;
      }
      nextPiece = floor(random(0, pieces.length));
      spawnPiece();
      setSpeed();
      score = 0;
    }
    
  }
  
}

void keyReleased() {
  if (key == 'w') {
    isFastDrop = false;
  }
  
}

void draw() {

  background(0,0,0);
  image(backgroundPlate, 0, 0);
  speedCounter++;
  
  checkLevel();
  setSpeed();
  
  if (isFastDrop == true) {
    speed = speed/10;
  }
  
  
  currentMillis = millis();
  if ((currentMillis - lastMillis)/16.67 >= speed && !gameLost && !paused) {

    lastMillis = currentMillis;
    frame++;
    speedCounter = 0;
    
  }
  
  
  if (frame != prevFrame+1 && !gameLost && !paused) {
    prevFrame++;
    //Advance 1 frame code here
    if (canDropPiece()) {
      dropPiece();
    } else {
      freezePiece();
      spawnPiece();
      if (!canDropPiece()) {
        gameLost = true;
      }
    }
  }
  
  checkAndClearLines();
  displayTexts();
  drawNextPiece();

  //Board printer
  /*
  println("-------------------------------------------");
  for (int i = 10; i < 23; i++) {
    for (int j = 0; j < 10; j++) {
      print(grid[i][j] + " ");
    }
    println();
  }
  */
  drawTetris(298, 125, 25);
  drawStatisticsPieces();
  if (gameLost) {
    playAgainText();
  }
  if (paused) {
    displayPause();
  }
  
}
