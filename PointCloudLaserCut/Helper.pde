static final float MM_TO_PIXEL_RATIO = 0.3527778f;

public float mm(float wantedMM) {
  return wantedMM / MM_TO_PIXEL_RATIO;
}

public float px(float wantedPX) {
  return wantedPX * MM_TO_PIXEL_RATIO;
}
