import controlP5.*;
import java.util.Arrays;

ControlP5 cp5;
int uiHeight;

boolean isUIInitialized = false;

void setupUI()
{
  isUIInitialized = false;
  PFont font = createFont("Helvetica", 100f);

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  // change the original colors
  cp5.setColorForeground(color(255, 132, 124));
  cp5.setColorBackground(color(42, 54, 59));
  cp5.setFont(font, 14);
  cp5.setColorActive(color(255, 132, 124));

  int h = 10;
  cp5.addSlider("slices", 10, 150, 10, h, 100, 20)
    .setRange(1, 20)
    .setLabel("Slices")
    .setValue(exporter.slices)
    .plugTo(exporter);

  h += 25;
  cp5.addSlider("pointRadius", 10, 150, 10, h, 100, 20)
    .setRange(0.05, 1.0)
    .setLabel("Point Radius")
    .setNumberOfTickMarks(20)
    .showTickMarks(false)
    .setValue(exporter.pointRadius)
    .plugTo(exporter);

  h += 25;
  cp5.addSlider("outputMax", 10, 150, 10, h, 100, 20)
    .setRange(100, 1500)
    .setLabel("Max (mm)")
    .setNumberOfTickMarks(100)
    .showTickMarks(false)
    .setValue(exporter.outputMax)
    .plugTo(exporter);

  h += 30;
  cp5.addButton("generate")
    .setValue(100)
    .setPosition(10, h)
    .setSize(200, 22)
    .setCaptionLabel("Generate Slices")
    ;

  h += 30;
  cp5.addButton("export")
    .setValue(100)
    .setPosition(10, h)
    .setSize(200, 22)
    .setCaptionLabel("Export Slices")
    ;

  h += 40;
  cp5.addToggle("previewMode")
    .setPosition(10, h)
    .setSize(100, 20)
    .setCaptionLabel("Preview Mode");

  uiHeight = h + 100;

  isUIInitialized = true;
}

void generate(int value)
{
  if (!isUIInitialized) return;
  if (exporter.generating) return;

  exporter.generate();
}

void export(int value)
{
  if (!isUIInitialized) return;
  if (exporter.generating) return;

  exporter.export(sketchPath("export/"));
}

public String formatTime(long millis)
{
  long second = (millis / 1000) % 60;
  long minute = (millis / (1000 * 60)) % 60;
  long hour = (millis / (1000 * 60 * 60)) % 24;

  if (minute == 0 && hour == 0 && second == 0)
    return String.format("%02dms", millis);

  if (minute == 0 && hour == 0)
    return String.format("%02ds", second);

  if (hour == 0)
    return String.format("%02dm %02ds", minute, second);

  return String.format("%02dh %02dm %02ds", hour, minute, second);
}

void mousePressed() {

  // suppress cam on UI
  if (mouseX > 0 && mouseX < 250 && mouseY > 0 && mouseY < uiHeight) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}
