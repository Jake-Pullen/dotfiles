#!/bin/bash

# Redirect the output to /dev/null to suppress any output if all is good!
omarchy-webapp-remove "HEY" 2>/dev/null || true
omarchy-webapp-remove "Basecamp" 2>/dev/null || true
omarchy-webapp-remove "Google Photos" 2>/dev/null || true
omarchy-webapp-remove "Google Messages" 2>/dev/null || true
omarchy-webapp-remove "Figma" 2>/dev/null || true
omarchy-webapp-remove "Zoom" 2>/dev/null || true
omarchy-webapp-remove "Fizzy" 2>/dev/null || true

omarchy-pkg-drop signal-desktop 2>/dev/null || true

rm -rf ~/Work/tries 2>/dev/null || true
