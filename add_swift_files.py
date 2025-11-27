#!/usr/bin/env python3
import subprocess
import os

# Files to add
swift_files = [
    "VideoTrimmingSlider.swift",
    "VideoTrimmingViewModel.swift",
    "VideoTrimmingHostViewController.swift"
]

project_dir = "/Users/vaibhavtiwary/Desktop/VideoCollage_17th_Sept_V3_6_B6"
os.chdir(project_dir)

for swift_file in swift_files:
    file_path = os.path.join(project_dir, swift_file)
    if os.path.exists(file_path):
        print(f"Adding {swift_file} to Xcode project...")
        # We'll just print the file exists - actual addition needs to be done in Xcode
        print(f"  File exists at: {file_path}")
    else:
        print(f"ERROR: {swift_file} not found!")

print("\nNOTE: The Swift files exist but need to be added to the Xcode project.")
print("Please add these files to the VideoFrames target in Xcode:")
for f in swift_files:
    print(f"  - {f}")
