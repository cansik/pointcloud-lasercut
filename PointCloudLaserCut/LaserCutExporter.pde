import processing.pdf.*;

class LaserCutExporter
{
  int slices = 5;
  int pointCloudSamples = 10;

  // mm
  int outputWidth = 75;
  int outputHeight = 150;
  float pointRadius = 0.1;

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
    float sliceSize = d.z / slices;

    PGraphicsPDF pdf = (PGraphicsPDF)beginRecord(PDF, filePath);
    pdf.setSize(round(mm(900)), round(mm(600)));
    pdf.beginDraw();

    for (int i = 0; i < slices; i++)
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

    cut(pdf);
    rect(0, 0, outputWidth, outputHeight);

    engrave(pdf);

    // go through all vertices and draw them if relevant
    for (int i = 0; i < cloud.vertices.getVertexCount(); i += pointCloudSamples)
    {
      PVector v = cloud.vertices.getVertex(i);

      // skip if not relevant
      if (!(v.z >= sliceStart && v.z <= sliceEnd)) continue;

      // map and draw point
      float mx = map(v.x, d.x * -0.5, d.x * 0.5, 0, outputWidth);
      float my = map(v.y, d.y * -0.5, d.y * 0.5, 0, outputHeight);

      pdf.ellipse(mm(mx), mm(my), mm(pointRadius), mm(pointRadius));
    }
  }

  private void cut(PGraphicsPDF pdf)
  {
    pdf.noFill();
    pdf.stroke(0);
    pdf.strokeWeight(0.1f);
  }

  private void engrave(PGraphicsPDF pdf)
  {
    pdf.fill(0);
    pdf.noStroke();
  }

  public void render(PGraphics g)
  {
    PVector d = pointCloud.dimensions;
    float sliceSize = d.z / slices;

    for (int i = 0; i < slices; i++)
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
