abstract class ExportImage {
  int w;
  int h;

  public ExportImage(int w, int h) {
    this.w = w;
    this.h = h;
  }
  
  abstract String getExtension();

  abstract void beginDraw();

  abstract void endDraw();

  abstract void drawPoint(float x, float y, float diameter);

  abstract void save(String fileName);
}

enum ExportType {
  Bitmap, 
    Pdf
}

ExportImage createExportImage(ExportType exportType, int w, int h) {
  if (exportType == ExportType.Bitmap)
    return new ExportBitmap(w, h);

  if (exportType == ExportType.Pdf)
    return new ExportPdf(w, h);

  return null;
}
