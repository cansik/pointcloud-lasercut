class PreviewVisualizer
{
  PApplet parent;

  ExportTexture[] textures = new ExportTexture[0];

  float plateThickness = 4;
  float plateSpace = 10;
  float plateWidth = 10;
  float plateHeight = 10;

  public PreviewVisualizer(PApplet parent)
  {
    this.parent = parent;
  }

  void generatePreview(PointCloud cloud)
  {
    println("generating preview...");
    textures = new ExportTexture[exporter.slices];
    PVector d = PVector.div(pointCloud.dimensions, cloud.scale);

    // calculate right size
    PVector sliceDimension = exporter.getSliceSize(d);
    plateWidth = sliceDimension.x;
    plateHeight = sliceDimension.y;

    println("Output: w: " + plateWidth + " h: " + plateHeight);

    float sliceSize = d.z / exporter.slices;

    // create images
    for (int i = 0; i < textures.length; i++) {
      ExportTexture tex = new ExportTexture(round(mm(plateWidth)), round(mm(plateHeight)));
      
      float z = (exporter.flipAxis ? d.x : d.z);

      float startSlice = sliceSize * i + (z * -0.5);
      float endSlice = sliceSize * (i + 1) + (z * -0.5);

      tex.beginDraw();
      int points = exporter.createSlice(tex, startSlice, endSlice);
      println("layer " + i + ": " + points + " pts");
      tex.endDraw();

      textures[i] = tex;
    }

    println("finished preview");
  }

  void render(PGraphics g)
  {
    g.push();

    for (int i = 0; i < textures.length; i++)
    {
      renderPlate(g, i, textures[i].getTexture());
    }

    // show debug
    //g.image(textures[2].getTexture(), 0, 0, 3000, 3000);
    g.pop();
  }

  private void renderPlate(PGraphics g, int index, PImage texture)
  {
    float centerPos = (index * (plateSpace + plateThickness)) - ((textures.length * (plateSpace + mm(plateThickness))) / 2f);
    float textZ = (mm(plateThickness) / 2f) + 0.01;

    g.push();
    g.translate(0, 0, centerPos);

    g.strokeWeight(0.5f);
    g.stroke(255, 100);
    g.fill(255, 3);

    // add acrylic glass
    g.hint(DISABLE_DEPTH_TEST);
    g.box(plateWidth, plateHeight, mm(plateThickness));

    // add engraving
    float htw = px(texture.width / 2f);
    float hth = px(texture.height / 2f);
    g.noFill();
    g.beginShape();
    g.texture(texture);
    g.vertex(-htw, -hth, textZ, 0, 0);
    g.vertex(htw, -hth, textZ, texture.width * 2, 0);
    g.vertex(htw, hth, textZ, texture.width * 2, texture.height * 2);
    g.vertex(-htw, hth, textZ, 0, texture.height * 2);
    g.endShape(CLOSE);  

    g.hint(ENABLE_DEPTH_TEST);

    g.pop();
  }
}
