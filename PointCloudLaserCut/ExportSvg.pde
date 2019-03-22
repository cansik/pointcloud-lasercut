import org.jfree.graphics2d.svg.*;
import java.awt.Color;
import java.awt.Rectangle;
import java.awt.BasicStroke;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;

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
    g.draw(new Line2D.Float(x - (diameter / 2f), y, x + (diameter / 2f), y));
    //g.draw(new Ellipse2D.Float(x, y, diameter, diameter));
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
    g.setStroke(new BasicStroke(mm(0.1f)));
  }

  private void engrave()
  {
    g.setPaint(Color.black);
    g.setColor(Color.black);
    g.setStroke(new BasicStroke(mm(0.1f)));
  }
}
