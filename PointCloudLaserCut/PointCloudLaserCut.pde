import peasy.PeasyCam; //<>//

PeasyCam cam;

PointCloudVisualizer visusalizer;
PointCloud pointCloud;

String pointCloudFile = "";
float startDepth = 400;

LaserCutExporter exporter;

PreviewVisualizer previewVisualizer;
boolean previewMode = false;

void setup()
{
  size(1280, 720, P3D);
  pixelDensity(2);

  surface.setTitle("Point Cloud Slicer");

  // set default arguments
  pointCloudFile = sketchPath("data/forest-3-highres_filtered_small.ply");

  // change clipping
  perspective(PI/3.0, (float)width/height, 0.1, 100000);

  // setup camera
  cam = new PeasyCam(this, 0, 0, 0, startDepth);
  cam.setSuppressRollRotationMode();

  // setup renderer
  visusalizer = new PointCloudVisualizer(this);
  previewVisualizer = new PreviewVisualizer(this);

  // load pointcloud
  pointCloud = new PointCloud();
  pointCloud.load(pointCloudFile);

  pointCloud.normalizeCloud(width, height, startDepth);

  exporter = new LaserCutExporter(pointCloud);

  setupUI();
}

void draw()
{
  background(0);

  if (previewMode) {
    previewVisualizer.render(this.g);
  } else
  {
    visusalizer.render(this.g, pointCloud);
    exporter.render(this.g);
    showGuides();
  }

  if (exporter.exporting)
  {
    showExporting();
  }

  showInfo();
}

void showExporting() {
  cam.beginHUD();
  fill(55, 150);
  noStroke();
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  textSize(20);

  fill(255);
  text("exporting " + round(exporter.exportProgress * 100) + "%", width / 2, height / 2);

  // loader info
  noFill();
  stroke(255);
  strokeWeight(10.0);
  drawArc(2.0, 200, PI, HALF_PI);
  drawArc(5.0, 250, QUARTER_PI * 2, QUARTER_PI);
  drawArc(3.0, 300, PI * 1.5, HALF_PI);
  strokeWeight(1.0);
  cam.endHUD();
}

void drawArc(float speed, float radius, float start, float lenght)
{
  float delta = radians(frameCount % 360 * speed);
  arc(width / 2, height / 2, radius, radius, start + delta, start + lenght + delta, OPEN);
}

void showGuides()
{
  // draw debug box
  noFill();
  strokeWeight(2);
  stroke(255, 100, 100);
  PVector d = pointCloud.dimensions;
  box(d.x, d.y, d.z);

  stroke(255, 100, 255);
  line(-0.5 * d.x, 0, 0, 0.5 * d.x, 0, 0);
  stroke(255, 255, 100);
  line(0, -0.5 * d.y, 0, 0, 0.5 * d.y, 0);
  stroke(100, 255, 255);
  line(0, 0, -0.5 * d.z, 0, 0, 0.5 * d.z);
}

void showInfo()
{
  String infoText = "Point Cloud Animation -  FPS " + nf(frameRate);
  surface.setTitle(infoText);

  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}
