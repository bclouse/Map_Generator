class SphereFrame {
  float radius;
  PVector[][] flatFrame;    //takes x, y and returns the corresponding 3D coordinates
  PVector[][] unitFrame;    //takes x, y and returns the corresponding 3D coordinates
  PVector[][] wireFrame;    //takes x, y and returns the corresponding spherical coordinates (not including the radius)
  ArrayList<PVector> ring;
  ArrayList<Float> phis;
  PVector size;
  PVector rotation;
  float needsRotation;
  float totalSize;

  /*=============================================================
   ===============================================================
   INTITIALIZING
   ===============================================================
   =============================================================*/

  SphereFrame(float r, float w, float h) {
    this.radius = r;
    size = new PVector(w, h);
    rotation = new PVector(0, 0, 0);
    unitFrame = new PVector[(int)w][(int)h];
    flatFrame = new PVector[(int)w][(int)h];
    wireFrame = new PVector[(int)w][(int)h];
    ring = new ArrayList<PVector>();
    phis = new ArrayList<Float>();
    needsRotation = 0;
    totalSize = w*h;






    updateUnitFrame();
    //ArrayList<Float> phi = getPhiAngles(radius, h, 0);
    //float theta;
    //PVector dummy;
    //for (int y = 0; y < h; y++) {
    //  for (int x = 0; x < w; x++) {
    //    theta = radians(x/w*360);
    //    dummy = getCartesian(new PVector(radius, theta, phi.get(y)));
    //    unitFrame[x][y] = new PVector(dummy.x, dummy.y, dummy.z);
    //    flatFrame[x][y] = new PVector(dummy.x, dummy.y, dummy.z);
    //  }
    //}
  }

  /*=============================================================
   ===============================================================
   MODIFYING FRAME
   ===============================================================
   =============================================================*/

  void updateUnitFrame() {
    float theta;
    phis = getPhiAngles(radius, size.y, 0);
    PVector dummy;
    int phi;
    int t;
    int prev = 0;


    //println(((int)degrees(phis.get(0))));
    for (int y = 0; y < size.y; y++) {
      //phi = (int)degrees(phis.get(y));
      //if ((phi+90)%15 == 0 && phi != prev) {
      //  //println(phi);
      //  prev = phi;
      //}
      for (int x = 0; x < size.x; x++) {
        theta = x/size.x*360;
        dummy = getCartesian(new PVector(radius, radians(theta), phis.get(y)));
        unitFrame[x][y] = new PVector(dummy.x, dummy.y, dummy.z);
        flatFrame[x][y] = new PVector(dummy.x, dummy.y, dummy.z);
        wireFrame[x][y] = new PVector(0, 0, 0);
      }
    }

    for (int y = 0; y < 12; y++) {
      for (int x = 0; x < size.x; x++) {
      }
    }

    //updateRotation();
  }

  PVector updateRotationAt(int x, int y) {
    //if (needsRotation < totalSize) {
      float theta, phi;
      phi = 0;
      needsRotation++;
      
      flatFrame[x][y].set(unitFrame[x][y].x, unitFrame[x][y].y, unitFrame[x][y].z);
      if (rotation.z != 0) {
        flatFrame[x][y].set(rotZ(rotation.z, flatFrame[x][y]));
      }
      if (rotation.y != 0) {
        flatFrame[x][y].set(rotX(rotation.y, flatFrame[x][y]));
      }
      if (rotation.x != 0) {
        flatFrame[x][y].set(rotZ(rotation.x, flatFrame[x][y]));
      }
      

      theta = degrees(getTheta(flatFrame[x][y]))%30;
      if (theta >=30/2) {
        theta = 30-theta;
      }
      phi = degrees(getPhi(flatFrame[x][y]))%15;
      if (phi >= 15/2) {
        phi = 15-phi;
      }
      wireFrame[x][y].set(theta, phi, 0);

    return flatFrame[x][y];
  }

  void updateRotation() {
    float theta, phi;
    phi = 0;

    for (int y = 0; y < size.y; y++) {
      for (int x = 0; x < size.x; x++) {
        flatFrame[x][y].set(unitFrame[x][y].x, unitFrame[x][y].y, unitFrame[x][y].z);
        //wireFrame[x][y].set(x, y, 0);
        if (rotation.z != 0) {
          flatFrame[x][y].set(rotZ(rotation.z, flatFrame[x][y]));
        }
        if (rotation.y != 0) {
          flatFrame[x][y].set(rotX(rotation.y, flatFrame[x][y]));
        }
        if (rotation.x != 0) {
          flatFrame[x][y].set(rotZ(rotation.x, flatFrame[x][y]));
        }



        theta = degrees(getTheta(flatFrame[x][y]))%30;
        if (theta >=30/2) {
          theta = 30-theta;
        }
        phi = degrees(getPhi(flatFrame[x][y]))%15;
        if (phi >= 15/2) {
          phi = 15-phi;
        }
        wireFrame[x][y].set(theta, phi, 0);
        //if (x == y) {
        //  println(wireFrame[x][y].x+"\t\t"+wireFrame[x][y].y);
        //}
      }
      //println("[ "+0+", "+y+" ] = "+phi);
      //println(phi);
    }
    //println("\n\n");
  }

  void generateFlatFrame(PVector off) {
    rotation = new PVector(off.x, off.y);
  }

  ArrayList<Float> getPhiAngles(float radius, float resolution, float offset) {
    float z;

    ArrayList<Float> output = new ArrayList<Float>();
    for (int i = 0; i < resolution; i++) {
      z = resolution/2-i;
      z = map(z, 0, resolution/2, 0, radius);
      output.add(acos(z/radius)+offset);
      //println(output.get(output.size()-1));
    }
    //println("\n\n");
    return output;
  }

  PVector getCartesian(PVector sphericalInfo) {                            //Spherical Info must be ordered as so: [radius, theta, phi]
    float x = sphericalInfo.x*sin(sphericalInfo.z)*cos(sphericalInfo.y);       //x = r*sin(phi)*cos(theta)
    float y = sphericalInfo.x*sin(sphericalInfo.z)*sin(sphericalInfo.y);       //y = r*sin(phi)*sin(theta)
    float z = sphericalInfo.x*cos(sphericalInfo.z);                            //z = r*cos(phi)

    PVector output = new PVector(x, y, z);

    return output;
  }

  void changeRotation(PVector p) {
    rotation = new PVector(p.x, p.y, p.z);
    needsRotation = 0;
    updateRotation();
  }

  PVector[][] getFlatFrame() {
    return flatFrame;
  }

  void setRadius(float r) {
    radius = r;
    updateUnitFrame();
  }
}








/*=============================================================
 ===============================================================
 ROTATIONS
 ===============================================================
 =============================================================*/

PVector rotX(float a, PVector p) {
  return new PVector(p.x, p.y*cos(a)-p.z*sin(a), p.y*sin(a)+p.z*cos(a));
}

PVector rotY(float a, PVector p) {
  return new PVector(p.z*cos(a)-p.x*sin(a), p.y, p.z*sin(a)+p.x*cos(a));
}

PVector rotZ(float a, PVector p) {
  return new PVector(p.x*cos(a)-p.y*sin(a), p.x*sin(a)+p.y*cos(a), p.z);
}

float getTheta(PVector p) {
  float out = atan(p.y/p.x);
  if (p.x < 0) {
    out = PI+out;
  } else if (p.x > 0 && p.y < 0) {
    out = 2*PI+out;
  }

  return out;
}

float getPhi(PVector p) {
  float out = acos(p.z/(Radius));

  if (p.y < 0) {
    out = 2*PI-out;
  }

  return out;
}
