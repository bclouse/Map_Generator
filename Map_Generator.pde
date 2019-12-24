Flat_Map m;
int noiseSeed;
int iterations;
ArrayList<Slider> sliders;
float stretch;
int zoom;
PVector offset;
int scale = 1;
float Radius;
int RING_NUM;
boolean hasBeenUpdated;
long current;
long elapsed;

void setup() {
  size(2000, 1000);
  scale = width/1000;
  RING_NUM = 10;
  noiseSeed = 1;
  iterations = 1;
  Radius = 2;
  offset = new PVector(0, 0, 0);
  sliders = new ArrayList<Slider>();
  sliders.add(new Slider(1, 15, 11, new PVector(750*scale, 50*scale), new PVector(400*scale, 30*scale), 15*scale, true, "Octaves"));
  sliders.add(new Slider(0.3, 0.7, .55, new PVector(750*scale, 100*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Lacunarity"));
  sliders.add(new Slider(0, 1, .5, new PVector(750*scale, 150*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Water"));
  sliders.add(new Slider(0, 50, 20, new PVector(750*scale, 200*scale), new PVector(400*scale, 30*scale), 15*scale, true, "Sigmoid Stretch"));
  sliders.add(new Slider(0, 5, Radius, new PVector(750*scale, 250*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Zoom"));
  sliders.add(new Slider(180, -180, -offset.x, new PVector(750*scale, 300*scale), new PVector(400*scale, 30*scale), 15*scale, true, "CW/CCW"));
  sliders.add(new Slider(-90, 90, offset.y, new PVector(750*scale, 350*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Rotate U/D"));
  sliders.add(new Slider(0, 360, -offset.z, new PVector(750*scale, 400*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Slide L/R"));
  m = new Flat_Map(0*scale, 125*scale, 500, 250, noiseSeed, 10, 4, 2);
  m.setOffset(offset);
  m.setOctaves((int)sliders.get(0).getSliderValue());
  m.setLacunarity(sliders.get(1).getSliderValue());
  m.setWaterLevel(sliders.get(2).getSliderValue());
  m.stretch = sliders.get(3).getSliderValue();
  m.setZoom(sliders.get(4).getSliderValue());
  
  m.generateMap();
  m.generatePixels();
  //sliders.get(6).lock();
  //sliders.get(7).lock();
}

void draw() {
  background(0);
  for (int i = 0; i < sliders.size(); i++) {
    sliders.get(i).update();
    sliders.get(i).show();
  }

  if (sliders.get(0).getSliderValue() != m.noiseOctaves) {
    m.setOctaves((int)sliders.get(0).getSliderValue());
  }
  if (sliders.get(1).getSliderValue() != m.lacunarity) {
    m.setLacunarity(sliders.get(1).getSliderValue());
  }
  if (sliders.get(2).getSliderValue() != m.waterLevel) {
    m.setWaterLevel(sliders.get(2).getSliderValue());
  }
  if (stretch != sliders.get(3).getSliderValue()) {
    m.stretch = sliders.get(3).getSliderValue();
  }
  if (zoom != sliders.get(4).getSliderValue()) {
    Radius = sliders.get(4).getSliderValue();
    m.setZoom(sliders.get(4).getSliderValue());
  }
  if (sliders.get(5).hasUpdated() || sliders.get(6).hasUpdated()|| sliders.get(7).hasUpdated()) {  //|| offset.y != sliders.get(6).getSliderValue()
    //println("UPDATE");
    offset.set(radians(-sliders.get(5).getSliderValue()), radians(sliders.get(6).getSliderValue()), -radians(sliders.get(7).getSliderValue()));
    m.setOffset(offset);
  }

  hasBeenUpdated = false;
  for (int i = 0; i < sliders.size(); i++) {
    if (sliders.get(i).hasUpdated()) {
      if (!hasBeenUpdated) {
        m.generateMap();
        m.generatePixels();
        hasBeenUpdated = true;
      }
      sliders.get(i).resetUpdate();
    }
  }

  m.show();
}

void keyPressed() {
  switch (keyCode) {
    //case UP: 
    //  break;
    //case DOWN: 
    //  break;
  case LEFT: 
    if (noiseSeed > 0) {
      noiseSeed--;
      m.setSeed(noiseSeed);
      m.generateMap();
      m.generatePixels();
    } 
    break;
  case RIGHT: 
    noiseSeed++; 
    m.setSeed(noiseSeed);
    m.generateMap();
    m.generatePixels();
    break;
  }
  switch (key) {
  case '\n':

    println("Rotations = [ "+offset.x+", "+offset.y+" ]");
    break;
    //case '+': 
    //  //m.changeResolution(1); 
    //  m.changeWaterLevel(0.01); 
    //  break;
    //case '-': 
    //  //m.changeResolution(-1); 
    //  m.changeWaterLevel(-0.01); 
    //  break;
  }
}

void mouseClicked() {
  //if (mouseX >= 0 && mouseX < 500 && mouseY >= 0 && mouseY < 500) {
  //  println("Point ["+mouseX+", "+mouseY+"] has a value of "+m.heightMap[mouseX][mouseY]);
  //}
}

void tic(boolean nano) {
  if (nano) {
    current = System.nanoTime();
  } else {
    current = System.currentTimeMillis();
  }
}

void toc(boolean nano) {
  if (nano) {
    elapsed = System.nanoTime()-current;
    println("Time elapsed: "+elapsed+" ns");
  } else {
    elapsed = System.currentTimeMillis()-current;
    println("Time elapsed: "+elapsed+" ms");
  }
}
