# [第九次作业：大作业｜自拟课程设计项目]设计工具软件开发

- 基于本课程所涉及到的内容和自己的兴趣发起一个自拟软件开发项目，该项目的总体目标为创建一个具有特定功能且相对完整、支持基本人机交互的设计工具。

## 项目内容

语言：Python

实现：一个绘图软件，可提取用户给定图片中的主要色彩成分，以此作为绘图调色盘，用户可选择画笔颜色和笔迹粗细，实现对优秀艺术作品配色的提取、借鉴和再创作。

功能清单：

- 十六进制画笔颜色输入

- 颜色名称画笔颜色输入

- 根据用户提供的文件路径索引图片，提取图片的主题颜色作为可选的画笔颜色

- 色板选择任意画笔颜色

- 画笔宽度选取

- 橡皮擦功能

- 一键清除画布功能


## 几种色彩提取算法：

### kmeans聚类算法

步骤：

1. 首先随机确定 n 个初始点, 作为第0阶段的主色色盘(当然这个主色和真实主色相差了很多), 这 n 个点称为 n 个质心

    ```TypeScript
    let startCenters: PixelData[] = new Array(mainColorNumber)
    .fill(0)
    .map(() => {
        return new Array(3)
        .fill(0)
        .map(() => ~~(Math.random() * 255)) as PixelData;
    });
    ```

2. 根据现有质心的位置对原图像的所有像素进行归类, 离哪个质心最近就设置为哪一类

3. 根据聚类结果, 算出该类别新的质心(该类所有 r、g、b分别求平均值, 得到的点即为新质心)

4. 根据算出来的质心, 更新startPoints数组

5. 重复步骤, 直至收敛(每个质心迭代后改变的距离均小于minDist)或达到最大迭代次数iterations

- 计算距离的方法: 将 r,g,b 分别作为空间坐标系的 x,y,z, 计算两点的欧式距离即可

核心代码：

```TypeScript
while (iterations--) {
  /***** 归类 *****/
  center2Cluster = center2Cluster.map(() => []);
  data.forEach((pixel) => {
    // 对每个像素计算距离哪个质心最近
    const closestCenterIndex = startCenters.reduce(
      (prev, curCenter, centerIndex) => {
        const dist = calcDist(curCenter, pixel);
        return dist < prev.dist ? { centerIndex, dist } : prev;
      },
      { centerIndex: -1, dist: Infinity } // 当前距离最近的中心的号码和距离
    ).centerIndex;
    // 将它加入最近的质心的数组中
    center2Cluster[closestCenterIndex].push(pixel);
  });

  /***** 计算新质心 *****/
  const newStartCenters = center2Cluster.map(
    // 对于每一个中心的集合
    (cluster) =>
      cluster
        .reduce(
          // 分别求该集合中各个点 r, g, b 各通道之和
          (total, pixel) => [
            total[0] + pixel[0],
            total[1] + pixel[1],
            total[2] + pixel[2],
          ],
          [0, 0, 0] as PixelData
        )
        .map(
          // 将结果取平均即为新中心
          (totalChannel) => ~~(totalChannel / cluster.length)
        ) as PixelData
  );

  /***** 判断是否收敛 *****/
  let isSettled = true;
  for (let i = 0; i < mainColorNumber; i++) {
    const moveDist = calcDist(
      newStartCenters[i],
      startCenters[i]
    );
    if (moveDist > minMoveDist) {
      isSettled = false;
      break;
    }
  }
  if (isSettled) break;

  /***** 更新 *****/
  startCenters = newStartCenters;
}
```

### 中位切分算法

1. 将图片每个像素的 r,g,b 值分别作为 x,y,z 坐标, 标在空间坐标系中

2. 用一个最小的立方体框住所有点

3. 将立方体沿一平面切分, 该平面与立方体最长边方向垂直, 使切分得的两部分包含相同数量的像素点

4. 将分得的小立方体递归地按照 3. 的算法切分, 直至分得立方体个数等于所需颜色数即可

