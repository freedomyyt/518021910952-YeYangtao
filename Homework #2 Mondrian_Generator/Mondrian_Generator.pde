//Ye Yangtao SJTU F1803407 518021910952
//https://github.com/freedomyyt

int Width = 800;
int Height = 800;
int flag = 1;

//fill color: grey
color[] fillcolors = {#ffffff, #f5f5f5, #dcdcdc,#d3d3d3,#c0c0c0,#a9a9a9,#808080,#696969,#000000};

void setup() 
{
  //Draw Background
  size(800,800);
  background(#ffffff);
}

void draw() 
{
    float lineSize = 200;
    float colSize = 300;

    for(int line = 0; line < Height; line += lineSize) 
    {
      lineSize = random(20, Width/3);
      for(int col = 0; col < Width; col += colSize) 
      {
        // Define the color block size  
        colSize = random(40, Height/3);

        //choose fill color
        color rectColor = fillcolors[int(random(fillcolors.length))];

        //draw rectangular
        fill(rectColor);
        rect(col, line, colSize, lineSize);

        //Drawing Black lines
        strokeWeight(3);
        stroke(#000000);
        float x = col+colSize;
        float y = line+lineSize;
        line(0, y, Width, y);
        line(x, line, x, y);
      }
    }

    //Time initerval between two paintings: 3000ms
    if(flag == 1)
    {
      delay(10);
      flag = 0;
    }
    else {
      delay(3000);
    }
}
