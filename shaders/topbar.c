#define SCREEN_HEIGHT %d
#define BAR_HEIGHT %d

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){
  float distance_from_bar_top = SCREEN_HEIGHT - pc[1];
  // if (distance_from_bar_top > 10){
    
  // }
  color.r = 255 * (distance_from_bar_top / BAR_HEIGHT);
  return color;
}
