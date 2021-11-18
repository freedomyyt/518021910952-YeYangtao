from tkinter import *
from tkinter.colorchooser import *
from PIL import Image, ImageDraw, ImageFont


def get_dominant_colors(infile):
    image = Image.open(infile)
    
    # 缩小图片，否则计算机压力太大
    small_image = image.resize((80, 80))
    result = small_image.convert(
        "P", palette=Image.ADAPTIVE, colors=10
    )  
	
	# 10个主要颜色的图像

    # 找到主要的颜色
    palette = result.getpalette()
    color_counts = sorted(result.getcolors(), reverse=True)
    colors = list()

    for i in range(10):
        palette_index = color_counts[i][1]
        dominant_color = palette[palette_index * 3 : palette_index * 3 + 3]
        colors.append(tuple(dominant_color))

    # print(colors)
    return colors

# image_path = r"../example_1.png"
image_path = r"C:\Users\freedomyyt\Desktop\创意编程\第九次作业\Novel_Sketchpad\example_7.png"
color = get_dominant_colors(image_path)
print(color)