5. 将每个立方体中颜色做平均, 即得到最后的主色

- 其中, 在进行切分时可对待切割立方体做一个排序, 其中单位体积包含像素点越多的立方体越先被切割, 以提高效率

核心代码：

```TypeScript
interface ToCut {
  data: PixelData[]; // 待切分数据
  density: number; // 每单位体积包含的像素点数量
}

/** 计算所给的 data 数组包含的像素点应切分成哪两段 */
function cutIntoTwo(data: PixelData[]): [ToCut, ToCut] {
  // 找到最小的框
  let minNMax = [
    Infinity, // rMin
    -Infinity, // rMax
    Infinity, // gMin
    -Infinity, // gMax
    Infinity, // bMin
    -Infinity, // bMax
  ];
  data.forEach((pixel) => {
    for (let i = 0; i < 3; i++) {
      minNMax[i] = Math.min(minNMax[i], pixel[i]);
      minNMax[i + 1] = Math.max(minNMax[i], pixel[i]);
    }
  });

  // 找到最长边, 以此判断根据 r or g or b 来切分
  let cutBy = -1,
    maxEdge = -Infinity;
  for (let i = 0; i < 3; i++) {
    const curEdge = minNMax[i + 1] - minNMax[i];
    if (curEdge > maxEdge) {
      maxEdge = curEdge;
      cutBy = i;
    }
  }

  const halfNum = ~~(data.length / 2);
  // 按照 toCut 排序, 前一半放一边, 后一半放一边
  const sortedData = [...data].sort((a, b) => a[cutBy] - b[cutBy]);

  const toCutLeft: ToCut = {
      data: sortedData.slice(0, halfNum),
      density: 0,
    },
    toCutRight: ToCut = {
      data: sortedData.slice(halfNum),
      density: 0,
    };
  let vLeft = 1,
    vRight = 1;
  for (let i = 0; i < 3; i++) {
    if (i === cutBy) {
      vLeft *= sortedData[halfNum][cutBy] - minNMax[i]; // 中位数 - min
      vRight *= minNMax[i + 1] - sortedData[halfNum][cutBy]; // max - 中位数
    } else {
      vLeft *= minNMax[i + 1] - minNMax[i];
      vRight *= minNMax[i + 1] - minNMax[i];
    }
  }
  toCutLeft.density = toCutLeft.data.length / (vLeft || 0.0001);
  toCutRight.density = toCutRight.data.length / (vRight || 0.0001);

  return [toCutLeft, toCutRight];
}
```

### 八叉树算法

用一颗八叉树来存储每个像素点的信息, 边存边对相似的颜色进行聚类(即进行剪枝)

将每个点的 RGB 表示为二进制的一行, 堆叠后将每一列的不同编码对应成数字, 共 8 种组合    RGB 通道逐列黏合之后的值就是其在某一层节点的子节点

e.g. 如#FF7800，其中 R 通道为0xFF，也就是255，G 为 0x78 也就是120，B 为 0x00 也就是0。 

接下来我们把它们写成二进制逐行放下，那么就是:

R: 1111 1111

G: 0111 1000

B: 0000 0000

上述颜色的第一位黏合起来是100(2)，转化为十进制就是 4，所以这个颜色在第一层是放在根节点的第5个子节点当中

第二位是 110(2) 也就是 6，那么它就是根节点的第5个儿子的第7个儿子

1. 建立一棵空八叉树, 设置一个叶子节点个数上限 依次将像素按上述算法插入树中

2. 若插入后叶子节点数小于上限, 则什么也不做

3. 若大于上限, 则对最底层的一个非叶子节点的子节点进行合并, 将其转换为叶子节点 rgb 值的平均数, 并清除其子节点

4. 依此类推, 直到最后插入所有的像素, 所得八叉树的叶子节点即为主色调

- 该算法的核心在于, 具有兄弟关系的子节点的 rgb 每位最多都只相差 1, 即这些颜色非常接近, 所以合并后可以用更少的主色代替这几个像素的颜色

核心代码：

