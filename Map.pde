import java.util.*;  

class Flat_Map {
  PImage mapImage;
  PVector pos;
  PVector size;
  int noiseOctaves;
  float zoom;
  int seed;
  float waterLevel;
  float [][] heightMap;
  float [][] waterMap;
  float[] phi;
  PVector offset;
  Map<Integer, Float> sig;
  float lacunarity;
  NoiseGenerator heightGenerator;
  NoiseGenerator waterGenerator;
  float stretch;

  /*=============================================================
   ===============================================================
   INTITIALIZING
   ===============================================================
   =============================================================*/

  Flat_Map(float x, float y, int w, int h, int s, float z, int res) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    mapImage = createImage(w, h, RGB);
    noiseOctaves = res;
    zoom = z;
    seed = s;
    waterLevel = 0.5;
    heightMap = new float[w][h];
    waterMap = new float[w][h];
    sig = new HashMap<Integer, Float>();
    heightGenerator = new NoiseGenerator(w, h, z, s);
    waterGenerator = new NoiseGenerator(w, h, z*4, s+1);
    stretch = 20;
  }

  void generatePixels() {
    int index = 0;
    float black = 200;
    float val;
    PVector[][] wire = waterGenerator.sphereFrame.wireFrame;
    color c;
    noiseDetail(noiseOctaves, lacunarity);
    noiseSeed(seed);

    mapImage.loadPixels();
    for (int y = 0; y < size.y; y++) {
      for (int x = 0; x < size.x; x++) {
        index = int (x+y*size.x);

        waterGenerator.getSigmoidNoise(x, y, stretch, waterLevel);
        heightMap[x][y] = waterGenerator.noiseMap[x][y];
        val = heightMap[x][y];
        if (invertWater) {
          val = 1-val;
        } 
        if (val < 0.5) {
          mapImage.pixels[index] = color(0, 0, 50+300*val/2);
        } else {
          mapImage.pixels[index] = color(val*250);
        }
        if (wire[x][y].x < 0.3 || wire[x][y].y < 0.3) {
          c = mapImage.pixels[index];
          mapImage.pixels[index] = color(red(c)-255+black, green(c)-255+black, blue(c)-255+black);
        }
      }
    }
    mapImage.updatePixels();
  }

  void show() {
    image(mapImage, pos.x, pos.y, size.x*scale, size.y*scale);

    noStroke();
    fill(0, 255, 0);
    ellipse(waterGenerator.max.x*scale, waterGenerator.max.y*scale+pos.y, 5*scale, 5*scale);
    fill(255, 0, 0);
    ellipse(waterGenerator.min.x*scale, waterGenerator.min.y*scale+pos.y, 5*scale, 5*scale);
  }

  void setWaterLevel(float c) {
    if (c >= 0 && c <= 1) {
      waterLevel = c;
    }
  }

  void setSeed(int s) {
    seed = s;
    waterGenerator.setSeed(s);
    heightGenerator.setSeed(s);
  }

  void setOctaves(int c) {
    if (c >= 0 && c <= 15) {
      noiseOctaves = c;
    }
  }

  void setLacunarity(float c) {
    if (c >= 0 && c <= 1) {
      lacunarity = c;
    }
  }

  float sigmoid(float input) {
    int key_ = int (input*500);
    if (!sig.containsKey(key_)) {
      sig.put(key_, (float)(1/(1 + Math.exp(((float)(-key_)/500)))));
    }
    return sig.get(key_);
  }

  void setStretch(float s) {
    stretch = s;
  }

  void setOffset(PVector p) {
    waterGenerator.setOffset(p);
  }

  void setZoom(float z) {
    zoom = z;
  }
}
