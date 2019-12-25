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

  /*=============================================================
   ===============================================================
   CALCULATIONS
   ===============================================================
   =============================================================*/

  void generatePixels() {
    int index = 0;                                              //Used to convert the x and y coordinates of the map to the pixel index of the PImage
    float black = 175;                                          //How dark the latitude and longitude lines should be
    float val;                                                  //Used to store the current heightMap value
    color c;                                                    //Used to temporarily store the mapImage's pixel color
    
    //An array of values that show how close the latitude and longitude points are to certain multiples
      //ie: if a line needs to be drawn every 30 degrees on the latitude and we are looking at a latitude value of 29.89,
      //    the value will be 0.11. This will be true for 30.11 as well.
    PVector[][] wire = waterGenerator.sphereFrame.wireFrame;    
    
    //Sets the noise settings
    noiseDetail(noiseOctaves, lacunarity);
    noiseSeed(seed);

    //Generates the pixel values by first updating the noiseGenerator and sphereFrame contained within
    mapImage.loadPixels();
    for (int y = 0; y < size.y; y++) {            //Iterate through the y coordinates
      for (int x = 0; x < size.x; x++) {            //Iterate through the x coordinates
        index = int (x+y*size.x);                     //Converts the 2D coordinates to a 1D coordinate

        waterGenerator.getSigmoidNoise(x, y, stretch, waterLevel);  //Updates the noise and sphereFrame at point [x,y]
        heightMap[x][y] = waterGenerator.noiseMap[x][y];            //Stores the heightMap value at point [x,y]
        val = heightMap[x][y];                                      //Stores that into the "val" variable and inverts the value if the "invertWater" variable is true
        if (invertWater) {
          val = 1-val;
        } 
        
        //If the heightMap value is less than 0.5, sets value to a shade of blue for water
        //Otherwise, set it to the heightMap value multiplied by 255
        if (val < 0.5) {
          mapImage.pixels[index] = color(0, 0, 50+300*val/2);
        } else {
          mapImage.pixels[index] = color(val*255);
        }
        
        //Manually darkens the pixel if the wireFrame value is close to the correct latitude and longitude
        if (wire[x][y].x < 0.3 || wire[x][y].y < 0.3) {
          c = mapImage.pixels[index];
          
          //A bug with PImage prevented transparency most of the time and therefor, couldn't be shown on top of the normal mapImage
          //Because of this, the value had to be adjusted manually
          mapImage.pixels[index] = color(red(c)-255+black, green(c)-255+black, blue(c)-255+black);
        }
      }
    }
    mapImage.updatePixels();
  }
  
  /*=============================================================
   ===============================================================
   VISUALS
   ===============================================================
   =============================================================*/
   
  void show() {
    image(mapImage, pos.x, pos.y, size.x*scale, size.y*scale);

    //noStroke();
    //fill(0, 255, 0);
    //ellipse(waterGenerator.max.x*scale, waterGenerator.max.y*scale+pos.y, 5*scale, 5*scale);
    //fill(255, 0, 0);
    //ellipse(waterGenerator.min.x*scale, waterGenerator.min.y*scale+pos.y, 5*scale, 5*scale);
  }

  /*=============================================================
   ===============================================================
   MODIFYING MAP VALUES
   ===============================================================
   =============================================================*/

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
