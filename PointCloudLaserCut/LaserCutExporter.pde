import processing.pdf.*; //<>//

class LaserCutExporter
{
  int slices = 5;
  int pointCloudSamples = 10;

  // mm
  int outputWidth = round(100 * 0.72752184);
  int outputHeight = 100;
  float pointRadius = 0.5;

  PointCloud cloud;

  boolean exporting = false;

  public LaserCutExporter(PointCloud cloud)
  {
    this.cloud = cloud;
  }

  public void export(String filePath)
  {
    exporter.exporting = true;
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);

    float sliceSize = d.z / slices;

    for (int i = 0; i < slices; i++)
    {
      println("exporting slice " + i + "...");

      PGraphicsPDF pdf = (PGraphicsPDF)beginRecord(PDF, filePath + "tree_slice_" + i + ".pdf");
      pdf.setSize(round(mm(900)), round(mm(600)));
      pdf.beginDraw();

      float startSlice = sliceSize * i + (d.z * -0.5);
      float endSlice = sliceSize * (i + 1) + (d.z * -0.5);

      println("start: " + startSlice + " endslice: " + endSlice);
      exportSlice(pdf, startSlice, endSlice);

      endRecord();
    }

    println("cloud exported!");
    exporter.exporting = false;
  }

  private void exportSlice(PGraphics pdf, float sliceStart, float sliceEnd)
  {
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);
    PVector t = PVector.div(cloud.translation, cloud.scale);

    cut(pdf);
    rect(mm(0), mm(0), mm(outputWidth), mm(outputHeight));

    engrave(pdf);

    // go through all vertices and draw them if relevant
    for (int i = 0; i < cloud.vertices.getVertexCount(); i += pointCloudSamples)
    {
      PVector v = cloud.vertices.getVertex(i);

      // apply translation
      v.add(t);

      // skip if not relevant
      if (!(v.z >= sliceStart && v.z <= sliceEnd)) continue;

      // map and draw point
      float mx = map(v.x, d.x * -0.5, d.x * 0.5, 0, outputWidth);
      float my = map(v.y, d.y * -0.5, d.y * 0.5, 0, outputHeight);

      pdf.ellipse(mm(mx), mm(my), mm(pointRadius), mm(pointRadius));
    }
  }

  private void cut(PGraphics pdf)
  {
    pdf.noFill();
    pdf.stroke(0);
    pdf.strokeWeight(0.1f);
  }

  private void engrave(PGraphics pdf)
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
