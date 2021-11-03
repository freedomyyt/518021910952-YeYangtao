class Rocket
{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector moves[];
  float fitness;
  boolean hit;
  boolean crashed;

  Rocket(PVector p, int maxMoves, boolean createMoves)
  {
    hit = false;
    crashed = false;
    pos = new PVector(p.x, p.y);
    vel = new PVector();
    acc = new PVector();
    moves = new PVector[maxMoves];
    for (int i = 0; i < moves.length; i++)
    {
      moves[i] = new PVector();
    }
    if (createMoves) generateMoves();
  }

  void checkGoal(PVector obj)
  {
    if (pos.dist(obj) < 10)
    {
      hit = true;
    }
  }

  void checkCollision(Obstacle o)
  {
    if (2 * pos.dist(o.pos) < o.radius) crashed = true;
    if (pos.x < 0 || pos.x > width || pos.y < -50 || pos.y > height) crashed = true;
  }

  void reset(PVector start)
  {
    hit = false;
    crashed = false;
    pos.set(start);
    acc.mult(0);
    vel.mult(0);
    fitness = 0;
  }

  void generateMoves()
  {
    for (int i = 0; i < moves.length; i++)
    {
      moves[i] = PVector.random2D();
    }
  }

  void calculateFitness(PVector goal)
  {
    // Fitness = 0 if crashed?
    if (hit) fitness = 1;
    else fitness = 100 / pos.dist(goal);
    if (crashed) fitness *= 0.7;
  }

  void addMoveForce(int i)
  {
    if (!hit && !crashed)
    {
      acc.x = moves[i].x;
      acc.y = moves[i].y;
    }
  }

  void applyForce()
  {
    if (!hit && !crashed)
    {
      vel.x += acc.x;
      vel.y += acc.y;
      pos.x += vel.x;
      pos.y += vel.y;

      acc.mult(0);
    }
  }

  void show()
  {
    if (hit) stroke(0, 200, 0);
    else if (crashed) stroke(200, 0, 0);
    else stroke(0);
    line(pos.x, pos.y, pos.x + vel.x, pos.y + vel.y);
  }
}