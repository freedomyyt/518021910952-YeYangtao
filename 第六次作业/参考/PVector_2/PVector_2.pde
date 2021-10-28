PVector location;
PVector velocity;
PVector gravity;

void setup()
{
    size(640,360);
    location = new PVector(100, 100);
    velocity = new PVector(1.2, 2.1);
    gravity = new PVector(0, 0.2);
}

void draw()
{
    background(0);
    location.add(velocity);
    velocity.add(gravity);
    if ((location.x > width) || (location.x < 0))
    {
        velocity.x = velocity.x * -1;
    }
    if (location.y > height) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window 
    velocity.y = velocity.y * -0.95;
    location.y = height;
    }
    // Display circle at location vector
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
}
