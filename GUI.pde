class GUI {
  private ArrayList<ArrayList<Slider>> sliders;
  private color fill;
  private PVector pos, size;
  int currentFrame;
  int numFrames;
  
  GUI(float x, float y, float w, float h, int frames, color f) {
    pos = new PVector(x,y);
    size = new PVector(w,h);
    fill = f;
    numFrames = frames;
    currentFrame = 0;
    sliders = new ArrayList<ArrayList<Slider>>();
    for (int i = 0; i < frames; i++) {
      sliders.add(new ArrayList<Slider>());
    }
  }
  
  void addSlider(Slider s,int frame) {
    sliders.get(frame).add(new Slider(s));
  }
  
  public void show() {
    for (int i = 0; i < sliders.get(currentFrame).size(); i++) {
      sliders.get(currentFrame).get(i).show();
    }
  }
  
  public void update() {
    for (int i = 0; i < sliders.get(currentFrame).size(); i++) {
      sliders.get(currentFrame).get(i).update();
    }
  }
  
  public float getSliderValue(int index) {
    return sliders.get(currentFrame).get(index).getSliderValue();
  }
  
  public float getSliderValue(int index, int frame) {
    return sliders.get(frame).get(index).getSliderValue();
  }
  
  public int getCurrentFrame() {
    return currentFrame;
  }
}
