#include <flutter/runtime_effect.glsl>

// Uniforms from Flutter
uniform vec2 uResolution;
uniform vec2 uMouse;
uniform float uEffectSize; // Controls the size of the lens effect (0.1 to 2.0 recommended)
uniform float uBlurIntensity; // Controls the blur strength (0.0 = no blur, 2.0 = heavy blur)
uniform float uDispersionStrength; // Add chromatic dispersion control
uniform sampler2D uTexture;

// Output
out vec4 fragColor;

void main() {
    // Get fragment coordinates
    vec2 fragCoord = FlutterFragCoord();

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / uResolution.xy;

    // Calculate distance from mouse/center
    vec2 center = uMouse.xy / uResolution.xy;
    vec2 m2 = (uv - center);

    // Create rounded box effect - size controlled by uEffectSize
    float effectRadius = uEffectSize * 0.5;
    float sizeMultiplier = 1.0 / (effectRadius * effectRadius);
    
    // Wide rectangle shape - adjust these multipliers for different proportions
    vec2 scaledM2 = m2 * vec2(0.1, 1.0); // Ratio: 0.2/0.5 = 0.4 (wider than tall)
    float wideRoundedBox = pow(abs(scaledM2.x * uResolution.x / uResolution.y), 4.0) +
                          pow(abs(scaledM2.y), 4.0);

    // Use wideRoundedBox for the liquid effect calculations
    float baseIntensity = 100.0 * sizeMultiplier;
    float rb1 = clamp((1.0 - wideRoundedBox * baseIntensity) * 8.0, 0.0, 1.0); // main lens
    
    fragColor = vec4(0.0);

    if (rb1 > 0.0) { 
        // Lens distortion effect - use wideRoundedBox for distortion too
        float distortionStrength = 50.0 * sizeMultiplier;
        vec2 lens = ((uv - 0.5) * (1.0 - wideRoundedBox * distortionStrength) + 0.5);

        // Enhanced chromatic dispersion calculation
        vec2 dir = normalize(m2);
        float dispersionScale = uDispersionStrength * 0.05;

        // Create edge mask based on distance from center - use wideRoundedBox
        float dispersionMask = smoothstep(0.3, 0.7, wideRoundedBox * baseIntensity);

        // Apply mask to dispersion offsets
        vec2 redOffset = dir * dispersionScale * 2.0 * dispersionMask;
        vec2 greenOffset = dir * dispersionScale * 1.0 * dispersionMask;
        vec2 blueOffset = dir * dispersionScale * -1.5 * dispersionMask;

        vec4 colorResult = vec4(0.0);

        // Blur sampling with enhanced chromatic dispersion
        if (uBlurIntensity > 0.0) {
            float blurRadius = uBlurIntensity / max(uResolution.x, uResolution.y);
            float total = 0.0;
            vec3 colorSum = vec3(0.0);
            for (float x = -2.0; x <= 2.0; x += 1.0) {
                for (float y = -2.0; y <= 2.0; y += 1.0) {
                    vec2 offset = vec2(x, y) * blurRadius;
                    colorSum.r += texture(uTexture, lens + offset + redOffset).r;
                    colorSum.g += texture(uTexture, lens + offset + greenOffset).g;
                    colorSum.b += texture(uTexture, lens + offset + blueOffset).b;
                    total += 1.0;
                }
            }
            colorResult = vec4(colorSum / total, 1.0);
        } else {
            // Enhanced single sample with directional offsets
            colorResult.r = texture(uTexture, lens + redOffset).r;
            colorResult.g = texture(uTexture, lens + greenOffset).g;
            colorResult.b = texture(uTexture, lens + blueOffset).b;
            colorResult.a = 1.0;
        }

        // Add lighting effects - removed rb3 since we removed outer effects
        float gradient = clamp((clamp(m2.y, 0.0, 0.2) + 0.1) / 2.0, 0.0, 1.0);

        // Combine all effects
        fragColor = mix(
            texture(uTexture, uv),
            colorResult,
            rb1
        );
        fragColor = clamp(fragColor + vec4(gradient * 0.2), 0.0, 1.0);

    } else {
        fragColor = texture(uTexture, uv);
    }
}