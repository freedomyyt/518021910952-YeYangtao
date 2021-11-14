# [第九次作业：大作业｜自拟课程设计项目]设计工具软件开发

- 基于本课程所涉及到的内容和自己的兴趣发起一个自拟软件开发项目，该项目的总体目标为创建一个具有特定功能且相对完整、支持基本人机交互的设计工具。

## 项目内容

语言：Processing

实现：一个绘图软件，可提取用户给定图片中的主要色彩成分，以此作为绘图调色盘，用户可选择画笔颜色和笔迹粗细，实现对优秀艺术作品配色的提取、借鉴和再创作。

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

三种算法计算后结果,从左到右四列分别为原图，kmeans聚类结果，中位切分结果，八叉树划分结果

<div align=center>
    <img src="https://raw.githubusercontent.com/freedomyyt/Photos/main/20211114010738.png"/>
</div>

## 软件实现

## 运行结果

## Author

name:freedomyyt 

school:SJTU
