# TextArt

## 项目内容

语言：Processing

实现：调用Geomerative第三方库，在英文字体的基础上绘制艺术图案

## 主要实现方法

### Geomerative介绍

参考：<https://zhuanlan.zhihu.com/p/43458894#:~:text=8%20%E4%BA%BA%20%E8%B5%9E%E5%90%8C%E4%BA%86%E8%AF%A5%E6%96%87%E7%AB%A0.%20Gemerative%20%E6%98%AF%E4%B8%80%E4%B8%AA%20Processing%20%E5%BA%93%E3%80%82.%20%E5%AE%83%E6%89%A9%E5%B1%95%E4%BA%86%E4%BA%8C%E7%BB%B4%E5%87%A0%E4%BD%95%E6%93%8D%E4%BD%9C%E4%BB%A5%E4%BE%BF%E4%BA%8E%E7%94%9F%E6%88%90%E5%87%A0%E4%BD%95%E5%9B%BE%E5%BD%A2%E3%80%82.,TrueType%20%E5%AD%97%E4%BD%93%E8%A7%A3%E9%87%8A%E5%99%A8%20%E5%92%8C%20SVG%20%E8%A7%A3%E9%87%8A%E5%99%A8%E3%80%82.%20%E8%AF%A5%E5%BA%93%E4%BD%BF%E5%BE%97%E7%9F%A2%E9%87%8F%E7%BB%98%E7%94%BB%E6%88%96%E8%80%85%E5%AD%97%E4%BD%93%E7%9A%84%E5%BD%A2%E7%8A%B6%E6%9B%B4%E5%8A%A0%E6%98%93%E4%BA%8E%E6%93%8D%E6%8E%A7%E3%80%82.%20Geomerative%20%E4%BD%BF%E5%BE%97%E8%B7%AF%E5%BE%84%E3%80%81%E6%89%8B%E6%9F%84%E5%92%8C%E9%94%9A%E7%82%B9%E9%83%BD%E9%9D%9E%E5%B8%B8%E6%98%93%E4%BA%8E%E8%AE%BF%E9%97%AE%EF%BC%8C%E5%8F%AF%E4%BB%A5%E8%BD%BB%E6%9D%BE%E7%94%B1%E5%85%B6%E5%88%B6%E4%BD%9C%E7%94%9F%E6%88%90%E5%AD%97%E4%BD%93%E5%92%8C%E5%87%A0%E4%BD%95%E4%BD%93%E3%80%82.>

Gemerative 是一个 Processing 库。它扩展了二维几何操作以便于生成几何图形。它包含 TrueType 字体解释器 和 SVG 解释器。该库使得矢量绘画或者字体的形状更加易于操控。Geomerative 使得路径、手柄和锚点都非常易于访问，可以轻松由其制作生成字体和几何体。

由以下三个主要部分组成：
```
RShape    //包含带有指令的子图形 (move,lines,beziers,...)
RPolygon   //包含由点组成的轮廓线
RMesh     //包含由顶点组成的条带
```

本库有以下几种用途：

1.通过圆来绘制图形。我们可以通过创建一个新图形再为其添加命令来实现这一点。图形创建之后，我们可以：
- 使用 draw(g) (注意 g 的用法以便将图形绘制在 PGraphics 对象中)
- 使用 toPolygon() 将其转换成多边形

- 访问它的子图形的命令，或这些命令的节点，附属子图形以及RSubshpe 方法。

2.通过圆来绘制多边形。我们可以通过创建一个多边形，并为其增加点（addPoint(x,y)）或者轮廓线（addContour()）来实现这一点。多边形创建之后，我们可以：
- 使用 draw(g) 绘制

- 利用 toMesh() 将其转换为一个 mesh

- 访问它轮廓线上的节点，附属轮廓线、和它的RContour 方法。

- 在两个多边形上执行二进制操作，使用 diff()、union()、xor() 和 intersection()方法。

### Geomerative库的安装与调用

