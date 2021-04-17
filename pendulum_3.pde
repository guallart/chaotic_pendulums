class pendulum_3 {

  PVector[] path = new PVector[200];
  float l = 150;
  int[] col;

  int timeAcc = 7;

  Table table;
  String index;

  pendulum_3(float wl, String index) {

    table = loadTable("data.csv", "header");
    this.index = index;

    this.col = waveLengthToRGB(wl);

    for (int i = 0; i < this.path.length; i++) {
      float x = this.l * sin(angle("th"+this.index+"1", 0)) + this.l * sin(angle("th"+this.index+"2", 0)) + this.l * sin(angle("th"+this.index+"3", 0));
      float y = this.l * cos(angle("th"+this.index+"1", 0)) + this.l * cos(angle("th"+this.index+"2", 0)) + this.l * cos(angle("th"+this.index+"3", 0));

      this.path[i] = new PVector(x, y);
    }
  }

  void updatePath(int time) {
    time *= this.timeAcc;
    for (int j = this.path.length-1; j >= 1; j--) {
      this.path[j] = this.path[j-1].copy();
    }
    this.path[0].x = this.l * sin(angle("th"+this.index+"1", time)) + this.l * sin(angle("th"+this.index+"2", time)) + this.l * sin(angle("th"+this.index+"3", time));
    this.path[0].y = this.l * cos(angle("th"+this.index+"1", time)) + this.l * cos(angle("th"+this.index+"2", time)) + this.l * cos(angle("th"+this.index+"3", time));
  }

  float angle(String th, int row) {
    return this.table.getRow(row).getFloat(th);
  }

  void show(int time) {
    time *= this.timeAcc;
    stroke(51);
    strokeWeight(2);

    float x1 = this.l * sin(angle("th"+this.index+"1", time));
    float y1 = this.l * cos(angle("th"+this.index+"1", time));
    line(0, 0, x1, y1);

    float x2 = x1 + this.l * sin(angle("th"+this.index+"2", time));
    float y2 = y1 + this.l * cos(angle("th"+this.index+"2", time));
    line(x1, y1, x2, y2);

    float x3 = x2 + this.l * sin(angle("th"+this.index+"3", time));
    float y3 = y2 + this.l * cos(angle("th"+this.index+"3", time));
    line(x2, y2, x3, y3);

    strokeWeight(2);
    float sizeBall = 5;
    ellipse(0, 0, sizeBall, sizeBall);
    ellipse(x1, y1, sizeBall, sizeBall);
    ellipse(x2, y2, sizeBall, sizeBall);
    ellipse(x3, y3, sizeBall, sizeBall);

    stroke(this.col[0], this.col[1], this.col[2]);
    noFill();
    beginShape();
    for (int i = 0; i < this.path.length; i++) {
      vertex(this.path[i].x, this.path[i].y);
    }
    endShape();
  }

  /** Taken from Earl F. Glynn's web page:
   * <a href="http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm">Spectra Lab Report</a>
   * */
  public int[] waveLengthToRGB(double Wavelength) {

    double Gamma = 0.80;
    double IntensityMax = 255;

    double factor;
    double Red, Green, Blue;

    if ((Wavelength >= 380) && (Wavelength<440)) {
      Red = -(Wavelength - 440) / (440 - 380);
      Green = 0.0;
      Blue = 1.0;
    } else if ((Wavelength >= 440) && (Wavelength<490)) {
      Red = 0.0;
      Green = (Wavelength - 440) / (490 - 440);
      Blue = 1.0;
    } else if ((Wavelength >= 490) && (Wavelength<510)) {
      Red = 0.0;
      Green = 1.0;
      Blue = -(Wavelength - 510) / (510 - 490);
    } else if ((Wavelength >= 510) && (Wavelength<580)) {
      Red = (Wavelength - 510) / (580 - 510);
      Green = 1.0;
      Blue = 0.0;
    } else if ((Wavelength >= 580) && (Wavelength<645)) {
      Red = 1.0;
      Green = -(Wavelength - 645) / (645 - 580);
      Blue = 0.0;
    } else if ((Wavelength >= 645) && (Wavelength<781)) {
      Red = 1.0;
      Green = 0.0;
      Blue = 0.0;
    } else {
      Red = 0.0;
      Green = 0.0;
      Blue = 0.0;
    };

    // Let the intensity fall off near the vision limits

    if ((Wavelength >= 380) && (Wavelength<420)) {
      factor = 0.3 + 0.7*(Wavelength - 380) / (420 - 380);
    } else if ((Wavelength >= 420) && (Wavelength<701)) {
      factor = 1.0;
    } else if ((Wavelength >= 701) && (Wavelength<781)) {
      factor = 0.3 + 0.7*(780 - Wavelength) / (780 - 700);
    } else {
      factor = 0.0;
    };


    int[] rgb = new int[3];

    // Don't want 0^x = 1 for x <> 0
    rgb[0] = Red==0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Red * factor, Gamma));
    rgb[1] = Green==0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Green * factor, Gamma));
    rgb[2] = Blue==0.0 ? 0 : (int) Math.round(IntensityMax * Math.pow(Blue * factor, Gamma));

    if (Wavelength > 700) {
      return  waveLengthToRGB(700);
    } else if (Wavelength < 400) {
      return  waveLengthToRGB(400);
    } else {
      return rgb;
    }
  }
}
