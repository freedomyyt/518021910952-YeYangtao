float mutationChance = 0.001;
int parentChance = 20;
int rocketAmount = 1000;
int rocketFrames = 200;
boolean simulate = true;

RocketSystem rs;
PVector start, goal;


void setup()
{
  size(800, 800);
  start = new PVector(width/2, height - 20);
  goal = new PVector(width/2, 50);
  rs = new RocketSystem(rocketAmount, rocketFrames, start, goal, parentChance, mutationChance);
  for (int x=2;x<=6;x++)
  {
    if (x%2 != 0)
      for (int y=1;y<=7;y++)
        rs.addObstacle(100*y, 100*x, 50);
    if (x%2 == 0)
      for (int y=1;y<=6;y++)
        rs.addObstacle(100*y+50, 100*x, 50);
  }
}

void draw()
{
  if (simulate)
  {
    rs.update();    
  }
  rs.show();
}