- 安装方法一    手动安装（不推荐）

    下载地址：<http://www.ricardmarxer.com/geomerative/>

    ![](https://cdn.jsdelivr.net/gh/freedomyyt/Photos/20211017201647.png)

    在Processing GUI中手动添加
- 安装方法二    自动安装（推荐）

    在Processing GUI的菜单栏中打开：速写本-引用库文件-添加库文件，打开Contribution Manager

    ![](https://raw.githubusercontent.com/freedomyyt/Photos/main/%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE%202021-10-17%20200625.png)

    ![](https://cdn.jsdelivr.net/gh/freedomyyt/Photos/20211017202059.png)

    点击Geomerative | Extends 2D geometry...

    在下方点击Install，等待进度完成即安装成功

    笔者已安装，所以Install按键为灰色

    ![](https://cdn.jsdelivr.net/gh/freedomyyt/Photos/20211017202145.png)
- 调用方法

    Prcessing语言：
    ```Processing
    import geomerative.*;
    ```
    
    Python语言：
    ```Python
    add_library('geomerative')
    ```

### Geomerative库的用法

参考*ricardmarxer*官网：<http://www.ricardmarxer.com/geomerative/documentation/index.html>

- 类

    RClosest
    ```
    This class allows contains information about an evaluation of the closest points or intersections between shapes/paths/commands.
    ```

    RCommand
    ```
    extends RGeomElem
    ```

    RContour
    ```
    RContour is a reduced interface for creating, holding and drawing contours. Contours are ordered lists of points (RPoint) which define the outlines of polygons. Contours can be self-intersecting.
    ```

    RFont
    ```
    RShape is a reduced interface for creating, holding and drawing text from TrueType Font files. It's a basic interpreter of TrueType fonts enabling to access any String in the form of a group of shapes. Enabling us in this way to access their geometry.
    ```

    RG
    ```
    RG is a static class containing all the states, modes, etc..
    ```

    RGeomElem
    ```
    RGeomElem is an interface to any geometric element that can be drawn and transformed, such as shapes, polygons or meshes.
    ```

    RGroup
    ```
    RGroup is a holder for a group of geometric elements that can be drawn and transformed, such as shapes, polygons or meshes.
    ```

    RMatrix
    ```
    RMatrix is a very simple interface for creating, holding 3x3 matrices with the most common 2D affine transformations such as translation, rotation, scaling and shearing.
    ```

    RMesh
    ```
    RMesh is a reduced interface for creating, holding and drawing meshes.
    ```

    RPath
    ```	
    RPath is a reduced interface for creating, holding and drawing contours.
    ```

    RPoint
    ```
    RPoint is a very simple interface for creating, holding and drawing 2D points.
    ```

    RPolygon
    ```
    RPolygon is a reduced interface for creating, holding and drawing complex polygons.
    ```

    RShape
    ```
    RShape is a reduced interface for creating, holding and drawing complex shapes.
    ```

    RStrip
    ```
    RStrip is a reduced interface for creating, holding and drawing triangle strips.
    ```
### 本项目实现关键代码

设定void draw()的运行频率
```Processing
frameRate(3);
```

从tff获取字体数据
```Processing
grp = RG.getText("A", "Conther-2.ttf", 500, CENTER); 
```

获取字体顶点
```Processing
points = grp.getPoints();
```

1~26循环
```Processing
if (flag == 26)
    flag = 1;
else 
    flag = flag+1; 
```

循环获取26个字母的对应字体
```Processing
switch(flag)
{
    case 1: 
        grp = RG.getText("A", "Conther-2.ttf", 500, CENTER);
        break;
    case 2:
        grp = RG.getText("B", "Conther-2.ttf", 500, CENTER);
        break;
    case 3: 

        ······

    case 25: 
        grp = RG.getText("Y", "Conther-2.ttf", 500, CENTER);
        break;
    case 26: 
        grp = RG.getText("Z", "Conther-2.ttf", 500, CENTER);
        break;

    default: 
        grp = RG.getText("A", "Conther-2.ttf", 500, CENTER);
}
```

在字体的顶点绘制色彩随机的圆
```Processing
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
```

## Author
name:freedomyyt 

school:SJTU

    