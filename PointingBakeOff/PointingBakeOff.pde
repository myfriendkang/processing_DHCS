import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.*;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet; 
// Sound libary
int margin = 200; //set the margina around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initalized in setup 

float nextButtonX;
float nextButtonY;     

float currentButtonX;
float currentButtonY;
float storedTime = 0;
float storedCursorX;
float storedCursorY;
int numRepeats = 1; //sets the number of times each button repeats in the test
int  isHited = 0;
//Sound variable
Minim m;
AudioPlayer click;

void setup()
{
  size(700, 700); // set the size of the window
  //setup sound
  m = new Minim(this);
  click = m.loadFile("click.wav");

  surface.setLocation(displayWidth/2-350, displayHeight/2-350);
  //surface.setAlwaysOnTop(true);

  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }
  System.out.println(numRepeats);
  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
    // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);

  //frame.setLocation(0, 0); // put window in top left corner of screen (doesn't always work)
}



void draw()
{

  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + (finishTime-startTime) / 1000f + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec", width / 2, height / 2 + 100);      
    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  stroke(255, 0, 0);
  strokeWeight(2);
  line(mouseX-15, mouseY, mouseX+15, mouseY);
  line(mouseX, mouseY+15, mouseX, mouseY-15);
  noFill();
  ellipse(mouseX, mouseY, 20, 20);
  DrawLine();
}

void mousePressed() // test to see if hit was in target!
{
  InputFunction();
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
  int x = (i % 4) * (padding + buttonSize) + margin;
  int y = (i / 4) * (padding + buttonSize) + margin;
  return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);
  Rectangle nextBounds;
  if (trialNum != trials.size()-1) { //check if final click
    if (trials.get(trialNum) == i) {// see if current button is the target
      SetCurrentButton(bounds.x, bounds.y);
      //fill(0, 255, 255); // if so, fill cyan
      fill(255, 0, 0);
    } else if (trials.get(trialNum+1) == i) // show next button
    {
      nextBounds = getButtonLocation(i);
      SetNextButton(nextBounds.x, nextBounds.y);
      //fill(0, 50, 50); // if so, fill dark cyan
      fill(64, 64, 64);
    } else
      fill(200); // if not, fill gray
  } else {
    if (trials.get(trialNum) == i) // see if current button is the target
      //fill(0, 255, 255); // if so, fill cyan
      fill(255,0,0);
    else
      fill(200); // if not, fill gray
  }

  rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
}

void mouseMoved()
{
  //can do stuff everytime the mouse is moved (i.e., not clicked)
  //https://processing.org/reference/mouseMoved_.html
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{

  if (keyCode ==32) {
    InputFunction();
  } else if (keyCode == 82) {   //Keycode 82 is 'R' keyboard button
    //  Reset();
  }
}
/*
void Reset() {   //if you press R button, you can restart the sketch.
 trialNum = 0; 
 startTime = 0;
 finishTime = 0;
 hits = 0;
 misses = 0; 
 numRepeats = 1;
 trials = new ArrayList<Integer>();
 
 setup();
 }
 */
void SetNextButton(float x, float y) {

  nextButtonX = x;
  nextButtonY = y;
}
void SetCurrentButton(float x, float y) {
  currentButtonX = x;
  currentButtonY = y;
}
void DrawLine() {
  stroke(255, 0, 0);
  strokeWeight(4);
 if (trialNum != trials.size()-1) { 
  line(mouseX, mouseY, currentButtonX + (buttonSize/2), currentButtonY + (buttonSize/2));
 }
 else{
   line(mouseX, mouseY, nextButtonX + (buttonSize/2), nextButtonY + (buttonSize/2));
 }
  noStroke();
}

void InputFunction() {
  
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output:
    println("Hits: " + hits);
    println("Misses: " + misses);
    println("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%");
    println("Total time taken: " + (finishTime-startTime) / 1000f + " sec");
    println("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec");
  }






  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  
  float buttonCenterX = bounds.x+bounds.width/2;
  float buttonCenterY = bounds.y+bounds.height/2;
  //System.out.println(trialNum + "," + buttonCenterX + "," + buttonCenterY + "," +bounds.width + "," +(millis() - startTime)/1000 + ",1"); // success
  
  
  StoreCursorPos(mouseX,mouseY);
  //check to see if mouse cursor is inside button 
  if ((mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    //System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    System.out.println(trialNum + "," +"1,"+ storedCursorX +","+ storedCursorY+"," +buttonCenterX+"," + buttonCenterY + "," + bounds.width +","+(millis() - storedTime)/1000f + "," + "1" ); // success
    hits++;
    storedTime = millis();
    //sound play and rewind after play
    click.play();
    click.rewind();
  } else
  {
  System.out.println(trialNum + "," +"1,"+ storedCursorX +","+ storedCursorY+"," +buttonCenterX+"," + buttonCenterY + "," + bounds.width +","+(millis() - storedTime)/1000f + "," + "0" ); // success
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
    storedTime = millis();
  }
  
  trialNum++; //Increment trial number
  //int[] posMouse = surface.setLocation(displayWidth/2-350,displayHeight/2-350);
  //in this example code, we move the mouse back to the middle
  //robot.mouseMove(displayWidth/2,displayHeight/2);
  
}

void StoreCursorPos(float x, float y ){
  storedCursorX = x;
  storedCursorY = y;
}