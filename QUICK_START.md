# Quick Start: Fix "File Not Found" Errors

## The Problem
```
fatal error: 'FrameRepository.h' file not found
```

## The Solution (5 Minutes)

### Step 1: Open Xcode
```
Double-click: VideoFrames.xcodeproj
```

### Step 2: Add Models Folder
1. Right-click `PicFrames` in Project Navigator
2. Click **"Add Files to VideoFrames..."**
3. Select `PicFrames/Models/` folder
4. ✅ Check "Create groups"
5. ✅ Check "VideoFrames" target
6. Click "Add"

### Step 3: Add Repositories Folder
1. Right-click `PicFrames` in Project Navigator
2. Click **"Add Files to VideoFrames..."**
3. Select `PicFrames/Repositories/` folder
4. ✅ Check "Create groups"
5. ✅ Check "VideoFrames" target
6. Click "Add"

### Step 4: Build
```
Press: ⌘+B
```

**Done!** 🎉

---

## Files Being Added

### Models (4 files):
- PhotoInfo.h/m - Photo layout data
- ImageInfo.h/m - Image transform data

### Repositories (6 files):
- Repository.h/m - Base repository
- SessionRepository.h/m - Session data access
- FrameRepository.h/m - Frame data access

---

## Verification

After adding, you should see:

```
PicFrames/
├── Models/
│   ├── PhotoInfo.h ✅
│   ├── PhotoInfo.m ✅
│   ├── ImageInfo.h ✅
│   └── ImageInfo.m ✅
└── Repositories/
    ├── Repository.h ✅
    ├── Repository.m ✅
    ├── SessionRepository.h ✅
    ├── SessionRepository.m ✅
    ├── FrameRepository.h ✅
    └── FrameRepository.m ✅
```

All files should be in **black text** (not red).

---

## Still Getting Errors?

### Check Target Membership:
1. Select each file
2. Press ⌥⌘1 (File Inspector)
3. Verify "VideoFrames" is checked under "Target Membership"

### Clean and Rebuild:
```
⇧⌘K (Clean Build Folder)
⌘+B (Build)
```

---

## Need More Help?

See detailed guides:
- **XCODE_FILES_CHECKLIST.md** - Complete checklist
- **XCODE_PROJECT_SETUP.md** - Step-by-step guide with troubleshooting

---

**The files exist in git - you just need to tell Xcode about them!**