```JavaScript
import { getDataList, mainColorNumber, PixelData, rgb2Hex } from "./shared.ts";

/** 原始数据集, 保存了4个 ImgPixels 数组*/
const dataList = await getDataList();

class Node {
  static leafNum = 0;
  static toReduce: Node[][] = new Array(8).fill(0).map(() => []);

  children: (Node | null)[] = new Array(8).fill(null);
  isLeaf = false;
  r = 0;
  g = 0;
  b = 0;
  childrenCount = 0;

  constructor(info?: { index: number; level: number }) {
    if (!info) return;
    if (info.level === 7) {
      this.isLeaf = true;
      Node.leafNum++;
    } else {
      Node.toReduce[info.level].push(this);
      Node.toReduce[info.level].sort(
        (a, b) => a.childrenCount - b.childrenCount
      );
    }
  }

  addColor(color: PixelData, level: number) {
    if (this.isLeaf) {
      this.childrenCount++;
      this.r += color[0];
      this.g += color[1];
      this.b += color[2];
    } else {
      let str = "";
      const r = color[0].toString(2).padStart(8, "0");
      const g = color[1].toString(2).padStart(8, "0");
      const b = color[2].toString(2).padStart(8, "0");

      str += r[level];
      str += g[level];
      str += b[level];
      const index = parseInt(str, 2);

      if (this.children[index] === null) {
        this.children[index] = new Node({
          index,
          level: level + 1,
        });
      }
      (this.children[index] as Node).addColor(color, level + 1);
    }
  }
}
function reduceTree() {
  // find the deepest level of node
  let lv = 6;

  while (lv >= 0 && Node.toReduce[lv].length === 0) lv--;
  if (lv < 0) return;

  const node = Node.toReduce[lv].pop() as Node;

  // merge children
  node.isLeaf = true;
  node.r = 0;
  node.g = 0;
  node.b = 0;
  node.childrenCount = 0;
  for (let i = 0; i < 8; i++) {
    if (node.children[i] === null) continue;
    const child = node.children[i] as Node;
    node.r += child.r;
    node.g += child.g;
    node.b += child.b;
    node.childrenCount += child.childrenCount;
    Node.leafNum--;
  }

  Node.leafNum++;
}

function colorsStats(node: Node, record: Record<string, number>) {
  if (node.isLeaf) {
    const r = (~~(node.r / node.childrenCount))
      .toString(16)
      .padStart(2, "0");
    const g = (~~(node.g / node.childrenCount))
      .toString(16)
      .padStart(2, "0");
    const b = (~~(node.b / node.childrenCount))
      .toString(16)
      .padStart(2, "0");

    const color = "#" + r + g + b;
    if (record[color]) record[color] += node.childrenCount;
    else record[color] = node.childrenCount;

    return;
  }

  for (let i = 0; i < 8; i++) {
    if (node.children[i] !== null) {
      colorsStats(node.children[i] as Node, record);
    }
  }
}

dataList.forEach((data, index) => {
  console.log(`\n*** processing img ${index + 1} ***\n`);
  const root = new Node();

  Node.toReduce = new Array(8).fill(0).map(() => []);
  Node.leafNum = 0;

  data.forEach((pixel, index) => {
    root.addColor(pixel, 0);

    while (Node.leafNum > 16) reduceTree();
  });

  const record: Record<string, number> = {};
  colorsStats(root, record);
  const result = Object.entries(record)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 4);

  console.log(result.map(([color, _]) => color));
});
```

### 算法比较

#### 三种算法提取结果(基于参考作者的TypeScript代码)：

从左到右四列分别为原图，kmeans聚类结果，中位切分结果，八叉树划分结果

<div align=center>
    <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211114010738.png"/>
</div>

## 软件实现

Processing IDE即使使用了Python模式也不可以随意import库，存在诸多限制，考虑到软件实现的自由度，放弃Processing IDE，采用作者习惯的Vscode+Python Extension这一开发模式,并使用PyInstaller这一工具打包为exe可执行文件。

