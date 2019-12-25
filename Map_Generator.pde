Flat_Map m;
int noiseSeed;
ArrayList<Slider> sliders;
float stretch;
int zoom;
PVector offset;
int scale = 1;
float Radius;
boolean hasBeenUpdated;
long current;
long elapsed;
boolean invertWater;

void setup() {
  size(1000, 500);
  scale = width/1000;
  noiseSeed = 1;
  offset = new PVector(0, 0, 0);    //initial globe rotations
  sliders = new ArrayList<Slider>();
  sliders.add(new Slider(1, 15, 4, new PVector(750*scale, 50*scale), new PVector(400*scale, 30*scale), 15*scale, true, "Octaves"));                  //Adjusts the number of octaves in the noise function
  sliders.add(new Slider(0.3, 0.7, .55, new PVector(750*scale, 100*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Lacunarity"));        //Lacunarity is how much each octave affects the overall output of the 
  sliders.add(new Slider(0, 1, .5, new PVector(750*scale, 150*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Water"));                  //Sets the height of the water
  sliders.add(new Slider(0, 50, 20, new PVector(750*scale, 200*scale), new PVector(400*scale, 30*scale), 15*scale, true, "Sigmoid Stretch"));        //Determines how quickly the sigmoid values go to 0 or 1
  sliders.add(new Slider(0, 5, 2, new PVector(750*scale, 250*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Hill Index"));              //The higher the value, the more the noise function oscillates from high to low
  sliders.add(new Slider(180, -180, -offset.x, new PVector(750*scale, 300*scale), new PVector(400*scale, 30*scale), 15*scale, true, "CW/CCW"));      //Spins the map clockwise/counter-clockwise around the poles
  sliders.add(new Slider(-90, 90, offset.y, new PVector(750*scale, 350*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Rotate U/D"));    //Rotates the map such that the poles become more visible
  sliders.add(new Slider(0, 360, -offset.z, new PVector(750*scale, 400*scale), new PVector(400*scale, 30*scale), 15*scale, false, "Slide L/R"));     //Slides the finished map left and right
  
  //Initializes all of the map values before generating the first map
  Radius = sliders.get(4).getSliderValue();
  
  m = new Flat_Map(0*scale, 125*scale, 500, 250, noiseSeed, 10, 4);
  m.setOffset(offset);
  m.setOctaves((int)sliders.get(0).getSliderValue());
  m.setLacunarity(sliders.get(1).getSliderValue());
  m.setWaterLevel(sliders.get(2).getSliderValue());
  m.stretch = sliders.get(3).getSliderValue();
  m.setZoom(Radius);
  invertWater = false;
  
  //Generates the map
  m.generatePixels();
}

void draw() {
  background(0);
  
  //Updates and draws all of the sliders
  for (int i = 0; i < sliders.size(); i++) {
    sliders.get(i).update();
    sliders.get(i).show();
  }

  //Updates all of the map values if the corresponding slider value has been updated
  if (sliders.get(0).hasUpdated()) {
    m.setOctaves((int)sliders.get(0).getSliderValue());
  }
  if (sliders.get(1).hasUpdated()) {
    m.setLacunarity(sliders.get(1).getSliderValue());
  }
  if (sliders.get(2).hasUpdated()) {
    m.setWaterLevel(sliders.get(2).getSliderValue());
  }
  if (sliders.get(3).hasUpdated()) {
    m.stretch = sliders.get(3).getSliderValue();
  }
  if (sliders.get(4).hasUpdated()) {
    Radius = sliders.get(4).getSliderValue();
    m.setZoom(sliders.get(4).getSliderValue());
    m.waterGenerator.sphereFrame.updateUnitFrame();
    //println(Radius);
  }
  if (sliders.get(5).hasUpdated() || sliders.get(6).hasUpdated()|| sliders.get(7).hasUpdated()) {
    //println("UPDATE");
    offset.set(radians(-sliders.get(5).getSliderValue()), radians(sliders.get(6).getSliderValue()), -radians(sliders.get(7).getSliderValue()));
    m.setOffset(offset);
  }
  
  
  //Generates the new map image only if the sliders have been updated.
  hasBeenUpdated = false;
  for (int i = 0; i < sliders.size(); i++) {
    if (sliders.get(i).hasUpdated()) {
      if (!hasBeenUpdated) {
        
        m.generatePixels();
        hasBeenUpdated = true;
      }
      sliders.get(i).resetUpdate();
    }
  }
  
  //Always shows the map
  m.show();
}


/*
  Updates other information if certain keys are pressed
  LEFT and RIGHT change the seed
  SPACE invertes the wate and land values
*/
void keyPressed() {
  switch (keyCode) {
  case LEFT: 
    if (noiseSeed > 0) {
      noiseSeed--;
      m.setSeed(noiseSeed);
      
      m.generatePixels();
    } 
    break;
  case RIGHT: 
    noiseSeed++; 
    m.setSeed(noiseSeed);
    
    m.generatePixels();
    break;
  }
  switch (key) {
    case ' ':
    invertWater = !invertWater;
    m.generatePixels();
    break;
  }
}


//Prints the height value of the point that is clicked on the map
void mouseClicked() {
  if (mouseX >= m.pos.x*scale && mouseX < m.pos.x*scale+m.size.x*scale && mouseY >= m.pos.y*scale && mouseY < m.pos.y*scale+m.size.y*scale) {
    float x = (mouseX-m.pos.x*scale)/scale;
    float y = (mouseY-m.pos.y*scale)/scale;
    
    println("Point ["+x+", "+y+"] has a value of "+m.heightMap[(int)x][(int)y]);
  }
}


//tic toc functions used to calculate time elapsed between two lines of code.
//"tic" is called to start the clock and "toc" is called to print the value of the clock

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
