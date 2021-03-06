import processing.pdf.*; //<>// //<>//

class LaserCutExporter implements Runnable
{
  int slices = 5;
  int pointCloudSamples = 1;
  boolean flipAxis = false;

  // mm
  int outputMax = 230;
  float pointRadius = 0.1;

  PointCloud cloud;

  volatile boolean exporting = false;
  private int outputHeight = 0;
  private int outputWidth = 0;

  float sliceDepth = 10;

  private Thread exportThread;
  private String _filePath;
  private ExportType _exportType;
  private float _imageResolution;

  volatile float exportProgress = 0.0;

  public LaserCutExporter(PointCloud cloud)
  {
    this.cloud = cloud;
  }

  public void generateAsync(String filePath, float imageResolution, ExportType exportType) {

    _filePath = filePath;
    _exportType = exportType;
    _imageResolution = imageResolution;

    exportThread = new Thread(this);
    exportThread.start();
  }

  public void run() {
    generate(_filePath, _exportType);
  }

  public PVector getSliceSize(PVector d) {
    PVector result = new PVector();

    // calculate export scale
    if (d.x > d.y) {
      // x is size
      result.x = outputMax;
      result.y = round(outputMax * (d.y / d.x));
    } else {
      // y is size
      result.y = outputMax;
      result.x = round(outputMax * (d.x / d.y));
    }

    return result;
  }

  public void generate(String filePath, ExportType exportType)
  {
    exportProgress = 0.0;
    exporter.exporting = true;

    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);

    PVector sliceDimension = getSliceSize(d);
    outputWidth = (int)(sliceDimension.x * _imageResolution);
    outputHeight = (int)(sliceDimension.y * _imageResolution);

    println("Output: w: " + outputWidth + " h: " + outputHeight);

    float sliceSize = d.z / slices;

    for (int i = 0; i < slices; i++)
    {
      println("generating slice " + i + "...");

      ExportImage img = createExportImage(exportType, round(mm(outputWidth)), round(mm(outputHeight)));

      float z = (exporter.flipAxis ? d.x : d.z);

      float startSlice = sliceSize * i + (z * -0.5);
      float endSlice = sliceSize * (i + 1) + (z * -0.5);

      img.beginDraw();
      int pointCount = createSlice(img, startSlice, endSlice);
      img.endDraw();

      println("exporting slice " + i + "(" + pointCount + " pts)...");
      img.save(filePath + "slice_" + i + "." + img.getExtension());

      exportProgress = (float)i / slices;
    }

    exportProgress = 1.0;
    println("cloud exported");
    exporter.exporting = false;
  }

  private int createSlice(ExportImage g, float sliceStart, float sliceEnd)
  {
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);
    PVector t = PVector.div(cloud.translation, cloud.scale);

    int pointCounter = 0;

    // go through all vertices and draw them if relevant
    for (int i = 0; i < cloud.vertices.getVertexCount(); i += pointCloudSamples)
    {
      PVector v = cloud.vertices.getVertex(i);

      // apply translation
      v.add(t);

      // skip if not relevant
      float z = (exporter.flipAxis ? v.x : v.z);
      if (!(z >= sliceStart && z <= sliceEnd)) continue;

      // map and draw point
      float mx = (exporter.flipAxis ? 
        map(v.z, d.z * -0.5, d.z * 0.5, 0, px(g.w)): 
        map(v.x, d.x * -0.5, d.x * 0.5, 0, px(g.w)));
      float my = map(v.y, d.y * -0.5, d.y * 0.5, 0, px(g.h));

      g.drawPoint(mm(mx), mm(my), mm(pointRadius * _imageResolution));
      pointCounter++;
    }

    return pointCounter;
  }

  public void render(PGraphics g)
  {
    PVector d = pointCloud.dimensions;
    float z = (exporter.flipAxis ? d.x : d.z);
    float sliceSize = z / slices;

    for (int i = 0; i < slices; i++)
    { 
      g.push();

      if (exporter.flipAxis) {
        g.translate(-0.5 * z + (sliceSize * .5) + (sliceSize * i), 0, 0);
      } else {
        g.translate(0, 0, -0.5 * z + (sliceSize * .5) + (sliceSize * i));
      }

      // draw sample box
      g.noFill();
      g.strokeWeight(2);
      g.stroke(100, 100, 255);

      if (exporter.flipAxis) {
        g.box(sliceSize, d.y, d.z);
      } else {
        g.box(d.x, d.y, sliceSize);
      }

      g.pop();
    }
  }
}
