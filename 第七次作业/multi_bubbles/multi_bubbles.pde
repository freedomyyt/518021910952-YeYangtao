void setup() 
{
    size(800,800);
    background(255);
    drawCircle(width / 2,height / 2,200);
}

void draw()
{
  if (mousePressed)
  {
    drawCircle(mouseX,mouseY,200);
    delay(500);
  }
}
void drawCircle(float x, float y, float radius) 
{
    noStroke();
    fill(random(x),random(y),random(radius),50);
    ellipse(x,y,radius,radius);
    if (radius > 50) 
    {
        drawCircle(x + radius / 2,y + radius / 2,radius * 2 / 3);
        drawCircle(x - radius / 2,y + radius / 2,radius * 2 / 3);
        drawCircle(x - radius / 2,y - radius / 2,radius * 2 / 3);
        drawCircle(x + radius / 2,y - radius / 2,radius * 2 / 3);
    }
}    