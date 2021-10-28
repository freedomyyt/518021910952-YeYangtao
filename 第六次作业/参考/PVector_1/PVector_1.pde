void setup() {
      size(640,360);
}
void draw() {
  background(0);
      PVector mouse = new PVector(mouseX,mouseY); // A vector that points to the mouse location
      PVector center = new PVector(width/2,height/2); // A vector that points to the center of the window
      mouse.sub(center); // Subtract center from mouse which results in a vector that points from center to mouse
      mouse.normalize(); // Normalize the vector
      mouse.mult(150); // Multiply its length by 150 (Scaling its length) 
      translate(width/2,height/2);
      // Draw the resulting vector
      stroke(255);
      strokeWeight(4);
      line(0,0,mouse.x,mouse.y);
  }
