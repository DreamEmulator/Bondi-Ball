
#define H(a) (cos(vec3(1.7, 2.4, 3.3)-((a)*6.3))*p+p)                // hue pallete
#define J(x) h((u-o*v)*v.y) * H((x)*t) * ((sin((x)*t*6.3)*p+p)+p)    // tile & color
#define Q o = round(u/v+f)-f; x = o.x; y = o.y*v.y; c += J(x*x+y*y); // gotta do this twice so it's here
float h(vec2 u) // hexagon
{
    u = abs(u);
    vec2 h = vec2(u.x/.866, u.y+u.x*.577);
    return max(0., 1.-max(h.x, h.y));
}
void main()
{
    vec3  c = vec3(.1);
    vec2  R = u_sprite_size.xy,
          v = vec2(1, 1.732),
          u, o;
    float t = u_time/120.,    // sec per int
          z = .05, // zoom
          p = .5, // using .5 a lot
          f = 0., // hex offset
          x, y, r;
    u = (v_tex_coord*u_sprite_size-R)/R.xy; // screen coords
    r = length(u);
    u *= 10./(1.-z); // apply scale & zoom
    Q // set 1
    f = p;
    Q // set 2
    c *= 2.1-r; // darken edges & brighten center
    gl_FragColor = vec4(c*c/(z+1.), 1);
}
