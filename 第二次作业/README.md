# Gobang Using Processing
## 项目内容
语言：Processing

实现：可交互的五子棋游戏，黑白两方对弈，交替落子
## 利用的绘图函数
```processing
size()
```
定义显示窗口宽度的尺寸和像素单位的高度

```processing
background()
```
设置用于处理窗口背景的颜色

```processing
noStroke()
```
禁用描边

```processing
strock()
```
设置形状轮廓的颜色

```processing
fill()
```
设置形状填充的颜色

```processing
rect()
```
绘制矩形

```processing
ellipse()
```
绘制椭圆形
## 亮点
```processing
stroke(0,0,0);
for (int y=24;y<=696;y+=48)
    line(24,y,696,y);
for (int x=24;x<=696;x+=48)
    line(x,24,x,696);
```
自动绘制棋盘格
```processing
if((mousePressed) && !(((last_x-24) <= mouseX) && ((last_x+24) >= mouseX) && ((last_y-24) <= mouseY) && ((last_y+24) >= mouseY)))
```
避免连续把棋子放在同一个位置
```processing
ellipse(floor((mouseX-24)/48)*48+48, floor((mouseY-24)/48)*48+48, 40, 40);
```
根据光标位置确定落子位置，把光标坐标在棋盘格上严格映射

## 不足
艺术设计涉及不深(本人典型工科男，审美可能走偏)

时间有限及课程本身取向，未去实现五子棋胜负的判断