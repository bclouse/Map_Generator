class FullVector {
  public float x, y, z;
  public float r, theta, phi;    //Used in cylindrical/spherical coordinates
  private float tempX, tempY, tempZ;
  private boolean cylindricalEnabled;
  private boolean sphericalEnabled;

  FullVector() {
    set(0, 0, 0);
    disableCylindrical();
    disableSpherical();
  }

  FullVector(float X, float Y) {
    set(X, Y, 0);
    disableCylindrical();
    disableSpherical();
  }

  FullVector(float X, float Y, float Z) {
    set(X, Y, Z);
    disableCylindrical();
    disableSpherical();
  }

  private void set(float X, float Y, float Z) {
    x = X;
    y = Y;
    z = Z;
    calculateOtherCoordinates();
  }
  

  public void enableCylindrical() {
    cylindricalEnabled = true;
  }

  public void enableSpherical() {
    sphericalEnabled = true;
  }

  public void disableCylindrical() {
    cylindricalEnabled = false;
  }

  public void disableSpherical() {
    sphericalEnabled = false;
  }
  
  public void startTempRotation() {
    tempX = x;
    tempY = y;
    tempZ = z;
  }
  
  public void endTempRotation() {
    x = tempX;
    y = tempY;
    z = tempZ;
  }
  
  public void rotX(float a) {
    rotX(a,false);
  }
  
  public void rotX(float a, boolean updateOtherCoordinates) {
    y = y*cos(a)-z*sin(a);
    z = y*sin(a)+z*cos(a);
    
    if (updateOtherCoordinates) {
      calculateOtherCoordinates();
    }
  }
  
  public void rotY(float a) {
    rotY(a,false);
  }

  public void rotY(float a, boolean updateOtherCoordinates) {
    x = z*cos(a)-x*sin(a);
    z = z*sin(a)+x*cos(a);
    
    if (updateOtherCoordinates) {
      calculateOtherCoordinates();
    }
  }
  
  public void rotZ(float a) {
    rotZ(a,false);
  }

  public void rotZ(float a, boolean updateOtherCoordinates) {
    x = x*cos(a)-y*sin(a);
    y = x*sin(a)+y*cos(a);
    
    if (updateOtherCoordinates) {
      calculateOtherCoordinates();
    }
  }
  
  public void calculateRadius() {
    r = sqrt(x*x+y*y+z*z);
  }

  public void calculateTheta() {
    theta = atan(y/x);
    if (x < 0) {
      theta = PI+theta;
    } else if (x > 0 && y < 0) {
      theta = 2*PI+theta;
    }
  }

  public void calculatePhi() {
    phi = acos(z/(r));

    if (y < 0) {
      phi = 2*PI-phi;
    }
  }
  
  public void calculateOtherCoordinates() {
    if (cylindricalEnabled || sphericalEnabled) {
      calculateRadius();
      calculateTheta();
      if (sphericalEnabled) {
        calculatePhi();
      } else {
        phi = 0;
      }
    } else {
      r = 0;
      theta = 0;
      phi = 0;
    }
  }
}
