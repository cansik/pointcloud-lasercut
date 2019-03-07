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
  PGraphics[] images = new PGraphics[0];

  public LaserCutExporter(PointCloud cloud)
  {
    this.cloud = cloud;
  }

  public void export(String filePath)
  {
    for (int i = 0; i < images.length; i++)
    {
      PImage img = images[i];
      img.save(filePath + "tree_slice_" + i + ".png");
    }

    println("cloud exported!");
  }

  public void generate()
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

    images = new PGraphics[slices];

    for (int i = 0; i < slices; i++)
    {
      println("generating slice " + i + "...");

      PGraphics img = createGraphics(round(mm(outputWidth)), round(mm(outputHeight)));

      float startSlice = sliceSize * i + (d.z * -0.5);
      float endSlice = sliceSize * (i + 1) + (d.z * -0.5);

      img.beginDraw();
      exportSlice(img, startSlice, endSlice);
      img.endDraw();

      img.loadPixels();
      images[i] = img;
    }

    println("cloud generated");
    exporter.generating = false;
  }

  private void exportSlice(PGraphics g, float sliceStart, float sliceEnd)
  {
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);
    PVector t = PVector.div(cloud.translation, cloud.scale);

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

  public void display(PGraphics g)
  { 
    g.background(200);

    float slizeMax = sliceDepth * images.length;

    for (int i = 0; i < images.length; i++)
    {
      PGraphics img = images[i];

      g.push();

      g.translate(0, 0, (slizeMax * -0.5) + (i * sliceDepth));
      g.stroke(255, 100, 100);
      g.textureMode(IMAGE);
      g.texture(img);
      g.box(img.width, img.height, sliceDepth);
      g.pop();
    }
  }
}
