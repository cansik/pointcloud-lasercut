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

    // find center point
    center = new PVector();

    for (int i = 0; i < vertices.getVertexCount(); i++)
    {
      PVector vertex = vertices.getVertex(i);
      updateMaxVector(maxVertex, vertex);
      updateMinVector(minVertex, vertex);

      center.add(vertex.x, vertex.y, vertex.z);
    }

    // find center
    center.mult(1.0f / vertices.getVertexCount());

    // scale by length of cloud
    dimensions = PVector.sub(maxVertex, minVertex);
    scale = screenSize / dimensions.mag();
    center.mult(scale);

    // calulate translation
    translation = PVector.mult(center, -1.0);

    // scale dimensions
    dimensions.mult(scale);
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
    byte[] r = vertex.property(UINT8, "red");
    byte[] g = vertex.property(UINT8, "green");
    byte[] b = vertex.property(UINT8, "blue");

    vertices = createShape();
    vertices.beginShape(POINTS);

    for (int i = 0; i < x.length; i++)
    {
      int rv = r[i] & 0xFF;
      int gv = g[i] & 0xFF;
      int bv = b[i] & 0xFF;

      vertices.strokeWeight(1.0f);
      vertices.stroke(rv, gv, bv);
      vertices.vertex(x[i], -y[i], z[i]);
    }

    vertices.endShape();
  }
}
