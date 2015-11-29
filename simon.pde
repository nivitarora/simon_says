/*Program: simon.pde
  Author:  Nivita Arora
  Date: 01/07/15
  Notes: 
*/

color sectionColor;
color newColor;
color blue = color(0, 200, 250);
color brightBlue = color(177, 236, 250);
color midnight = color(70, 0, 193);
color brightMidnight = color(130, 59, 255);
color green = color(31, 175, 0);
color brightGreen = color(45, 250, 0);
color purple = color(160, 0, 178);
color brightPurple = color(229, 0, 255);
color soundButton =  color(240, 114, 56);
color newGameButton = color(240, 245, 116);
color lastGameButton = color(255, 170, 0);
color scoresButton = color(255, 0, 17);
color shareButton = color(252, 228, 0);
boolean playSound = true;
int frames;
int [] sequence;
int state = 0;
int round = 1;
int count = 0;
int score = 0;
PrintWriter output;
int highScores [] = {};
int level = 1;
import arb.soundcipher.*;
SoundCipher sc = new SoundCipher(this);    

void setup () {
  size(500, 500);
  background(157, 255, 218);
  drawBoard();
  sc.instrument(0);
  output = createWriter("simonScores.scr");
}//setup()

void draw () {
  if (state == 0) {
    if(frameCount - frames > 50) {
      drawBoard();
    }
  }//state 0 (open state)
  else if (state == 1) {
    setColors();
    if (frameCount - frames > 50) {
      drawBoard();
      if (count < round) {
        flash(sectionColor);
        sound(sectionColor);
        setLevel();
        count++;
      }
      else {
        state = 2;
        count = 0;
      }
    }
  }//state 1 (play sequence)
  else if (state == 2) {
    if (frameCount - frames > 50) {
      drawBoard();
    }
  }//state 2 (listen for mousePressed)
  else {
    drawScoreboard();
  }//state 3 (display scoreboard)
  print("state:" + state);
  print(" round:" + round);
  print(" count:" + count);
  print(" frames:" + frames);
  println(" frameCount:" + frameCount);
}//draw()

void mousePressed () {
  loadPixels();
  if (state == 0) {
    setColors();
    flash(sectionColor);
    sound(sectionColor);
    if (sectionColor == soundButton) {
      playSound = !playSound;
      fill(soundButton);
      ellipse(width/2, height/2-50, width/12, height/12);
      if (playSound) {
        text("on", width/2-7, height/2-40);
      }//sound on
      else {
        text("off", width/2-7, height/2-40);
      }//sound off
    }//sound
    else if (sectionColor == newGameButton) {
      level = 1;
      setSequence();
      state = 1;
      round = 1;
      count = 0;
      score = 0;
    }//new game
    else if (sectionColor == lastGameButton) {
      state = 1;
      round = 1;
      count = 0;
      score = 0;
    }//last game
    else if (sectionColor == scoresButton) {
      state = 3;
    }//scoreboard
    else if (sectionColor == shareButton) {
      
    }//share
  }//state 0 (open state)
  else if (state == 1) {
    //nothing
  }//state 1 (no buttons work - playing sequence)
  else if (state == 2) {
    if (get(mouseX, mouseY) == soundButton) {
      playSound = !playSound;
      fill(soundButton);
      ellipse(width/2, height/2-50, width/12, height/12);
      if (playSound) {
        text("on", width/2-7, height/2-40);
      }//sound on
      else {
        text("off", width/2-7, height/2-40);
      }//sound off
    }//sound
    else if (get(mouseX, mouseY) == newGameButton) {
      level = 1;
      setSequence();
      state = 1;
      round = 1;
      count = 0;
      score = 0;
    }//new game
    else if (get(mouseX, mouseY) == lastGameButton) {
      state = 1;
      round = 1;
      count = 0;
      score = 0;
    }//last game
    else if (get(mouseX, mouseY) == scoresButton) {
      state = 3;
    }//scoreboard
    else if (get(mouseX, mouseY) == shareButton) {
      
    }//share
    else {
      setColors();
      if (count < round) {
        if (sectionColor == get(mouseX, mouseY)) {
          count++;
          score++;
          flash(sectionColor);
          sound(sectionColor);
        }//pressed correct color
        else {
          if (playSound) {
            sc.playNote(25, 100, 3.0);
          }//game over sound
          output.println("username: ");
          output.println("score: " + score);
          output.println("date: " + month() + "/" + day() + "/" + year());
          output.println("");
          output.flush();
          append(highScores, score);
          score = 0;
          count = 0;
          round = 1;
          state = 0;
        }//pressed wrong color - game over
      }
      if (count == round) {
        state = 1;
        count = 0;
        round++;
      }//reset to play next sequence
    }
  }//state 2
  else {
    state = 0;
    drawBoard();
  }//state 3 (exit scoreboard)
}//mousePressed()

