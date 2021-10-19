//Ye Yangtao SJTU F1803407 518021910952
//https://github.com/freedomyyt

boolean flag = true;
int last_x = 0;
int last_y = 0;

void setup(){
    //Draw Background
    size(720,720);
    background(227,206,160);
    //Draw Table
    noStroke();
    fill(208,175,147);
    rect(10,10,700,700);
    //Draw Matrix
    stroke(0,0,0);
    for (int y=24;y<=696;y+=48)
        line(24,y,696,y);
    for (int x=24;x<=696;x+=48)
        line(x,24,x,696);
}

void draw(){
    delay(30);//Time initerval between two mousepression: 30ms
    if((mousePressed) && !(((last_x-24) <= mouseX) && ((last_x+24) >= mouseX) && ((last_y-24) <= mouseY) && ((last_y+24) >= mouseY))) //can't place chessman in the same place
    {
        //Place chessman in single checker
        if(flag)
        {
            fill(0);
            flag = false;
            ellipse(floor((mouseX-24)/48)*48+48, floor((mouseY-24)/48)*48+48, 40, 40);
            last_x = floor((mouseX-24)/48)*48+48;
            last_y = floor((mouseY-24)/48)*48+48;
        }
        else
        {
            fill(255);
            flag = true;
            ellipse(floor((mouseX-24)/48)*48+48, floor((mouseY-24)/48)*48+48, 40, 40);
            last_x = floor((mouseX-24)/48)*48+48;
            last_y = floor((mouseY-24)/48)*48+48;
        }
    }
}
