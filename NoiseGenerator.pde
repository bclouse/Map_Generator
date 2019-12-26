class NoiseGenerator {
  float[][] noiseMap;      //stores all of the noise values for each x and y coordinate of the map
  PVector size;            //Length and width of the map
  float zoom;              //not used right now
  int seed;                //seed for the noise function
  Map<Integer, Float> sig; //Map used to make calculating the sigmoid function quicker
  SphereFrame sphereFrame; //The sphere frame that the noise function will be looking at
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
    seed = s;
    sig = new HashMap<Integer, Float>();
    sphereFrame = new SphereFrame(w, h);
    max = new PVector();
    mid = new PVector();
    min = new PVector();

    //println(size);

    //resetNoiseMap();
  }

  /*=============================================================
   ===============================================================
   NOISE CALCULATIONS
   ===============================================================
   =============================================================*/

//Updates the sphereFrame and value of the noiseMap at location [x,y]
  void getNoise(int x, int y) {
    PVector positions;

    positions = sphereFrame.updateRotationAt(x, y);
    noiseMap[x][y] = noise(positions.x+10000, positions.y+10000, positions.z+10000);
  }

//Updates the sphereFrame and value of the noiseMap at location [x,y] using the sigmoid function
  void getSigmoidNoise(int x, int y, float stretch, float waterLevel) {
    PVector positions;

    positions = sphereFrame.updateRotationAt(x, y);
    noiseMap[x][y] = sigmoid(((noise(positions.x+10000, positions.y+10000, positions.z+10000)-waterLevel+0.5)*stretch)-(stretch/2));
  }

  ////Fills the noiseMap at location 
  //void generateNoise(int noiseOctaves, float lac) {
  //  PVector positions;// = sphereFrame.getFlatFrame();
  //  float zmax = 0;
  //  float zmin = 100;
  //  float md = 0;

  //  noiseSeed(seed);
  //  noiseDetail(noiseOctaves, lac);

  //  for (int y = 0; y < size.y; y++) {    //goes through the list of acceptable phi angles (all pixels in the y direction)
  //    for (int x = 0; x < size.x; x++) {                 //goes through all of the pixels in the x direction
  //      positions = sphereFrame.updateRotationAt(x, y);
  //      noiseMap[x][y] = noise(positions.x+10000, positions.y+10000, positions.z+10000);
  //      if (positions.z > zmax) {
  //        zmax = positions.z;
  //        max.set(x, y, 0);
  //      }
  //      if (positions.z < zmin) {
  //        zmin = positions.z;
  //        min.set(x, y, 0);
  //      }
  //      if (positions.x > md) {
  //        md = positions.x;
  //        mid.set(x, y, 0);
  //      }
  //    }
  //  }
  //}

  //void generateSigmoidNoise(int noiseOctaves, float lac, float stretch, float waterLevel) {
  //  PVector positions;// = sphereFrame.getFlatFrame();
  //  float zmax = 0;
  //  float zmin = 100;
  //  float md = 0;

  //  resetNoiseMap();
  //  noiseSeed(seed);

  //  for (int y = 0; y < size.y; y++) {    //goes through the list of acceptable phi angles (all pixels in the y direction)
  //    for (int x = 0; x < size.x; x++) {                 //goes through all of the pixels in the x direction
  //      positions = sphereFrame.updateRotationAt(x, y);
  //      noiseDetail(noiseOctaves, lac);
  //      noiseMap[x][y] = sigmoid(((noise(positions.x+10000, positions.y+10000, positions.z+10000)-waterLevel+0.5)*stretch)-(stretch/2));
  //      if (positions.z > zmax) {
  //        zmax = positions.z;
  //        max.set(x, y, 0);
  //      }
  //      if (positions.z < zmin) {
  //        zmin = positions.z;
  //        min.set(x, y, 0);
  //      }
  //      if (positions.x > md) {
  //        md = positions.x;
  //        mid.set(x, y, 0);
  //      }
  //    }
  //  }
  //}

  /*=============================================================
   ===============================================================
   CALCULATION FUNCTIONS
   ===============================================================
   =============================================================*/

  //Since the Math.exp() function takes a while to calculate, this function
  //turns the input into a whole number multiple of 0.002
  float sigmoid(float input) {
    int Key = int (input*500);                                        //Divides each whole number into 500 possible numbers and turns it into a whole number Key for the HashMap
    if (!sig.containsKey(Key)) {                                      //if that Key isn't already used
      sig.put(Key, (float)(1/(1 + Math.exp(((float)(-Key)/500)))));     //calculate the value of the sigmoid function and add it to the HashMap
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
    sphereFrame.changeRotation(p);
    sphereFrame.updateRotation();
  }
}
