import processing.pdf.*; //<>//

class LaserCutExporter
{
  int slices = 5;
  int pointCloudSamples = 1;

  // mm
  int outputMax = 230;
  float pointRadius = 0.1;

  PointCloud cloud;

  boolean generating = false;
  private int outputHeight = 0;
  private int outputWidth = 0;

  float sliceDepth = 10;

  public LaserCutExporter(PointCloud cloud)
  {
    this.cloud = cloud;
  }

  public void generate(String filePath, ExportType exportType)
  {
    exporter.generating = true;
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);

    // calculate export scale
    if (d.x > d.y) {
      // x is size
      outputWidth = outputMax;
      outputHeight = round(outputMax * (d.y / d.x));
    } else {
      // y is size
      outputHeight = outputMax;
      outputWidth = round(outputMax * (d.x / d.y));
    }

    println("Output: w: " + outputWidth + " h: " + outputHeight);

    float sliceSize = d.z / slices;

    for (int i = 0; i < slices; i++)
    {
      println("generating slice " + i + "...");

      ExportImage img = createExportImage(exportType, round(mm(outputWidth)), round(mm(outputHeight)));

      float startSlice = sliceSize * i + (d.z * -0.5);
      float endSlice = sliceSize * (i + 1) + (d.z * -0.5);

      img.beginDraw();
      createSlice(img, startSlice, endSlice);
      img.endDraw();

      println("exporting slice " + i + "...");
      img.save(filePath + "slice_" + i + "." + img.getExtension());
    }

    println("cloud exported");
    exporter.generating = false;
  }

  private void createSlice(ExportImage g, float sliceStart, float sliceEnd)
  {
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);
    PVector t = PVector.div(cloud.translation, cloud.scale);

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

      g.drawPoint(mm(mx), mm(my), mm(pointRadius));
    }
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
