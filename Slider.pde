class Slider {
  float max, min;
  float val;
  float fullWidth;
  PVector pos;
  PVector size;
  PVector sliderPos;
  boolean mouseHover;
  boolean selected;
  boolean previouslyUnselected;
  boolean snapToInteger;
  float barHeight;
  String label;
  boolean locked;
  boolean hasBeenUpdated;


  Slider (float maximumValue, float minimumValue, float startingValue, PVector p, PVector s, float bh, boolean snapInteger, String l) {
    max = maximumValue;
    min = minimumValue;
    val = startingValue;
    size = new PVector(s.x-s.y*2, s.y);
    pos = new PVector(p.x-s.y/2, p.y);
    fullWidth = s.x;
    sliderPos = new PVector(map(val, max, min, pos.x-size.x/2, pos.x+size.x/2), pos.y);
    barHeight = bh;
    snapToInteger = snapInteger;
    label = new String(l);
    mouseHover = false;
    selected = false;
    previouslyUnselected = true;
    hasBeenUpdated = false;
  }

  Slider(Slider s) {
    max = s.max;
    min = s.min;
    val = s.val;
    fullWidth = s.fullWidth;
    pos = s.pos;
    size = new PVector(s.size.x,s.size.y,s.size.z);
    sliderPos = new PVector(s.sliderPos.x,s.sliderPos.y,s.sliderPos.z);
    mouseHover = s.mouseHover;
    selected = s.selected;
    previouslyUnselected = s.previouslyUnselected;
    snapToInteger = s.snapToInteger;
    barHeight = s.barHeight;
    label = new String(s.label);
    locked = s.locked;
    hasBeenUpdated = s.hasBeenUpdated;
  }

  void show() {
    int gray = 0;
    if (locked) {
      gray = 100;
    }
    noStroke();
    fill(255-gray);
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, barHeight);
    stroke(128-gray);
    ellipseMode(CENTER);
    if (selected) {
      fill(190-gray);
    } else if (mouseHover) {
      fill(225-gray);
    } else {
      fill(255-gray);
    }
    ellipse(sliderPos.x, sliderPos.y, size.y, size.y);
    textAlign(CENTER, CENTER);
    textSize(size.y/3);
    fill(255);
    text(label, pos.x+size.x/2+2*size.y, pos.y-size.y/3);
    if (snapToInteger) {
      text((int)val, pos.x+size.x/2+2*size.y, pos.y+size.y/3);
    } else {
      text(val, pos.x+size.x/2+2*size.y, pos.y+size.y/3);
    }
  }

  void updateValue() {
    val = map(sliderPos.x, pos.x+size.x/2, pos.x-size.x/2, min, max);
    hasBeenUpdated = true;
  }

  void update() {
    if (!locked) {
      if (!selected) {
        if (previouslyUnselected) {
          if (mouseOver()) {
            if (mousePressed) {
              selected = true;
            } else {
              mouseHover = true;
            }
          } else {
            mouseHover = false;
          }
        }
      } else {
        if (!mousePressed) {
          selected = false;
          mouseHover = false;
        } else {
          if (snapToInteger) {
            snapToInteger();
          } else if (mouseX < pos.x-size.x/2) {
            sliderPos.set(pos.x-size.x/2, sliderPos.y);
          } else if (mouseX > pos.x+size.x/2) {
            sliderPos.set(pos.x+size.x/2, sliderPos.y);
          } else {
            sliderPos.set(mouseX, sliderPos.y);
          }
          updateValue();
        }
      }

      if (mousePressed) {
        previouslyUnselected = false;
      } else {
        previouslyUnselected = true;
      }
    }
  }

  void snapToInteger() {
    if (mouseX < pos.x-size.x/2) {
      sliderPos.set(pos.x-size.x/2, sliderPos.y);
    } else if (mouseX > pos.x+size.x/2) {
      sliderPos.set(pos.x+size.x/2, sliderPos.y);
    } else {
      float newVal = map(mouseX, pos.x+size.x/2, pos.x-size.x/2, min, max);
      val = (int)newVal;
      if (newVal-val >= 0.5) {
        val++;
      }
      sliderPos = new PVector(map(val, max, min, pos.x-size.x/2, pos.x+size.x/2), pos.y);
    }
  }

  boolean mouseOver() {
    float dx = mouseX-sliderPos.x;
    float dy = mouseY-sliderPos.y;
    float rsquared = size.y*size.y;


    if (dx*dx+dy*dy <= rsquared) {
      return true;
    }
    return false;
  }

  float getSliderValue() {
    return val;
  }

  void lock() {
    locked ^= true;
  }

  boolean hasUpdated() {
    return hasBeenUpdated;
  }

  void resetUpdate() {
    hasBeenUpdated = false;
  }
}
