#define SCREEN_WIDTH %d
#define SCREEN_HEIGHT %d
#define NUM_BALLS 3
extern float time;

vec2[NUM_BALLS] balls;

float circle(vec2 x){
  x /= 40.0; // the size of the glow
  // numerator controls the size of the radii
  // plus portion of the denominator doesn't seem to do anything
  return 1.0 / dot(x, x);
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){

  balls[0] = vec2(sin(2 * time) * 120 + SCREEN_WIDTH / 3 * 2, cos(time) * 120 + SCREEN_HEIGHT / 3 * 2);
  balls[1] = vec2(sin(time) * 120 + SCREEN_WIDTH / 3 * 2, cos(2 * time) * 120 + SCREEN_HEIGHT / 3 * 2);
  balls[2] = vec2(sin(time) * (110 + sin(.01 * time) * 110)  + SCREEN_WIDTH / 3 * 2, cos(time) * (110 + sin(.01 * time) * 110)  + SCREEN_HEIGHT / 3 * 2);

  // you can reverse the gradient direction by changing p to 0 and the for loop to increment
  float p = 0;
  for (int i = 0; i < NUM_BALLS; ++i){
    p += circle(pc - balls[i]);
  }

  // putting a ceiling on the next line makes discrete levels
  // leaving it off makes a smooth gradient
  p = p * 6.0; // size again
  p /= 5.0; // the number of radius levels

  return vec4(p, p, p, p);
}
