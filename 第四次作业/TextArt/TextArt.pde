import geomerative.*;

RFont f;
RShape grp;
RPoint[] points;

int flag = 1; //represent A

void setup() {
  size(1200, 800);
  frameRate(3);

  RG.init(this);
  
  grp = RG.getText("A", "Conther-2.ttf", 500, CENTER);

  smooth();
}

void draw() {
  background(255);

  push();
  translate(width/2, height/3*2);

  RG.setPolygonizer(RG.ADAPTATIVE);
  stroke(120, 120, 120);
  strokeWeight(10);
  grp.draw();

  points = grp.getPoints();

  if (points != null)
  {
    if (flag == 26)
      flag = 1;
    else 
      flag = flag+1;

    switch(flag)
    {
      case 1: 
        grp = RG.getText("A", "Conther-2.ttf", 500, CENTER);
        break;
      case 2:
        grp = RG.getText("B", "Conther-2.ttf", 500, CENTER);
        break;
      case 3: 
        grp = RG.getText("C", "Conther-2.ttf", 500, CENTER);
        break;
      case 4: 
        grp = RG.getText("D", "Conther-2.ttf", 500, CENTER);
        break;
      case 5: 
        grp = RG.getText("E", "Conther-2.ttf", 500, CENTER);
        break;
      case 6: 
        grp = RG.getText("F", "Conther-2.ttf", 500, CENTER);
        break;
      case 7: 
        grp = RG.getText("G", "Conther-2.ttf", 500, CENTER);
        break;
      case 8: 
        grp = RG.getText("H", "Conther-2.ttf", 500, CENTER);
        break;
      case 9: 
        grp = RG.getText("I", "Conther-2.ttf", 500, CENTER);
        break;
      case 10: 
        grp = RG.getText("J", "Conther-2.ttf", 500, CENTER);
        break;
      case 11: 
        grp = RG.getText("K", "Conther-2.ttf", 500, CENTER);
        break;
      case 12: 
        grp = RG.getText("L", "Conther-2.ttf", 500, CENTER);
        break;
      case 13: 
        grp = RG.getText("M", "Conther-2.ttf", 500, CENTER);
        break;
      case 14: 
        grp = RG.getText("N", "Conther-2.ttf", 500, CENTER);
        break;
      case 15:
        grp = RG.getText("O", "Conther-2.ttf", 500, CENTER);
        break;
      case 16: 
        grp = RG.getText("P", "Conther-2.ttf", 500, CENTER);
        break;
      case 17: 
        grp = RG.getText("Q", "Conther-2.ttf", 500, CENTER);
        break;
      case 18: 
        grp = RG.getText("R", "Conther-2.ttf", 500, CENTER);
        break;
      case 19: 
        grp = RG.getText("S", "Conther-2.ttf", 500, CENTER);
        break;
      case 20: 
        grp = RG.getText("T", "Conther-2.ttf", 500, CENTER);
        break;
      case 21: 
        grp = RG.getText("U", "Conther-2.ttf", 500, CENTER);
        break;
      case 22: 
        grp = RG.getText("V", "Conther-2.ttf", 500, CENTER);
        break;
      case 23: 
        grp = RG.getText("W", "Conther-2.ttf", 500, CENTER);
        break;
      case 24: 
        grp = RG.getText("X", "Conther-2.ttf", 500, CENTER);
        break;
      case 25: 
        grp = RG.getText("Y", "Conther-2.ttf", 500, CENTER);
        break;
      case 26: 
        grp = RG.getText("Z", "Conther-2.ttf", 500, CENTER);
        break;

      default: 
        grp = RG.getText("A", "Conther-2.ttf", 500, CENTER);
    }

    noFill();
    strokeWeight(5);
    // stroke(0, 0, 0);

    beginShape(POINTS);
    for (int i=0; i<points.length; i++)
    {
      float x1, y1; 
      if(i != frameCount)
        x1 = points[i].x;
      else
        x1 = 10000;
      y1 = points[i].y;
      stroke(random(255),random(255),random(255));
      ellipse(x1,y1,150,150);
    }
    endShape(CLOSE);
    pop();
  }
}
