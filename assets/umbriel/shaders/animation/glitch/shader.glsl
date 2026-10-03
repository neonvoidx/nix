// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Barrulus

// Theme colours affect artwork only; palette = false restores the original RGB.
// Keep the original shade and soften highlights without changing effect opacity.
vec3 theme_color(vec3 original, float position) {
    if (umbriel_palette_count <= 0) return original;
    float value = max(original.r, max(original.g, original.b));
    float white = min(original.r, min(original.g, original.b)) / max(value, 0.0001);
    return value * mix(umbriel_palette_at(position).rgb, vec3(1.0), white * 0.75);
}

float hash21(vec2 p) {
    vec3 q = fract(vec3(p.xyx) * 0.1031);
    q += dot(q, q.yzx + 33.33 + umbriel_random_seed.x);
    return fract((q.x + q.y) * q.z);
}

const float GLITCH_SHIFT = 0.28;

vec4 animation(vec2 uv) {
    float t = clamp(umbriel_linear_progress, 0.0, 1.0);
    bool opening = umbriel_direction > 0.0;
    if (t <= 0.0) return opening ? vec4(0.0) : umbriel_sample(uv);
    if (t >= 1.0) return opening ? umbriel_sample(uv) : vec4(0.0);

    float visible = opening ? t : 1.0 - t;
    float chaos = sin(visible * 3.14159);
    float tick = floor(t * 32.0);
    float band = floor(uv.y * 32.0);
    float jump = (hash21(vec2(band, tick)) - 0.5) * GLITCH_SHIFT * chaos;
    jump *= step(0.35, hash21(vec2(band + 71.0, tick)));
    vec2 source = uv + vec2(jump, (hash21(vec2(tick, 18.0)) - 0.5) * 0.025 * chaos);
    vec2 block = floor(uv * vec2(18.0, 12.0));
    float threshold = hash21(block + 13.0);
    float mask = smoothstep(threshold * 0.65, threshold * 0.65 + 0.35, visible);
    float split = 0.016 * chaos;
    vec4 base = umbriel_sample(source);
    vec4 red = umbriel_sample(source + vec2(split, 0.0));
    vec4 blue = umbriel_sample(source - vec2(split, 0.0));
    float alpha = max(base.a, max(red.a, blue.a));
    vec4 color = vec4(red.r, base.g, blue.b, alpha);
    float stripe = step(0.92, hash21(vec2(band, tick + 61.0))) * chaos;
    color.rgb = mix(color.rgb, theme_color(vec3(0.15, 1.0, 0.85), 0.25) * alpha, stripe * 0.7);
    return color * mask;
}
