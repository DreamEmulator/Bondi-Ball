float Cir (vec2 uv, float r, bool blur, vec2 size) {
    float a = blur ? 0.01 : 0.;
    float b = blur ? 0.13 : 5./size.y;
    return smoothstep(a, b, length(uv)-r);
}

void main()
{
    vec2 fragCoord = v_tex_coord*u_sprite_size;

    vec2 uv = (fragCoord-.5*u_sprite_size.xy)/u_sprite_size.xy;
    vec2 t = vec2(sin(u_time*2.), cos(u_time*3.+cos(u_time*.25)))*.1;

    vec3 Col0 = vec3(.9);
    vec3 Col1 = vec3(.1+uv.y*2., .4+uv.x*-1.1, .8)*.828;
    vec3 Col2 = vec3(.86);

    float cir1 = Cir(uv-t, .2, false, u_sprite_size);
    float cir2 = Cir(uv+t, .2, false, u_sprite_size);
    float cir2B = Cir(uv+t, .15, true, u_sprite_size);

    vec3 col = mix(Col1+vec3(.3,.1,0.), Col2, cir2B);
    col = mix(col, Col0, cir1);
    col = mix(col, Col1, clamp(cir1-cir2, 0., 1.));
    gl_FragColor = vec4(col,1.0);
}
