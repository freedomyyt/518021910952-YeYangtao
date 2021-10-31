# [第六次作业：创意编程研究：自组织与涌现性]作业：粒子系统

1. 创建您自己的基于粒子系统的可交互的动态创意作品，并输出为mp4/gif文件。

## 项目内容

语言：Processing

实现：若干个圆点围绕鼠标位置旋转，圆点的旋转半径和颜色在限定范围内随机生成，随着鼠标移动，实现圆点的跟随和暂留效果。

## 运行结果

演示视频：<https://github.com/freedomyyt/518021910952-YeYangtao/blob/main/第六次作业/演示.mp4>

截图：
<div align=center>
    <img src="https://cdn.jsdelivr.net/gh/freedomyyt/Photos/截屏2021-10-31 下午6.47.54.png"/>
</div >

### 核心代码

生成下一次圆点的位置

```Processing
mtheta[i] += dtheta[i]; 
location[i].lerp(mouseX + cos(mtheta[i]) * (rotation_radius[i] + max_rotation_radius), mouseY + sin(mtheta[i]) * (rotation_radius[i] + max_rotation_radius), 0, 0.07);
```

绘制圆点
```Processing
fill(dot_color[i]);
ellipse(location[i].x, location[i].y, dot_radius, dot_radius);
```

暂留效果实现
```Processing
void draw() 
{
  fill(25,25, 25, 25);
  rect(0, 0, width, height);
  
  ······
}
```

## Author

name:freedomyyt 

school:SJTU