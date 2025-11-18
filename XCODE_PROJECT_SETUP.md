# Xcode Project Setup Guide

## Issue
You're seeing this error:
```
fatal error: 'FrameRepository.h' file not found
```

This is because the new Repository Pattern files created in Phase 3A exist in the filesystem but haven't been added to your Xcode project yet.

## Files That Need to Be Added

The following files exist in your repository but are missing from your Xcode project:

### Models Folder (4 files)
```
PicFrames/Models/
├── PhotoInfo.h
├── PhotoInfo.m
├── ImageInfo.h
└── ImageInfo.m
```

### Repositories Folder (6 files)
```
PicFrames/Repositories/
├── Repository.h (base protocol)
├── Repository.m (base implementation)
├── SessionRepository.h
├── SessionRepository.m
├── FrameRepository.h
└── FrameRepository.m
```

**Total: 10 files need to be added to Xcode**

---

## Step-by-Step Instructions to Add Files to Xcode

### Option 1: Add Folders (Recommended - Faster)

1. **Open your Xcode project**
   - Open `VideoFrames.xcodeproj` in Xcode

2. **Locate the PicFrames group in Project Navigator**
   - In the left sidebar, find the `PicFrames` folder/group

3. **Add the Models folder:**
   - Right-click on `PicFrames` group
   - Select "Add Files to VideoFrames..."
   - Navigate to: `PicFrames/Models/`
   - **IMPORTANT:** Check these options:
     - ✅ "Copy items if needed" (optional, depends on your preference)
     - ✅ "Create groups" (NOT "Create folder references")
     - ✅ Make sure "VideoFrames" target is checked
   - Click "Add"

4. **Add the Repositories folder:**
   - Right-click on `PicFrames` group again
   - Select "Add Files to VideoFrames..."
   - Navigate to: `PicFrames/Repositories/`
   - **IMPORTANT:** Check these options:
     - ✅ "Copy items if needed" (optional)
     - ✅ "Create groups" (NOT "Create folder references")
     - ✅ Make sure "VideoFrames" target is checked
   - Click "Add"

5. **Verify the files were added:**
   - You should now see "Models" and "Repositories" groups under PicFrames
   - Each should contain their respective .h and .m files
   - Files should appear in **black text** (not red)

6. **Build the project:**
   - Press ⌘+B to build
   - The error should be resolved!

---

### Option 2: Add Files Individually (If Option 1 Doesn't Work)

If adding folders doesn't work, add each file individually:

1. **Open Xcode project**
2. **Right-click PicFrames group** → "Add Files to VideoFrames..."

3. **Add Model files one by one:**
   - Add `PicFrames/Models/PhotoInfo.h`
   - Add `PicFrames/Models/PhotoInfo.m`
   - Add `PicFrames/Models/ImageInfo.h`
   - Add `PicFrames/Models/ImageInfo.m`

   For each file:
   - ✅ Check "VideoFrames" target
   - ✅ Use "Create groups"

4. **Add Repository files one by one:**
   - Add `PicFrames/Repositories/Repository.h`
   - Add `PicFrames/Repositories/Repository.m`
   - Add `PicFrames/Repositories/SessionRepository.h`
   - Add `PicFrames/Repositories/SessionRepository.m`
   - Add `PicFrames/Repositories/FrameRepository.h`
   - Add `PicFrames/Repositories/FrameRepository.m`

   For each file:
   - ✅ Check "VideoFrames" target
   - ✅ Use "Create groups"

5. **Build:** Press ⌘+B

---

## Verification Steps

After adding the files, verify they're in the project:

1. **Check Project Navigator:**
   - PicFrames/
     - Models/
       - PhotoInfo.h ✅
       - PhotoInfo.m ✅
       - ImageInfo.h ✅
       - ImageInfo.m ✅
     - Repositories/
       - Repository.h ✅
       - Repository.m ✅
       - SessionRepository.h ✅
       - SessionRepository.m ✅
       - FrameRepository.h ✅
       - FrameRepository.m ✅

