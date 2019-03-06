import peasy.PeasyCam; //<>//

PeasyCam cam;

PointCloudVisualizer visusalizer;
PointCloud pointCloud;

String pointCloudFile = "";
float startDepth = 400;

LaserCutExporter exporter;

void setup()
{
  size(1280, 720, P3D);
  pixelDensity(2);

  surface.setTitle("Point Cloud Animation Creator");

  // set default arguments
  pointCloudFile = sketchPath("data/Tree_1m.ply");

  // change clipping
  perspective(PI/3.0, (float)width/height, 0.1, 100000);

  // setup camera
  cam = new PeasyCam(this, 0, 0, 0, startDepth);
  cam.setSuppressRollRotationMode();

  // setup renderer
  visusalizer = new PointCloudVisualizer(this);

  // load pointcloud
  pointCloud = new PointCloud();
  pointCloud.load(pointCloudFile);

  pointCloud.normalizeCloud(width, height, startDepth);

  exporter = new LaserCutExporter(pointCloud);

  setupUI();
}

void draw()
{
  visusalizer.render(this.g, pointCloud);

  exporter.render(this.g);
  showInfo();
}

void showInfo()
{
  String infoText = "Point Cloud Animation -  FPS " + nf(frameRate);
  surface.setTitle(infoText);

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

  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
}
