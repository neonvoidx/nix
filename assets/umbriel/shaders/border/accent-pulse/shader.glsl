// Accent pulse tuned for dark backgrounds: a tight, low-amplitude additive
// ring that fades into the surface instead of washing a wide halo across it.
vec4 border(vec2 uv) {
    float d = max(umbriel_border_distance(uv), 0.0);
    float ring = umbriel_sample(uv).a;
    float angle = atan(uv.y - 0.5, uv.x - 0.5);
    float wave = 0.5 + 0.5 * sin(angle * 3.0 - umbriel_time * 2.0);
    vec4 tint = umbriel_palette_count > 0 ? umbriel_palette_at(0.0) : vec4(0.48, 0.64, 1.0, 1.0);
    float falloff = exp(-d / 6.0);
    float glow = falloff * (0.25 + 0.75 * wave);
    vec4 native = umbriel_sample(uv);
    return native + tint * glow * max(ring, 0.5 * falloff) * 0.45;
}