### 主题色彩提取算法

#### 三种算法运行结果(基于Python代码)：

使用python实现了KMeans聚类(KMeans)、中位切分(MMCQ)、八叉树(OQ)三种算法，对四张单张大小约为2MB的图片运行该主题色彩提取代码，结果如下图所示：

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/Comparison.png"/>
</div>

#### 三种算法运行时间：

四张图片提取总时间：

KMeans Time cost: 950.59375

MMCQ Time cost: 32.609375

OQ Time cost: 242.078125

#### 方案选择

综合提取效果和运行时间，选择中位切分算法(MMCQ)

### 绘图界面

使用tk画板实现人机交互和绘图界面,通过画布、输入框、按钮控件实现图片主题色提取、笔迹选择、调色板和绘制等人机交互功能。

```Python
from tkinter import *
from tkinter.colorchooser import *
```

#### 基础框架

```Python
tk = Tk()
tk.title("Canvas Paint 1.1.3")
···
tk.mainloop()
```

#### Tkinter 框架（Frame）控件在屏幕上显示一个矩形区域，用来作为容器

```Python
cce = Frame(tk, relief=SUNKEN)
```

#### 已选颜色展示框

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121195527.png"/>
</div>

```Python
#已选颜色展示
tmplb1 = Label(cco, text="展示:")
showLab = Label(cco, width=15, relief=GROOVE, bg="white")
tmplb1.pack(side=LEFT)
showLab.pack(padx=10, side=LEFT)\
```

#### 颜色输入组件

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121195806.png"/>
</div>

```Python
# 颜色输入
tmplb2 = Label(cco, text="颜色选择 可输入[#十六进制][颜色名][文件路径(不含中文,不含\"符号)]")
tmplb2.pack(side=LEFT)
getc = Entry(cco, width=60)
getc.pack(side=LEFT)
```

```Python
# 颜色确认
cokbtn = Button(cco, text="颜色确认", command=color_sure)
getc.bind("<Return>", color_sure_fun)
cokbtn.pack(side=LEFT, ipadx=3, ipady=3)
```

```Python
# 路径确认
cokbtn = Button(cco, text="路径确认", command=path_sure)
getc.bind("<Return>", path_sure_fun)
cokbtn.pack(side=LEFT, ipadx=3, ipady=3)
```

有三种颜色输入方法：

1. 六位十六进制，如#f0b951，输入结束后点按"颜色确认"按钮。

2. 颜色名称，如blue，输入结束后点按"颜色确认"按钮。

3. 图片文件路径，输入结束后点按"路径确认"按钮，等待一段时间(2MB的图片约等待7秒钟)。
    
    注意：图片文件为png,jpg格式；尽量不要大于10MB，否则颜色提取时间延长；路径不含中文(cv2限制)；路径不需要加引号""

    路径示例：C:\Users\freedomyyt\Downloads\photos\photo3.png

#### 主题色呈现和选择组件

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121201712.png"/>
</div>

从用户上传路径的图片中提取得到7个主题色彩，呈现在绘图板界面上，供用户观察和选择，点击意向颜色右侧的"选择"按钮即可选中该颜色。

```Python
# 主题色提取(基于MMCQ算法)
#路径确认
def path_sure():
    global choosecolor
    global themes
    path = [getc.get()]
    print(path)

    # color extract begin
    pixDatas = list(map(getPixData, path))
    maxColor = 7
    themes = [testMMCQ(pixDatas, maxColor)]
    #transfer RGB to HEX and use for painting
    choosecolor=RGB_to_Hex(themes[0][0][0])
    print(choosecolor)
    # showLab.config(bg=choosecolor)
    showLab.config(bg=RGB_to_Hex(themes[0][0][0]))
    showLab1.config(bg=RGB_to_Hex(themes[0][0][0]))
    showLab2.config(bg=RGB_to_Hex(themes[0][0][1]))
    showLab3.config(bg=RGB_to_Hex(themes[0][0][2]))
    showLab4.config(bg=RGB_to_Hex(themes[0][0][3]))
    showLab5.config(bg=RGB_to_Hex(themes[0][0][4]))
    showLab6.config(bg=RGB_to_Hex(themes[0][0][5]))
    showLab7.config(bg=RGB_to_Hex(themes[0][0][6]))
```

