# Mondrian_Generator
## 项目内容
语言：Processing

实现：使用黑白色阶生成蒙德里安风格的艺术作品
## 主要的绘图函数
```processing
size()
```
定义显示窗口宽度的尺寸和像素单位的高度

```processing
background()
```
设置用于处理窗口背景的颜色

```processing
strock()
```
设置形状轮廓的颜色

```processing
strokeWeight()
```
设置形状轮廓的线条粗细

```processing
fill()
```
设置形状填充的颜色

```processing
rect()
```
绘制矩形

```processing
line()
```
绘制线条

## 绘图网格生成关键代码
```processing
for(int line = 0; line < Height; line += lineSize) 
{
    lineSize = random(20, Width/3);
    for(int col = 0; col < Width; col += colSize) 
    {
        // Define the color block size  
        colSize = random(40, Height/3);s
```
## 连续绘图
```processing
void draw() 
{
    ······

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
```
每隔3秒重新生成一幅艺术作品。


## Author
name:freedomyyt 

school:SJTU