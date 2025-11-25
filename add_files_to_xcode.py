#!/usr/bin/env python3
import uuid
import re

# Read the project file
with open('VideoFrames.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Files to add
new_files = [
    'PhotoActionViewController.swift',
    'AdjustOptionsViewController.swift',
    'SpeedViewController.swift',
    'TrimViewController.swift'
]

# Generate UUIDs for each file (2 per file: fileRef and buildFile)
file_refs = {}
build_files = {}
for filename in new_files:
    file_refs[filename] = uuid.uuid4().hex[:24].upper()
    build_files[filename] = uuid.uuid4().hex[:24].upper()

# Find an existing Swift file entry to use as template
existing_swift_pattern = r'(/\* OptionsViewController\.swift \*/ = {isa = PBXFileReference.*?};)'
match = re.search(existing_swift_pattern, content, re.DOTALL)

if not match:
    print("Could not find template Swift file entry")
    exit(1)

# Find the PBXFileReference section
file_ref_section_pattern = r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)'
file_ref_match = re.search(file_ref_section_pattern, content, re.DOTALL)

if file_ref_match:
    file_ref_section = file_ref_match.group(1)
    # Add new file references
    new_entries = ""
    for filename in new_files:
        new_entries += f"\t\t{file_refs[filename]} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = \"<group>\"; }};\n"

    # Insert before the End comment
    new_section = file_ref_section.replace('/* End PBXFileReference section */', new_entries + '\t\t/* End PBXFileReference section */')
    content = content.replace(file_ref_section, new_section)

# Find the PBXBuildFile section
build_file_section_pattern = r'(/\* Begin PBXBuildFile section \*/.*?/\* End PBXBuildFile section \*/)'
build_file_match = re.search(build_file_section_pattern, content, re.DOTALL)

if build_file_match:
    build_file_section = build_file_match.group(1)
    # Add new build file entries
    new_entries = ""
    for filename in new_files:
        new_entries += f"\t\t{build_files[filename]} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_refs[filename]} /* {filename} */; }};\n"

    # Insert before the End comment
    new_section = build_file_section.replace('/* End PBXBuildFile section */', new_entries + '\t\t/* End PBXBuildFile section */')
    content = content.replace(build_file_section, new_section)

# Find the main group (where files are listed) - find OptionsViewController.swift and add after it
options_vc_pattern = r'(\s+[A-F0-9]+ /\* OptionsViewController\.swift \*/,)'
options_match = re.search(options_vc_pattern, content)

if options_match:
    new_file_entries = options_match.group(1)
    for filename in new_files:
        new_file_entries += f"\n\t\t\t\t{file_refs[filename]} /* {filename} */,"
    content = content.replace(options_match.group(1), new_file_entries)

# Find the PBXSourcesBuildPhase section and add files to compile
sources_pattern = r'(/\* Begin PBXSourcesBuildPhase section \*/.*?files = \()(.*?)(\);.*?/\* End PBXSourcesBuildPhase section \*/)'
sources_match = re.search(sources_pattern, content, re.DOTALL)

if sources_match:
    files_list = sources_match.group(2)
    new_sources = ""
    for filename in new_files:
        new_sources += f"\n\t\t\t\t{build_files[filename]} /* {filename} in Sources */,"
    new_section = sources_match.group(1) + files_list + new_sources + sources_match.group(3)
    content = re.sub(sources_pattern, new_section, content, flags=re.DOTALL)

# Write back
with open('VideoFrames.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("Successfully added files to Xcode project!")
for filename in new_files:
    print(f"  - {filename}")
