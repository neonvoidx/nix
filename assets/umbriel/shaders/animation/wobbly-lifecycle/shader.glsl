// Adapted from shaders/animations/wobbly-lifecycle.glsl
// One elastic-sheet shader for opening (+1) and closing (-1).
const float WOBBLE_STRENGTH = 1.0;

vec4 animation(vec2 uv) {
    float p = clamp(umbriel_linear_progress, 0.0, 1.0);
    bool closing = umbriel_direction < 0.0;
    if (p <= 0.0) return closing ? umbriel_sample(uv) : vec4(0.0);
    if (p >= 1.0) return closing ? vec4(0.0) : umbriel_sample(uv);
    float visible = closing ? 1.0 - p : p;
    float reveal = smoothstep(0.0, 1.0, visible);
    float envelope = sin(3.14159265 * visible) * (1.0 - visible) * 1.55;
    float amplitude = envelope * clamp(WOBBLE_STRENGTH, 0.0, 1.5);
    float swing = sin(15.70796327 * visible);
    float counter = sin(15.70796327 * visible - 1.15);
    // Grow from a smaller, springy sheet, then settle perfectly into the window.
    vec2 zoom = mix(vec2(0.76, 0.68), vec2(1.0), reveal)
        - amplitude * vec2(0.10, 0.09);
    vec2 q = (uv - vec2(0.5, 0.5 + 0.045 * (1.0 - reveal))) / zoom;
    q.x -= amplitude * (0.038 * swing * cos(q.y * 5.2)
        + 0.020 * counter * sin(q.y * 6.0));
    q.y -= amplitude * (0.028 * counter * cos(q.x * 5.0)
        + 0.014 * swing * sin(q.x * 6.0));
    float opacity = smoothstep(0.0, 0.55, visible);
    return umbriel_sample(q + 0.5) * opacity;
}
