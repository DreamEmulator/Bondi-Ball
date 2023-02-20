float sun(vec2 uv, float time)
{
  float r = 0.9;
  float val = smoothstep(r, r-0.01, length(uv));
  float bloom = smoothstep(1.0, 0.0, length(uv));
  float cut = 5.0 * sin((uv.y + time * 0.2 * (1.02)) * 60.0)
    + clamp((uv.y+0.15) * 10.0, -6.0, 6.0);
  cut = clamp(cut, 0.0, 1.0);
  return clamp(val * cut, 0.0, 1.0) + bloom * 0.6;
}

void main()
{
  vec2 uv = (2.0 * (v_tex_coord * u_sprite_size.x) - u_sprite_size.x) / u_sprite_size.x;

  vec3 col = vec3(1.0, 0.4, 0.4);
  float sunVal = sun(uv, u_time);
  col = mix(col, vec3(1.0, 0.85, 0.3), uv.y * 2.0 + 0.2);
  col = mix(vec3(0.0, 0.0, 0.0), col, sunVal);

  gl_FragColor = vec4(col, 1.0);
}
