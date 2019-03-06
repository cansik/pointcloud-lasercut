// utility methods
void updateMaxVector(PVector mv, PVector v)
{
  mv.x = mv.x > v.x ? mv.x : v.x;
  mv.y = mv.y > v.y ? mv.y : v.y;
  mv.z = mv.z > v.z ? mv.z : v.z;
}

void updateMinVector(PVector mv, PVector v)
{
  mv.x = mv.x < v.x ? mv.x : v.x;
  mv.y = mv.y < v.y ? mv.y : v.y;
  mv.z = mv.z < v.z ? mv.z : v.z;
}
