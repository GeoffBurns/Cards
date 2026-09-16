# Copilot Instructions

## Platforms

This project targets iOS and macOS.

Prefer APIs available on both platforms unless platform-specific
functionality is explicitly required.

## Swift

Use modern Swift concurrency.
Prefer SwiftUI where appropriate.
Keep views small and composable.

## Images

Card artwork is supplied as image assets.
Do not duplicate image data unnecessarily.

## Architecture

Keep card data separate from presentation.
Prefer immutable models and value types.

## Metal

Metal shaders should be used where they provide a meaningful
performance benefit, particularly for placeholder rendering.