void drawBoard () {
  stroke(0);
  strokeWeight(10);
  fill(0);
  ellipse(width/2, height/2, width/1.25, height/1.25);
  fill(blue);
  arc(width/2, height/2, width/1.25, height/1.25, 0, HALF_PI, PIE);
  fill(green);
  arc(width/2, height/2, width/1.25, height/1.25, HALF_PI, PI, PIE);
  fill(midnight);
  arc(width/2, height/2, width/1.25, height/1.25, PI, PI+HALF_PI, PIE);
  fill(purple);
  arc(width/2, height/2, width/1.25, height/1.25, PI+HALF_PI, 2*PI, PIE);
  fill(0);
  ellipse(width/2, height/2, width/3, height/3);
  noStroke();
  fill(shareButton);
  rect(width/2-20, height/2, width/12, height/18);
  fill(soundButton);
  ellipse(width/2, height/2-50, width/12, height/12);
  fill(newGameButton);
  ellipse(width/2+50, height/2, width/12, height/12);
  fill(lastGameButton);
  ellipse(width/2-50, height/2, width/12, height/12);
  fill(scoresButton);
  ellipse(width/2, height/2+50, width/12, height/12);
  fill(255);
  text("score: " + str(score), width/2-21, height/2-10);
  fill(0);
  text("share", width/2-14, height/2+11);
  text("score", width/2-14, height/2+22);
  text("sound", width/2-16, height/2-50);
  if (playSound) {
    text("on", width/2-7, height/2-40);
  }
  else {
    text("off", width/2-7, height/2-40);
  }
  text("new", width/2+40, height/2-3);
  text("game", width/2+37, height/2+8);
  text("last", width/2-59, height/2-3);
  text("game", width/2-64, height/2+8);
  text("high", width/2-10, height/2+48);
  text("scores", width/2-17, height/2+60);
}//drawBoard()

void drawScoreboard () {
  fill(11, 112, 216);
  rect(width/4, height/4, width/2, height/2);
  fill(255);
  textSize(18);
  text("High Scores", width/2-40, height/4+25);
  textSize(11.5);
}//drawScoreboard()

void setColors () {
  if (state == 0) {
    sectionColor = get(mouseX, mouseY);
    if (sectionColor == blue) {
      newColor = brightBlue;
    }
    else if (sectionColor == midnight) {
      newColor = brightMidnight;
    }
    else if (sectionColor == green) {
      newColor = brightGreen;
    }
    else if (sectionColor == purple) {
      newColor = brightPurple;
    }
    else {
      newColor = sectionColor;
    }
  }//if state is 0
  else if (count < level*5) {
    if (sequence[count] == 0) {
      sectionColor = blue;
      newColor = brightBlue;
    }//0 = light blue
    else if (sequence[count] == 1) {
      sectionColor = midnight;
      newColor = brightMidnight;
    }//1 = light midnight
    else if (sequence[count] == 2) {
      sectionColor = green;
      newColor = brightGreen;
    }//2 = light green
    else {
      sectionColor = purple;
      newColor = brightPurple;
    }//3 = light purple
  }//if state is not 0 and level is not finished yet
}//setColors()

void sound (color sectionColor) {
  if (playSound) {
    if (sectionColor == blue) {
      sc.playNote(55,60,1.0);
    }
    else if (sectionColor == midnight) {
      sc.playNote(60,60,1.0);
    }
    else if (sectionColor == green) {
      sc.playNote(65,60,1.0);
    }
    else if (sectionColor == purple) {
      sc.playNote(70,60,1.0);
    }
  }//play sounds if sound is on
}//sound(color sectionColor)

void flash (color sectionColor) {
  frames = frameCount;
  loadPixels();
  for (int i = 0; i < width*height; i++) {
    if (pixels[i] == sectionColor){
      pixels[i] = color(newColor);
    }
  }//check pixels of entire canvas
  updatePixels();
}//flash(color sectionColor)

void setSequence () {
  sequence = new int [level*5];
  for (int i = 0; i < sequence.length; i++) {
    sequence[i] = floor(random(0,4));
    print(sequence[i] + " ");
  }//generate sequence of #s 0 to 3 of length depending on level
  println("");
}//setSequence()

void setLevel () {
  if (round > level*5) {
    level++;
    frames = frameCount + 150;
    fill(255);
    textSize(14);
    text("level up yay. level " + level, width/2-50, height/4);
    textSize(11.5);
    setSequence();
    state = 1;
    count = -1;
    round = 1;
  }//level up if level completed
}//setLevel()
