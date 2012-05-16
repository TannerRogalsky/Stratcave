#define SCREEN_HEIGHT %d
#define SCREEN_WIDTH %d
#define BAR_HEIGHT %d
#define BAR_WIDTH %d
#define GRADIENT_SIZE 30

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){
  number distance_from_bar_top = SCREEN_HEIGHT - GRADIENT_SIZE - pc[1];
  color.a = 1 - distance_from_bar_top / BAR_HEIGHT;

  // number distance_from_bar_left = SCREEN_WIDTH - GRADIENT_SIZE - pc[0];
  // color.a += 1 - distance_from_bar_left / BAR_WIDTH;
  return color;
}
