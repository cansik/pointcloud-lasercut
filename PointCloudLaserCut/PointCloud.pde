import java.nio.file.Path;
import java.nio.file.Paths;

import org.jengineering.sjmply.PLY;
import static org.jengineering.sjmply.PLYType.*;
import static org.jengineering.sjmply.PLYFormat.*;

class PointCloud
{
  PVector dimensions = new PVector();
  PVector center = new PVector();

  PShape vertices = new PShape();

  float scale = 1.0f;
  PVector translation = new PVector();

  float pointScale = 0.1f;
  color pointColor = color(255, 255, 255);

  public PointCloud()
  {
  }

  // normalizes point cloud to screen size
  public void normalizeCloud(float width, float height, float depth)
  {
    float screenSize = (width + height + depth) / 3f * 0.5f;

    // find max and min points
    PVector maxVertex = new PVector(Float.MIN_VALUE, Float.MIN_VALUE, Float.MIN_VALUE);
    PVector minVertex = new PVector(Float.MAX_VALUE, Float.MAX_VALUE, Float.MAX_VALUE);

    for (int i = 0; i < vertices.getVertexCount(); i++)
    {
      PVector vertex = vertices.getVertex(i);
      updateMaxVector(maxVertex, vertex);
      updateMinVector(minVertex, vertex);
    }

    // find center of cloud
    center = new PVector();
    center.add(maxVertex);
    center.add(minVertex);
    center.mult(0.5f);

    // scale by length of cloud
    dimensions = PVector.sub(maxVertex, minVertex);
    scale = screenSize / dimensions.mag();
    center.mult(scale);

    // calulate translation
    translation = PVector.mult(center, -1.0);

    // scale dimensions
    dimensions.mult(scale);

    println("proportions: " + dimensions.x / dimensions.y);
  }

  // loads new pointcloud from ply ascii file
  public void load(String fileName)
  {
    Path path = Paths.get(fileName);
    PLY ply = new PLY();

    try
    {
      ply = PLY.load(path);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }

    PLYElementList vertex = ply.elements("vertex");

    // coordinates
    float[] x = vertex.property(FLOAT32, "x");
    float[] y = vertex.property(FLOAT32, "y");
    float[] z = vertex.property(FLOAT32, "z");

    // colors
    byte[] r = new byte[0];
    byte[] g = new byte[0];
    byte[] b = new byte[0];
    boolean colorLoaded = false;

    try {
      r = vertex.property(UINT8, "red");
      g = vertex.property(UINT8, "green");
      b = vertex.property(UINT8, "blue");

      colorLoaded = true;
    } 
    catch(Exception ex) {
      println("no color information!");
    }

    vertices = createShape();
    vertices.beginShape(POINTS);

    for (int i = 0; i < x.length; i++)
    {
      vertices.strokeWeight(1.0f);

      if (colorLoaded) {
        int rv = r[i] & 0xFF;
        int gv = g[i] & 0xFF;
        int bv = b[i] & 0xFF;
        vertices.stroke(rv, gv, bv);
      } else {
        vertices.stroke(255);
      }
      vertices.vertex(x[i], -y[i], z[i]);
    }

    vertices.endShape();
  }

  public void save(String fileName)
  {
    Path path = Paths.get(fileName);
    PLY ply = new PLY();

    PLYElementList vertex = new PLYElementList(vertices.getVertexCount());

    // coordinates
    float[] x = vertex.addProperty(FLOAT32, "x");
    float[] y = vertex.addProperty(FLOAT32, "y");
    float[] z = vertex.addProperty(FLOAT32, "z");

    // colors
    byte[] r = vertex.addProperty(UINT8, "red");
    byte[] g = vertex.addProperty(UINT8, "green");
    byte[] b = vertex.addProperty(UINT8, "blue");

    for (int i = 0; i < vertices.getVertexCount(); i++)
    {
      PVector v = vertices.getVertex(i);
      color c = vertices.getFill(i);

      // coordinates
      x[i] = v.x;
      y[i] = -v.y;
      z[i] = v.z;

      // colors
      r[i] = (byte)red(c);
      g[i] = (byte)green(c);
      b[i] = (byte)blue(c);
    }

    ply.elements.put("vertex", vertex);
    //ply.setFormat(ASCII);
    ply.setFormat(BINARY_LITTLE_ENDIAN);

    try
    {
      ply.save(path);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }
}
