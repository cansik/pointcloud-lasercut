class ExportPLY extends ExportImage {

  PointCloud exportCloud;

  public ExportPLY(int w, int h) {
    super(w, h);
  }

  String getExtension() {
    return "ply";
  }

  void beginDraw() {
    exportCloud = new PointCloud();
    exportCloud.vertices = createShape();
    exportCloud.vertices.beginShape(POINTS);
  }

  void drawPoint(float x, float y, float diameter) {   
    exportCloud.vertices.strokeWeight(1.0f);
    exportCloud.vertices.stroke(255);
    exportCloud.vertices.vertex(x, y, 0);
  }

  void endDraw() {
    exportCloud.vertices.endShape();
  }

  void save(String fileName) {
    try {
      exportCloud.save(fileName);
    } 
    catch (Exception ex) {
      println("Error while saving ply: ");
      ex.printStackTrace();
    }
  }
}
