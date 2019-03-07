import processing.pdf.*; //<>//

class LaserCutExporter
{
  int slices = 5;
  int pointCloudSamples = 1;

  // mm
  int outputHeight = 230;
  int outputWidth = round(outputHeight * 0.72752184);
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
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);

    float sliceSize = d.z / slices;

    for (int i = 0; i < slices; i++)
    {
      println("exporting slice " + i + "...");

      /*
       PGraphicsPDF pdf = (PGraphicsPDF)beginRecord(PDF, filePath + "tree_slice_" + i + ".pdf");
       pdf.setSize(round(mm(900)), round(mm(600)));
       pdf.beginDraw();
       */

      PGraphics img = createGraphics(round(mm(outputWidth)), round(mm(outputHeight)));

      float startSlice = sliceSize * i + (d.z * -0.5);
      float endSlice = sliceSize * (i + 1) + (d.z * -0.5);

      img.beginDraw();
      exportSlice(img, startSlice, endSlice);
      img.endDraw();

      img.save(filePath + "tree_slice_" + i + ".png");

      /*
      endRecord();
       */
    }

    println("cloud exported!");
    exporter.exporting = false;
  }

  private void exportSlice(PGraphics g, float sliceStart, float sliceEnd)
  {
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);
    PVector t = PVector.div(cloud.translation, cloud.scale);

    cut(g);
    //g.rect(0, 0, mm(outputWidth), mm(outputHeight));

    engrave(g);

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

      g.ellipse(mm(mx), mm(my), mm(pointRadius), mm(pointRadius));
    }
  }

  private void cut(PGraphics g)
  {
    g.noFill();
    g.stroke(0);
    g.strokeWeight(0.1f);
  }

  private void engrave(PGraphics g)
  {
    g.fill(0);
    g.noStroke();
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
