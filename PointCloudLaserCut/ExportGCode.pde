class ExportGCode extends ExportImage {
  float liftZ = 0.5;

  ArrayList<String> gcode;

  public ExportGCode(int w, int h) {
    super(w, h);

    gcode = new ArrayList<String>();
  }

  String getExtension() {
    return "gcode";
  }

  void beginDraw() {
    comment("drawing some points");
    
    // settings
    absoluteMode();
    unitMM();
  }

  void drawPoint(float x, float y, float diameter) {
    // move to position
    moveRapidXY(x, y);

    // dip
    moveRapidZ(0.0f);
    moveRapidZ(liftZ);
  }

  void endDraw() {
    programmEnd();
  }

  void save(String fileName) {
    try {
      saveStrings(fileName, getStringArray(gcode));
    } 
    catch (Exception ex) {
      println("Error while saving gcode: ");
      ex.printStackTrace();
    }
  }

  // gcode related methods
  void gcodeCommand(String cmd) {
    gcode.add(cmd);
  }

  void comment(String text) {
    gcodeCommand("; " + text);
  }

  void programmStop() {
    gcodeCommand("M00");
  }

  void programmEnd() {
    gcodeCommand("M02");
  }

  void absoluteMode() {
    gcodeCommand("G90");
  }

  void incrementialMode() {
    gcodeCommand("G91");
  }

  void unitMM() {
    gcodeCommand("G21");
  }

  void unitInches() {
    gcodeCommand("G20");
  }

  void moveRapidX(float x) {
    gcodeCommand(String.format("G00 X%.2f", x));
  }

  void moveRapidY(float y) {
    gcodeCommand(String.format("G00 Y%.2f", y));
  }

  void moveRapidZ(float z) {
    gcodeCommand(String.format("G00 Z%.2f", z));
  }

  void moveRapidXY(float x, float y) {
    gcodeCommand(String.format("G00 X%.2f Y%.2f", x, y));
  }

  void moveRapid(float x, float y, float z) {
    gcodeCommand(String.format("G00 X%.2f Y%.2f Z%.2f", x, y, z));
  }

  void moveLerpX(float x, float feedRate) {
    gcodeCommand(String.format("G01 X%.2f F%.2f", x, feedRate));
  }

  void moveLerpY(float y, float feedRate) {
    gcodeCommand(String.format("G01 Y%.2f F%.2f", y, feedRate));
  }

  void moveLerpZ(float z, float feedRate) {
    gcodeCommand(String.format("G01 Z%.2f F%.2f", z, feedRate));
  }

  void moveLerpXY(float x, float y, float feedRate) {
    gcodeCommand(String.format("G01 X%.2f Y%.2f F%.2f", x, y, feedRate));
  }

  void moveLerp(float x, float y, float z, float feedRate) {
    gcodeCommand(String.format("G01 X%.2f Y%.2f Z%.2f F%.2f", x, y, z, feedRate));
  }

  // utils
  public String[] getStringArray(ArrayList<String> arr) 
  { 

    // declaration and initialise String Array 
    String str[] = new String[arr.size()]; 

    // ArrayList to Array Conversion 
    for (int j = 0; j < arr.size(); j++) { 

      // Assign each value to String array 
      str[j] = arr.get(j);
    } 

    return str;
  }
}
