class RocketSystem
{
  Rocket Rockets[];
  Rocket NextRockets[];
  ArrayList<Obstacle> Obstacles;
  PVector start;
  PVector goal;
  int maxMoves;
  int currentMove;
  int generation;
  int hitRockets;
  int crashedRockets;
  float mutationChance;
  int parentChance;
  int hitHistory[];
  int hitHistoryIndex;

  float fitMax, fitAvg;

  RocketSystem(int amount, int maxMoves, PVector start, PVector goal, int parentChance, float mutationChance)
  {
    this.mutationChance = mutationChance;
    this.parentChance = parentChance;
    this.start = new PVector(start.x, start.y);
    this.goal = new PVector(goal.x, goal.y);

    this.maxMoves = maxMoves;
    this.currentMove = 0;
    this.generation = 1;
    hitHistory = new int[20];
    hitHistoryIndex = 0;

    Rockets = new Rocket[amount];
    NextRockets = new Rocket[amount];
    for (int i = 0; i < Rockets.length; i++)
    {
      Rockets[i] = new Rocket(start, maxMoves, true);
      NextRockets[i] = new Rocket(start, maxMoves, false);
    }
    Obstacles = new ArrayList<Obstacle>();
  }

  void addObstacle(int x, int y, int radius)
  {
    Obstacles.add(new Obstacle(new PVector(x, y), radius));
  }

  void buildGeneration()
  {
    for (int i = 0; i < Rockets.length; i++)
    {
      NextRockets[i].reset(start);

      //Two stage selection, may be trash
      int cut1 = (int) random(maxMoves / 2);
      int cut2 = (int) random(maxMoves / 2) + (maxMoves / 2);

      //Take upper 30%
      //randomGaussian is not optimal, find better method
      int p1 = (int) (abs(randomGaussian()) * 3);
      int p2 = (int) (abs(randomGaussian()) * 3);
      println(p1 + " : " + p2);
      for (int j = 0; j < maxMoves; j++)
      {
        float mut = random(1);
        if (mut < mutationChance)
        {
          NextRockets[i].moves[j] = PVector.random2D();
        } else
        {
          if (i > cut1 && i < cut2)
          {
            NextRockets[i].moves[j].set(Rockets[p2].moves[j]);
          } else
          {
            NextRockets[i].moves[j].set(Rockets[p1].moves[j]);
          }
        }
      }
    }
    for (int i = 0; i < Rockets.length; i++)
    {
      Rockets[i] = NextRockets[i];
    }
  }

  void update()
  {
    crashedRockets = 0;
    hitRockets = 0;
    if (currentMove < maxMoves)
    {
      for (Rocket r : Rockets)
      {
        r.addMoveForce(currentMove);
        r.applyForce();
        r.checkGoal(goal);
        for (Obstacle o : Obstacles)
        {
          r.checkCollision(o);
        }
        if (r.hit) hitRockets++;
        if (r.crashed) crashedRockets++;
        hitHistory[hitHistoryIndex] = hitRockets;
      }
      currentMove++;
    } else
    {
      calculateStats();
      println(generation + " Hit " + hitRockets +  " Crashed " + crashedRockets + " FitAvg " + fitAvg);
      sortRockets();
      buildGeneration();
      currentMove = 0;
      generation++;
      hitHistoryIndex = (hitHistoryIndex + 1) % 20;
    }
  }

  void sortRockets()
  {
    int n = Rockets.length;
    Rocket temp;
    do {
      int newn = 1;
      for (int i=0; i < n-1; ++i) 
      {
        if (Rockets[i].fitness < Rockets[i+1].fitness) 
        {
          temp = Rockets[i];
          Rockets[i] = Rockets[i + 1];
          Rockets[i + 1] = temp;
          newn = i+1;
        }
      }
      n = newn;
    } while (n > 1);
  }

  void calculateStats()
  {
    fitMax = 0;
    fitAvg = 0;

    for (int i = 0; i < Rockets.length; i++)
    {
      Rockets[i].calculateFitness(goal);
      fitAvg += Rockets[i].fitness;
      if (Rockets[i].fitness > fitMax) fitMax = Rockets[i].fitness;
    }
    fitAvg /= Rockets.length;
  }

  void show()
  {
    noStroke();
    fill(200, 50);
    rect(0, 0, width, height);

    for (Obstacle o : Obstacles)
    {
      o.show();
    }
    for (Rocket r : Rockets)
    {
      strokeWeight(4);
      r.show();
    }

    //Start and goal
    stroke(200, 0, 0);
    noFill();
    ellipse(goal.x, goal.y, 20, 20);
    stroke(0, 0, 200);
    ellipse(start.x, start.y, 10, 10);

    //Statistics
    textSize(20);
    text("Generation: " + generation, 0, height - 70);
    text("Hit: " + hitRockets, 0, height - 50);
    text("Crashed: " + crashedRockets, 0, height - 30);
    text("FitAvg: " + fitAvg, 0, height - 10);

    //History of hit rockets graph
    strokeWeight(1);
    stroke(0);
    translate(width - 10 * hitHistory.length, height- 2 * hitHistory.length);
    rect(0, 0, 10 * hitHistory.length, 2 * hitHistory.length);
    fill(0, 200, 0);
    beginShape();
    vertex(0, 2 * hitHistory.length);
    for (int i = 0; i < hitHistory.length; i++)
    {
      int index = (hitHistoryIndex + i) % 20;
      vertex(10 * i, 2 * hitHistory.length - ((100 - hitHistory[index]) * 0.02 * hitHistory.length));
      
    }
    vertex(10 * hitHistory.length, 2 * hitHistory.length);
    endShape(CLOSE);
  }
}