#define NBALLS %d
extern vec2[NBALLS] balls;
extern vec2 delta_to_mouse;

float circle(vec2 x){
  x /= 40.0; // the size of the glow
  // numerator controls the size of the radii
  // plus portion of the denominator doesn't seem to do anything
  return 1.0 / dot(x, x);
}

// Suppose the torch lies at O (the apex of the cone) and the point being rendered is at P.
// Let D be a unit-vector in the direction the torch is shining.
float flashlight(vec2 O, vec2 P){
  // Constants and parameters
  const float PI = 3.141592f;
  const float fov = 3.141592f / 4;
  const float ang_falloff = 0.5f;
  const float far_attenuation = 13.0f;
  const float far_apex_power = 10.0f;
  const float near_plane = 10.5f;
  const float near_gradient = 0.9f;

  vec2 D = normalize(delta_to_mouse);
    
  vec2 I = P - O;
  float dist = length(I);
  I = normalize(I);

  // Resolve angle
  float s = dot(I, D);

  // Scale and clamp for view-angle
  float a = acos(s) * (PI / fov);
  a = clamp(a, 0, PI / 2);
  s = cos(a);

  // Scale in the logarithmic domain to adjust angular attenuation
  s = pow(s, ang_falloff);
  
  // Attenuate far
  s *= 1 - pow(1 - far_attenuation / (dist + far_attenuation), far_apex_power);

  // Attentate near
  float n = dist * near_gradient - near_plane;
  n = clamp(n, 0, 1);
  s *= n;

  // return vec4(s, s, s, 1);
  return s; 
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc){
  // you can reverse the gradient direction by changing p to 0 and the for loop to increment
  float p = 1.0;
  for (int i = 1; i < NBALLS; ++i){
    p -= circle(pc - balls[i]);
  }

  p -= flashlight(balls[0], pc);
  // putting a ceiling on the next line makes discrete levels
  // leaving it off makes a smooth gradient
  p = p * 6.0; // size again
  p /= 5.0; // the number of radius levels

  return vec4(0, 0, 0, p);
}
