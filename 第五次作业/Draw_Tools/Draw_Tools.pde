int R=0;
int G=0;
int B=0;

void setup() 
{
  size(1920,1080);
  frameRate(60);

  background(233,219,165); 
  
  //draw region
  fill(255);
  rect(300,10,1600,1060);

  noStroke();

  //background color settiing region
  fill(225,193,116);
  rect(10,20,235,40);
  fill(255);
  textSize(30);
  text("background color",15,50);

  fill(0);
  rect(40,70,100,20);
  fill(120);
  rect(40,100,100,20);
  fill(255);
  rect(40,130,100,20);

  fill(255,0,0);
  circle(180,80,20);

  //line color setting region
  fill(225,193,116);
  rect(60,170,125,40);
  fill(255);
  textSize(30);
  text("line color",65,200);

  fill(0);
  rect(40,220,100,20);
  fill(120);
  rect(40,250,100,20);
  fill(255);
  rect(40,280,100,20);
  fill(239,164,0);
  rect(40,310,100,20);
  fill(50,80,46);
  rect(40,340,100,20);
  fill(57,162,135);
  rect(40,370,100,20);
  fill(254,92,88);
  rect(40,400,100,20);

  fill(255,0,0);
  circle(180,230,20);

  //line weigh setting region
  fill(225,193,116);
  rect(60,440,135,40);
  fill(255);
  textSize(30);
  text("line weigh",65,470);

  stroke(0);
  strokeWeight(2);
  line(60,510,150,510);
  strokeWeight(5);
  line(60,540,150,540);
  strokeWeight(10);
  line(60,570,150,570);
  strokeWeight(20);
  line(60,600,150,600);

  noStroke();
  fill(255,0,0);
  circle(180,510,20);  

  //clear paint
  fill(225,193,116);
  rect(80,900,115,70);
  fill(255);
  textSize(50);
  text("clear",85,950);

  strokeWeight(2);
  stroke(0);
}

void draw() 
{
  //start draw
  if (mousePressed) 
  {
    if ((mouseX>300)&&(mouseX<1900)&&(mouseY>10)&&(mouseY<1080))
    {    
      line(mouseX, mouseY, pmouseX, pmouseY);
    }
    else //settings
    {
      noStroke();

      //set background color
      if ((mouseX>40)&&(mouseX<140)&&(mouseY>70)&&(mouseY<90))
      {
        fill(0);
        rect(300,10,1600,1060);
        fill(255,0,0);
        circle(180,80,20);
        fill(233,219,165);
        circle(180,110,25);
        circle(180,140,25);
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>100)&&(mouseY<120))
      {
        fill(120);
        rect(300,10,1600,1060);
        fill(255,0,0);
        circle(180,110,20);
        fill(233,219,165);
        circle(180,140,25);
        circle(180,80,25);
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>130)&&(mouseY<150))
      {
        fill(255);
        rect(300,10,1600,1060);
        fill(255,0,0);
        circle(180,140,20);
        fill(233,219,165);
        circle(180,80,25);
        circle(180,110,25);
      }

      //set line color
      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>220)&&(mouseY<240))
      {
        fill(255,0,0);
        circle(180,230,20);
        fill(233,219,165);
        circle(180,260,25);
        circle(180,290,25);
        circle(180,320,25);
        circle(180,350,25);
        circle(180,380,25);
        circle(180,260,25);

        R=0;G=0;B=0;
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>250)&&(mouseY<270))
      {
        fill(255,0,0);
        circle(180,260,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,290,25);
        circle(180,320,25);
        circle(180,350,25);
        circle(180,380,25);
        circle(180,410,25);

        R=120;G=120;B=120;
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>280)&&(mouseY<300))
      {
        fill(255,0,0);
        circle(180,290,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,260,25);
        circle(180,320,25);
        circle(180,350,25);
        circle(180,380,25);
        circle(180,410,25);

        R=255;G=255;B=255;
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>310)&&(mouseY<330))
      {
        fill(255,0,0);
        circle(180,320,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,260,25);
        circle(180,290,25);
        circle(180,350,25);
        circle(180,380,25);
        circle(180,410,25);

        R=239;G=164;B=0;
      }    

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>340)&&(mouseY<360))
      {
        fill(255,0,0);
        circle(180,350,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,260,25);
        circle(180,290,25);
        circle(180,320,25);
        circle(180,380,25);
        circle(180,410,25);

        R=50;G=80;B=46;
      }  

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>370)&&(mouseY<390))
      {
        fill(255,0,0);
        circle(180,380,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,260,25);
        circle(180,290,25);
        circle(180,320,25);
        circle(180,350,25);
        circle(180,410,25);

        R=57;G=162;B=135;
      } 

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>400)&&(mouseY<420))
      {
        fill(255,0,0);
        circle(180,410,20);
        fill(233,219,165);
        circle(180,230,25);
        circle(180,260,25);
        circle(180,290,25);
        circle(180,320,25);
        circle(180,350,25);
        circle(180,380,25);

        R=254;G=92;B=88;
      } 

      //set line weight
      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>500)&&(mouseY<520))
      {
        strokeWeight(2);
        fill(255,0,0);
        circle(180,510,20);
        fill(233,219,165);
        circle(180,540,25);
        circle(180,570,25);
        circle(180,600,25);
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>530)&&(mouseY<550))
      {
        strokeWeight(5);
        fill(255,0,0);
        circle(180,540,20);
        fill(233,219,165);
        circle(180,510,25);
        circle(180,570,25);
        circle(180,600,25);
      }

      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>560)&&(mouseY<580))
      {
        strokeWeight(10);
        fill(255,0,0);
        circle(180,570,20);
        fill(233,219,165);
        circle(180,510,25);
        circle(180,540,25);
        circle(180,600,25);
      }
      
      else if ((mouseX>40)&&(mouseX<140)&&(mouseY>590)&&(mouseY<610))
      {
        strokeWeight(20);
        fill(255,0,0);
        circle(180,600,20);
        fill(233,219,165);
        circle(180,510,25);
        circle(180,540,25);
        circle(180,570,25);
      }

      else if ((mouseX>80)&&(mouseX<195)&&(mouseY>900)&&(mouseY<970))
      {
        fill(255);
        rect(300,10,1600,1060);
        fill(255,0,0);
        circle(180,140,20);
        fill(233,219,165);
        circle(180,80,25);
        circle(180,110,25);
      }
      
      stroke(R,G,B);
    }
  }
}