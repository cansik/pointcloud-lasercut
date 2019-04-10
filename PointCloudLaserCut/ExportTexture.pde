class ExportTexture extends ExportImage {
  private PGraphics g;

  public PGraphics getTexture() {
    return g;
  }

  public ExportTexture(int w, int h) {
    super(w, h);

    g = createGraphics(w, h);
  }

  String getExtension() {
    return "png";
  }

  void beginDraw() {
    g.beginDraw();
    engrave();
  }

  void drawPoint(float x, float y, float diameter) {
    g.ellipse(x, y, diameter, diameter);
  }

  void endDraw() {
    g.endDraw();
    g.loadPixels();
  }

  void save(String fileName) {
    g.save(fileName);
  }


  private void cut()
  {
    g.noFill();
    g.stroke(255);
    g.strokeWeight(0.1f);
  }

  private void engrave()
  {
    g.fill(255);
    g.noStroke();
  }
}