2. **Check Target Membership:**
   - Select any added file in Project Navigator
   - Open File Inspector (⌥⌘1)
   - Under "Target Membership", verify "VideoFrames" is checked ✅

3. **Build the project:**
   ```
   Product → Build (⌘+B)
   ```

   The error should be gone!

---

## Common Issues and Solutions

### Issue 1: Files appear in red
**Cause:** Xcode can't find the files at the expected path

**Solution:**
- Remove the red files from Xcode (right-click → Delete → "Remove Reference")
- Re-add them using "Add Files to VideoFrames..."
- Make sure you're pointing to the correct directory

### Issue 2: "Duplicate symbol" errors during build
**Cause:** Files were added to the project multiple times

**Solution:**
- Select the duplicate file in Project Navigator
- Open File Inspector (⌘⌥1)
- Under "Target Membership", uncheck all except "VideoFrames"
- Or remove the duplicate entirely

### Issue 3: Still getting "file not found" errors
**Cause:** Target membership not set correctly

**Solution:**
- Select each .h and .m file
- Open File Inspector
- Verify "VideoFrames" target is checked
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Build again (⌘+B)

### Issue 4: "Use of undeclared identifier" errors
**Cause:** Files added but not importing correctly

**Solution:**
- Verify import statements in your code:
  ```objc
  #import "ServiceContainer.h"
  #import "SessionRepository.h"
  #import "FrameRepository.h"
  #import "PhotoInfo.h"
  #import "ImageInfo.h"
  ```
- These should work without any path prefix since files are in groups

---

## Alternative: Command Line Script (Advanced)

If you prefer, you can use a Ruby script to add files to the Xcode project programmatically:

```ruby
require 'xcodeproj'

project_path = 'VideoFrames.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first

# Get or create PicFrames group
picframes_group = project.main_group['PicFrames'] || project.main_group.new_group('PicFrames')

# Add Models group
models_group = picframes_group.new_group('Models', 'PicFrames/Models')
['PhotoInfo.h', 'PhotoInfo.m', 'ImageInfo.h', 'ImageInfo.m'].each do |file|
  file_ref = models_group.new_file("PicFrames/Models/#{file}")
  target.add_file_references([file_ref]) if file.end_with?('.m')
end

# Add Repositories group
repos_group = picframes_group.new_group('Repositories', 'PicFrames/Repositories')
['Repository.h', 'Repository.m', 'SessionRepository.h', 'SessionRepository.m',
 'FrameRepository.h', 'FrameRepository.m'].each do |file|
  file_ref = repos_group.new_file("PicFrames/Repositories/#{file}")
  target.add_file_references([file_ref]) if file.end_with?('.m')
end

project.save
```

**To use this script:**
```bash
gem install xcodeproj
ruby add_files_to_xcode.rb
```

---

## After Adding Files Successfully

Once all files are added and the project builds:

1. **Run the app** to verify everything works
2. **Test session loading** to ensure repositories work correctly
3. **Check console** for any error messages from repositories

---

## Summary

**What to do:**
1. Open VideoFrames.xcodeproj in Xcode
2. Add `PicFrames/Models/` folder to project
3. Add `PicFrames/Repositories/` folder to project
4. Ensure "VideoFrames" target is checked for all files
5. Build (⌘+B)

**Expected result:**
- ✅ No "file not found" errors
- ✅ Project builds successfully
- ✅ All 10 new files visible in Xcode
- ✅ Modern Repository Pattern fully integrated

---

## Need Help?

If you continue to have issues:
1. Check that files exist in filesystem: `ls -la PicFrames/Models/ PicFrames/Repositories/`
2. Check Xcode project structure in Project Navigator
3. Clean build folder (⇧⌘K) and rebuild
4. Restart Xcode if necessary

The files are already in your git repository - you just need to tell Xcode about them!
