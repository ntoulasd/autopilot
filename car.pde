import processing.video.*;

// Size of each cell in the grid, ratio of window size to video size
int videoScale = 4;
// Number of columns and rows in the system
int cols, rows;
// Variable to hold onto Capture object
Capture video;

int avg=0, avgc=0;
int favg=0, favgc=0;

int thres=200;

void setup() {  
  size(640, 600);  
  // Initialize columns and rows  
  cols = 640/videoScale;  
  rows = 480/videoScale;  
  background(0);
  video = new Capture(this, cols, rows);
  video.start();
}

// Read image from the camera
void captureEvent(Capture video) {  
  video.read();
}

void draw() {
  video.loadPixels();  
  // Begin loop for columns  (right)
  for (int i = 0; i < cols; i++) {    
    // Begin loop for rows    (down)
    for (int j = 0; j < rows; j++) {      
      // Where are you, pixel-wise?      
      int x = i*videoScale;      
      int y = j*videoScale;
      color c = video.pixels[i + j*video.width];
      if (brightness(c)>thres) {
        c=color(255); 
        avg=avg+y;
        avgc++;
      } else {
        //c=color(0);
      }
      fill(c);   
      stroke(0);      
      rect(x, y, videoScale, videoScale);
    } 
    if (avgc<20)
    {
      thres--;
    } 
    if (avgc>5) {
      thres++;
    }

    if (avgc>0) {
      color c=color(255, 0, 0);
      fill(c);   
      stroke(0);
      rect(i*videoScale, avg/avgc, videoScale, videoScale);
      favg=favg+avg/avgc;
      favgc++;
      avg=0;
      avgc=0;
    }
  }
  if (favgc>0) {
    color c=color(0, 255, 0);
    fill(c);   
    stroke(0);
    rect(0, favg/favgc, width, videoScale);
    fill(0); 
    rect(0, 490, 100, 20);
    fill(c); 
    text("Center "+favg/favgc, 0, 500);
    println(favg/favgc);
    favg=0;
    favgc=0;
  }
}
