int dot_num = 50;
int max_rotation_radius = 50; //max rotating radius
int rotation_radius[] = new int[dot_num];  //rotation radius of each ball
int dispersion = 10;
int dot_radius = 10;
PVector location[] = new PVector[dot_num]; //the local of dots
color dot_color[] = new color[dot_num];  //color of dots
float mtheta[] = new float[dot_num]; //angle
float dtheta[] = new float[dot_num]; //angle speed


void setup() 
{
    size(640, 480);
    background(255);
    frameRate(60);
    for (int i = 0; i < dot_num - 1; i++) {
        dot_color[i] = color(random(100, 200), random(100, 200), random(100, 200));
        location[i] = new PVector(random(width), random(height));
        dtheta[i] = random(PI / 24);
        mtheta[i] = round(random(360)) / 180 * PI;
        rotation_radius[i] = round(random( -dispersion, dispersion));
    }
}
        
void draw() 
{
  fill(25,25, 25, 25);
  rect(0, 0, width, height);
            
  pushMatrix();
  noStroke();
  for (int i = 0; i < dot_num - 1; i++) 
  {
    //calculate current location of balls
    mtheta[i] += dtheta[i]; 
    location[i].lerp(mouseX + cos(mtheta[i]) * (rotation_radius[i] + max_rotation_radius), mouseY + sin(mtheta[i]) * (rotation_radius[i] + max_rotation_radius), 0, 0.07);
    
    fill(dot_color[i]);
    ellipse(location[i].x, location[i].y, dot_radius, dot_radius);
  }
  popMatrix();
}
                
void mouseWheel(MouseEvent event) 
{
  float e = event.getCount();
  if (e == -1) 
    max_rotation_radius += 10;
  if (e == 1) 
    max_rotation_radius -= 10;
}
                