```Python
# 主题色呈现
tmplb1 = Label(cce, text="颜色1")
showLab1 = Label(cce, width=15, relief=GROOVE, bg="white")
tmplb1.pack(side=LEFT)
showLab1.pack(padx=10, side=LEFT)

# 主题色选择
cokbtn = Button(cce, text="选择", command=color_1_choose)
getc.bind("<Return>", color_sure_fun)
cokbtn.pack(side=LEFT, ipadx=3, ipady=3)
```

```Python
# 主题色1选取
def color_1_choose():
    global choosecolor
    global themes
    choosecolor=RGB_to_Hex(themes[0][0][0])
    showLab.config(bg=choosecolor)
```

#### 任意颜色选取组件

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121202258.png"/>
</div>

点击"所有色彩"，即可打开取色板，可以选择任意颜色作为画笔颜色。

#### 画笔宽度选择组件

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121200901.png"/>
</div>

```Python
# 画笔宽度选择
Omf = Frame(tk)
Omf.pack()
tmplb3 = Label(Omf, text="选择画笔宽度")
tmplb3.pack(side=LEFT)
sizevar = IntVar()
SizeList = [x for x in range(20, 90, 6)]
showoutput(SizeList)
sizevar.set(SizeList[0])
ShowOption = OptionMenu(Omf, sizevar, *SizeList)
ShowOption.pack(side=LEFT)
```

#### 橡皮组件

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121200919.png"/>
</div>

```Python
eraser = Button(Omf, text="橡皮", relief=RAISED, command=erase)
eraser.pack(side=LEFT, ipadx=20, padx=50)
```

```Python
def erase():
    global dercnt
    global choosecolor
    global tmpcolor
    if dercnt == 0:
        # eraser.config(relief=RAISED)
        eraser.config(relief=FLAT)
        tmpcolor = choosecolor
        choosecolor = "#F0F0F0"
        dercnt += 1
    else:
        # eraser.config(relief=FLAT)
        eraser.config(relief=RAISED)
        choosecolor = tmpcolor
        dercnt -= 1
```

橡皮功能也可以在"画笔宽度"处选择橡皮宽度，"橡皮"按钮按下和释放时有不同界面，方便用户区分当前是否处于橡皮状态。

按下状态：

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121202808.png"/>
</div>

#### 一键清除功能

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121202905.png"/>
</div>

```Python
btn = Button(tk, text="清除所有", command=cls)
btn.pack(pady=5)
```

```Python
def cls():
    global choosecolor
    getc.delete(0, END)
    showLab.config(bg="white")
    showLab1.config(bg="white")
    showLab2.config(bg="white")
    showLab3.config(bg="white")
    showLab4.config(bg="white")
    showLab5.config(bg="white")
    showLab6.config(bg="white")
    showLab7.config(bg="white")
    choosecolor = "black"
    canvas.delete("all")
```

在画板底部，点按后画布内容，画笔颜色等信息都将被清空。

## 运行结果

提供打包好的可执行程序上手体验：<https://github.com/freedomyyt/518021910952-YeYangtao/tree/main/%E7%AC%AC%E4%B9%9D%E6%AC%A1%E4%BD%9C%E4%B8%9A/Novel_Sketchpad>

双击Novel_Sketchpad.exe文件即可运行

### Novel_Sketchpad界面

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121203231.png"/>
</div>

### 主题色由图片提取：

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/photo3.png"/>
</div>

### 选择任意颜色

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121203546.png"/>
</div>

### 橡皮功能

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121203650.png"/>
</div>

### 不同粗细画笔

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121203814.png"/>
</div>

### 一键清除功能

<div align=center>
  <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211121203942.png"/>
</div>

## Author

name:freedomyyt 

school:SJTU
