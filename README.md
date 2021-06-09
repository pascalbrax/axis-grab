# axis-grab
BASH script to grab jpeg from an Axis camera every 2 seconds (and upload it somewhere else).

# Purpose
This script downloads jpeg images from the camera, stores them in a configurable folder, then uploads a lower resolution image to a remote host via SSH.

# Requires:
* Bash
* ImageMagick
* Wget
* ssh
