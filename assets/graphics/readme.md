# Graphics Assets & Optimization

This directory contains the onboarding and instruction vector-style
illustrations used in the app's initial walkthrough sequence (`scan`, `check`,
and `share`).

To maintain peak app performance and keep the total bundle size minimal,
high-resolution source graphics are downscaled and encoded to lossy WebP format.

---

## Source Assets

| Screen Step               | Source File  | Compressed Asset | Target Dimensions |
|:--------------------------|:-------------|:-----------------|:------------------|
| **1. Scan Receipt**       | `scan.jpeg`  | `scan.webp`      | Max width 600px   |
| **2. Review & Correct**   | `check.jpeg` | `check.webp`     | Max width 600px   |
| **3. Distribute Receipt** | `share.jpeg` | `share.webp`     | Max width 600px   |

---

## Build & Optimization Workflow

If you update or replace any `.jpeg` or `.png` source assets in this directory,
run the following Terminal commands to prepare them for Flutter:

### Prerequisites

Install `sips` (built-in on macOS) and Google's official WebP encoder via
Homebrew:

```bash
brew install webp
````

```bash
for file in *.jpeg; do cwebp -q 80 "$file" -o "${file%.*}.webp"; done
```

https://www.iloveimg.com/
https://www.pixelcut.ai/ai-image-editor?tool=removeBackground