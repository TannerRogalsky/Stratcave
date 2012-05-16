#define MAXBALLS %d
extern vec2[MAXBALLS] balls;
extern number[MAXBALLS] radii;
extern vec2[MAXBALLS] delta_to_target;
extern number num_balls;
extern number num_flashlights;

number circle(vec2 x, number radius){
  x /= radius;

  return 1.0 / dot(x, x);
}

// Suppose the torch lies at O (the apex of the cone) and the point being rendered is at P.
// Let D be a unit-vector in the direction the torch is shining.
number flashlight(vec2 O, vec2 P, vec2 delta_to_target){
  // Constants and parameters
  const number PI = 3.141592f;
  const number fov = 3.141592f / 4;
  const number ang_falloff = 0.5f;
  const number far_attenuation = 13.0f;
  const number far_apex_power = 10.0f;
  const number near_plane = 1.5f;
  const number near_gradient = 0.9f;

  vec2 D = normalize(delta_to_target);

  // proof of concept: full light spread on mouseover player
  // vec2 dtm = delta_to_target;
  // if((abs(dtm[0]) < 10) && (abs(dtm[1]) < 10)){
  //   dtm = vec2(0,0);
  // }
  // vec2 D = normalize(dtm);
    
  vec2 I = P - O;
  number dist = length(I);
  I = normalize(I);

  // Resolve angle
  number s = dot(I, D);

  // Scale and clamp for view-angle
  number a = acos(s) * (PI / fov);
  a = clamp(a, 0, PI / 2);
  s = cos(a);

  // Scale in the logarithmic domain to adjust angular attenuation
  s = pow(s, ang_falloff);
  
  // Attenuate far
  s *= 1 - pow(1 - far_attenuation / (dist + far_attenuation), far_apex_power);

  // Attentate near
  number n = dist * near_gradient - near_plane;
  n = clamp(n, 0, 1);
  s *= n;

  // return vec4(s, s, s, 1);
  return s; 
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){
  // you can reverse the gradient direction by changing p to 0 and the for loop to increment
  number p = 1.0;
  for (int i = 0; i < num_balls; ++i){
    p -= circle(pc - balls[i], radii[i]);
  }

  for (int i = 0; i < num_flashlights; ++i)
  {
    p -= flashlight(balls[i], pc, delta_to_target[i]);
  }

  // putting a ceiling on the next line makes discrete levels
  // leaving it off makes a smooth gradient
  p = p * 6.0; // size again
  p /= 5.0; // the number of radius levels

  return vec4(0, 0, 0, p);
}
