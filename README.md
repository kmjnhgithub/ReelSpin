ReelSpinDemo
├── App                ← App lifecycle / 入口
│   ├── AppDelegate.swift
│
├── Model              ← 資料結構 (Decodable / CoreData ... )
│   └── Movie.swif  │

├── Services           ← 網路層、API 包裝、資料存取
│   └── MovieService.swift
│
├── View               ← 純視覺元件 (不含商業邏輯)
│   └── CircleStrokeView.swift
│
├── Controller         ← UIViewController & 其衍生 (含 UI 邏輯)
│   └── MoviesViewController.swift
│
├── Resources          ← .xcassets、字體、Localizable.strings…
│   ├── Assets.xcassets
│   └── LaunchScreen.storyboard (如使用)
│
└── Supporting Files   ← Info.plist、Build Settings 自動生成檔


  
