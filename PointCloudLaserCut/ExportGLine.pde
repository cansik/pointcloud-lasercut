class ExportGLine extends ExportGCode {

  public ExportGLine(int w, int h) {
    super(w, h);
  }

  ArrayList<CloudPoint> points = new ArrayList<CloudPoint>();

  String getExtension() {
    return "ncline";
  }

  void beginDraw() {
    super.beginDraw();
  }

  void drawPoint(float x, float y, float diameter) {
    points.add(new CloudPoint(x, y));
  }

  void endDraw() { 
    drawLine();
    moveRapidZ(retractHeight);
    programmEnd();
  }

  void drawLine() {
    if (points.isEmpty()) return;

    CloudPoint point = points.get(0);
    moveRapidXY(point.x, point.y);
    moveRapidZ(pointDepth);

    while (point != null) {
      point.used = true;

      CloudPoint nearest = findNearest(point);
      if (nearest == null) break;

      // draw line
      // todo: use line jump if distance is too long
      float distance = PVector.dist(point, nearest);

      // larger than 30 mm
      boolean retract = distance > 30;

      if (retract) {
        moveRapidZ(retractHeight);
      }

      moveRapidXY(nearest.x, nearest.y);

      if (retract) {
        moveRapidZ(pointDepth);
      }

      point = nearest;
    }

    moveRapidZ(retractHeight);
  }

  CloudPoint findNearest(CloudPoint point) {
    CloudPoint nearestPoint = null;
    float distance = Float.MAX_VALUE;

    for (CloudPoint p : points) {
      if (p.used) continue;

      float d = PVector.dist(point, p);
      if (d < distance) {
        distance = d;
        nearestPoint = p;
      }
    }

    return nearestPoint;
  }
}

class CloudPoint extends PVector {
  boolean used = false;

  public CloudPoint(float x, float y) {
    super(x, y);
  }
}
