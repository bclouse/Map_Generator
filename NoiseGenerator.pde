class NoiseGenerator {
  float[][] noiseMap;
  PVector size;
  float zoom;
  int noiseDetail;
  int seed;
  Map<Integer, Float> sig;
  ArrayList<Float> phiAngles;
  PVector rotations;
  SphereFrame sphereFrame;
  PVector max, mid, min;

  /*=============================================================
   ===============================================================
   INTITIALIZING
   ===============================================================
   =============================================================*/

  NoiseGenerator(float w, float h, float z, int s) {
    size = new PVector(w, h);
    noiseMap = new float[(int) w][(int) h];
    zoom = z;
    noiseDetail = 4;
    seed = s;
    sig = new HashMap<Integer, Float>();
    phiAngles = new ArrayList<Float>();
    rotations = new PVector(0, 0, 0);
    sphereFrame = new SphereFrame(w, h);
    sphereFrame.updateRotation();
    max = new PVector();
    mid = new PVector();
    min = new PVector();

    //println(size);

    resetNoiseMap();
  }

  /*=============================================================
   ===============================================================
   FUNCTIONALITY
   ===============================================================
   =============================================================*/

  void generateNoise(int noiseOctaves, float lac) {
    float lacunarity = 1;

    resetNoiseMap();
    noiseSeed(seed);
    for (int y = 0; y < size.y; y++) {
      for (int x = 0; x < size.x; x++) {
        noiseDetail(noiseOctaves, lac);
        noiseMap[x][y] = noise((float)x/zoom, (float)y/zoom);
      }
    }
  }
  
  void updateSettings(int noiseOctaves, float lac) {
    noiseSeed(seed);
    noiseDetail(noiseOctaves,lac);
  }

  void getSigmoidNoise(int x, int y, float stretch, float waterLevel) {
    PVector positions;// = sphereFrame.getFlatFrame();
    //float zmax = 0;
    //float zmin = 100;
    //float md = 0;

    //noiseSeed(seed);
    //tic(true);
    positions = sphereFrame.updateRotationAt(x, y);
    //tic(true);
    noiseMap[x][y] = sigmoid(((noise(positions.x+10000, positions.y+10000, positions.z+10000)-waterLevel+0.5)*stretch)-(stretch/2));

    //toc(true);
    //if (x == y) {
    //  println("[ "+x+", "+y+" ]");
    //}

    //return noiseMap[x][y];
  }

  void generateSigmoidNoise(int noiseOctaves, float lac, float stretch, float waterLevel) {
    PVector positions;// = sphereFrame.getFlatFrame();
    float zmax = 0;
    float zmin = 100;
    float md = 0;

    resetNoiseMap();
    noiseSeed(seed);

    for (int y = 0; y < size.y; y++) {    //goes through the list of acceptable phi angles (all pixels in the y direction)
      for (int x = 0; x < size.x; x++) {                 //goes through all of the pixels in the x direction
        positions = sphereFrame.updateRotationAt(x, y);
        noiseDetail(noiseOctaves, lac);
        noiseMap[x][y] = sigmoid(((noise(positions.x+10000, positions.y+10000, positions.z+10000)-waterLevel+0.5)*stretch)-(stretch/2));
        if (positions.z > zmax) {
          zmax = positions.z;
          max.set(x, y, 0);
        }
        if (positions.z < zmin) {
          zmin = positions.z;
          min.set(x, y, 0);
        }
        if (positions.x > md) {
          md = positions.x;
          mid.set(x, y, 0);
        }
      }
    }
  }

  void resetNoiseMap() {
    for (int a = 0; a < size.x; a++) {
      for (int b = 0; b < size.y; b++) {
        noiseMap[a][b] = 0;
      }
    }
  }

  /*=============================================================
   ===============================================================
   CALCULATION FUNCTIONS
   ===============================================================
   =============================================================*/

  //SIGMOID FUNCTION:
  float sigmoid(float input) {
    int Key = int (input*500);
    if (!sig.containsKey(Key)) {
      sig.put(Key, (float)(1/(1 + Math.exp(((float)(-Key)/500)))));
    }
    return sig.get(Key);
  }

  /*=============================================================
   ===============================================================
   GET FUNCTIONS
   ===============================================================
   =============================================================*/

  float[][] getNoiseMap() {
    return noiseMap;
  }

  /*=============================================================
   ===============================================================
   SET FUNCTIONS
   ===============================================================
   =============================================================*/

  void setSeed(int s) {
    seed = s;
  }

  void setOffset(PVector p) {
    rotations.set(p.x, p.y, p.z);
    sphereFrame.changeRotation(rotations);
    sphereFrame.updateRotation();
  }
}
