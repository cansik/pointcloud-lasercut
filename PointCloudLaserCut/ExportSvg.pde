import org.jfree.graphics2d.svg.*;
import java.awt.Color;
import java.awt.Rectangle;
import java.awt.BasicStroke;

class ExportSvg extends ExportImage {
  SVGGraphics2D g;

  public ExportSvg(int w, int h) {
    super(w, h);

    g = new SVGGraphics2D(w, h);
  }

  String getExtension() {
    return "svg";
  }

  void beginDraw() {
    cut();

    // add cutting rectangle
    g.draw(new Rectangle(0, 0, w, h));

    engrave();
  }

  void drawPoint(float x, float y, float diameter) {
    // caution: can be very inaccurate!
    g.drawOval(round(x), round(y), round(diameter), round(diameter));
  }

  void endDraw() {
  }

  void save(String fileName) {
    try {
      saveBytes(fileName, g.getSVGDocument().getBytes("UTF8"));
    } 
    catch (Exception ex) {
      println("Error while saving svg: ");
      ex.printStackTrace();
    }
  }


  private void cut()
  {
    g.setPaint(null);
    g.setColor(Color.black);
    g.setStroke(new BasicStroke(0.1f));
  }

  private void engrave()
  {
    g.setPaint(Color.black);
    g.setColor(Color.black);
    g.setStroke(new BasicStroke(0.1f));
  }
}
