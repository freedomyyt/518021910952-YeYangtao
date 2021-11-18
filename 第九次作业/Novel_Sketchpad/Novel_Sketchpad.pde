// Deadline: Nov 21th
import processing.core.PApplet;
import processing.core.PImage;

// @SuppressWarnings("serial")
// public class ImageViewApplet extends PApplet {

	PImage img;
	float hue;
	static final int hueRange = 360; 
	float saturation;
	float brightness;

	public void setup() {
		size(640,600);
		background(0);
		img = loadImage("example_3.png" /* Your image here */);
		colorMode(HSB, (hueRange - 1));
		extractColorFromImage();
	}

	public void draw() {
		image(img, 0, 0, 640, 480);
		fill(hue, saturation, brightness);
		rect(0, 480, 640, 120);
	}

	private void extractColorFromImage() {
		img.loadPixels();
		int numberOfPixels = img.pixels.length;
		int[] hues = new int[hueRange];
		float[] saturations = new float[hueRange];
		float[] brightnesses = new float[hueRange];

		for (int i = 0; i < numberOfPixels; i++) {
			int pixel = img.pixels[i];
			int hue = Math.round(hue(pixel));
			float saturation = saturation(pixel);
			float brightness = brightness(pixel);
			hues[hue]++;
			saturations[hue] += saturation;
			brightnesses[hue] += brightness;
		}

		// Find the 1st common hue.
		int hueCount_1 = hues[0];
        // Find the 2nd most common hue.
        int hueCount_2 = hues[0];
        // Find the 3rd most common hue.
        int hueCount_3 = hues[0];
        // Find the 4th most common hue.
        int hueCount_4 = hues[0];

		int hue_1 = 0;
        int hue_2 = 0;
        int hue_3 = 0;
        int hue_4 = 0;

		for (int i = 1; i < hues.length; i++) {
 			if (hues[i] > hueCount_1) {
                hueCount_4 = hueCount_3;
                hueCount_3 = hueCount_2;
                hueCount_2 = hueCount_1;
				hueCount_1 = hues[i];
                hue_4 = hue_3;
                hue_3 = hue_2;
                hue_2 = hue_1;
				hue_1 = i;
			}
		}

		// Set the vars for displaying the color.
		this.hue = hue_1;
		saturation = saturations[hue_2] / hueCount_1;
		brightness = brightnesses[hue_2] / hueCount_1;
        this.hue = hue_2;
		saturation = saturations[hue_2] / hueCount_2;
		brightness = brightnesses[hue_2] / hueCount_2;
        this.hue = hue_3;
		saturation = saturations[hue_3] / hueCount_3;
		brightness = brightnesses[hue_3] / hueCount_3;
        // this.hue = hue_4;
		// saturation = saturations[hue_4] / hueCount_4;
		// brightness = brightnesses[hue_4] / hueCount_4;
	}
// }
