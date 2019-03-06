import processing.pdf.*;

class LaserCutExporter
{
  int samples = 5;

  // mm
  int outputWidth = 75;
  int outputHeight = 150;
  float pointRadius = 1;

  PointCloud cloud;

  boolean exporting = false;

  public LaserCutExporter(PointCloud cloud)
  {
    this.cloud = cloud;
  }

  public void export(String filePath)
  {
    exporter.exporting = true;
    PVector d = pointCloud.dimensions;
    float sliceSize = d.z / samples;

    PGraphicsPDF pdf = (PGraphicsPDF)beginRecord(PDF, filePath);
    pdf.setSize(round(mm(outputWidth)), round(mm(outputHeight)));
    pdf.beginDraw();

    for (int i = 0; i < samples; i++)
    {
      println("exporting slice " + i + "...");
      exportSlice(pdf, sliceSize * i, sliceSize * (i + 1));
      pdf.nextPage();
    }

    endRecord();

    println("cloud exported!");
    exporter.exporting = false;
  }

  private void exportSlice(PGraphicsPDF pdf, float sliceStart, float sliceEnd)
  {
    PVector d = pointCloud.dimensions;

    // setup drawing parameters
    noStroke();
    fill(0);

    // go through all vertices and draw them if relevant
    for (int i = 0; i < cloud.vertices.getVertexCount(); i++)
    {
      PVector v = cloud.vertices.getVertex(i);

      // skip if not relevant
      if (v.z >= sliceStart && v.z <= sliceEnd) continue;

      // map and draw point
      float mx = map(v.x, -d.x, d.x, 0, outputWidth);
      float my = map(v.y, -d.y, d.y, 0, outputHeight);

      ellipse(mm(mx), mm(my), pointRadius, pointRadius);
    }
  }

  public void render(PGraphics g)
  {
    PVector d = pointCloud.dimensions;
    float sliceSize = d.z / samples;

    for (int i = 0; i < samples; i++)
    {
      g.push();
      g.translate(0, 0, -0.5 * d.z + (sliceSize * .5) + (sliceSize * i));

      // draw sample box
      g.noFill();
      g.strokeWeight(2);
      g.stroke(100, 100, 255);
      g.box(d.x, d.y, sliceSize);
      g.pop();
    }
  }
}
