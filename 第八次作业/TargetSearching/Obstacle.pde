class Obstacle
{
  PVector pos;
  int radius;
  
  Obstacle(PVector pos, int radius)
  {
    this.pos = new PVector(pos.x, pos.y);
    this.radius = radius;
  }
  
  void show()
  {
    stroke(0);
    fill(0);
    ellipse(pos.x, pos.y, radius, radius);
  }
}