# macOS 窗口镜像 Demo

✅ **实时镜像任意 App 窗口**，支持被遮挡后依然正常显示。

使用 ScreenCaptureKit 实现，性能优秀。

## 文件列表
- WindowMirrorDemoApp.swift
- ContentView.swift
- MirrorWindowController.swift

## 如何运行
1. 在 Xcode 中新建 macOS SwiftUI App 项目
2. 将以上三个文件复制到项目中
3. 在 Info.plist 添加屏幕录制权限：
   - Privacy - Camera Usage Description
   - Privacy - Microphone Usage Description
4. Command + R 运行
5. 允许屏幕录制权限
6. 点击按钮选择窗口即可看到浮动置顶镜像窗口！

支持 macOS 13+。

仓库地址：https://github.com/bzkata/macos-window-mirror-demo