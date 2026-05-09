import SwiftUI
import ScreenCaptureKit

struct ContentView: View {
    @State private var mirrorControllers: [MirrorWindowController] = []
    @State private var isSelecting = false
    @State private var status = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("macOS 窗口镜像 Demo").font(.largeTitle).bold()
            Text("点击按钮 → 选择任意窗口 → 创建始终置顶实时镜像").foregroundColor(.secondary)
            
            Button("选择窗口并创建镜像") {
                isSelecting = true
                status = "正在打开选择器..."
                Task { await createMirror() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(isSelecting)
            
            if !mirrorControllers.isEmpty {
                Text("当前镜像数量: \(mirrorControllers.count)")
            }
            
            Text(status).foregroundColor(.blue)
            
            Button("关闭所有镜像", role: .destructive) {
                mirrorControllers.forEach { $0.close() }
                mirrorControllers.removeAll()
            }
        }
        .frame(width: 480, height: 360)
    }
    
    private func createMirror() async {
        defer { isSelecting = false; status = "" }
        
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false)
            let windows = content.windows.filter { $0.isOnScreen && !($0.title ?? "").contains("镜像") }
            
            guard let win = windows.first else {
                status = "没有找到可用窗口"
                return
            }
            
            let filter = SCContentFilter(desktopIndependentWindow: win)
            let config = SCStreamConfiguration()
            config.minimumFrameInterval = CMTime(value: 1, timescale: 40)
            
            let stream = SCStream(filter: filter, configuration: config, delegate: nil)
            let controller = MirrorWindowController(stream: stream, title: win.title ?? "窗口")
            
            controller.showWindow(nil)
            mirrorControllers.append(controller)
            status = "镜像创建成功！"
            
        } catch {
            status = "错误: \(error.localizedDescription)"
        }
    }
}