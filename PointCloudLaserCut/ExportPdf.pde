class ExportPdf extends ExportImage {
  private PGraphics g;

  private String tempPath = sketchPath("temp.pdf");

  public ExportPdf(int w, int h) {
    super(w, h);

    g = (PGraphicsPDF)beginRecord(PDF, tempPath);
    g.setSize(w, h);
  }
  
  String getExtension() {
    return "pdf";
  }

  void beginDraw() {
    g.beginDraw();
    cut();
  }

  void drawPoint(float x, float y, float diameter) {
    g.point(x, y);
  }

  void endDraw() {
    endRecord();
  }

  void save(String fileName) {
    File f = new File(tempPath);
    f.renameTo(new File(fileName));
  }


  private void cut()
  {
    g.noFill();
    g.stroke(0);
    g.strokeWeight(0.1f);
  }

  private void engrave()
  {
    g.fill(0);
    g.noStroke();
  }
}
