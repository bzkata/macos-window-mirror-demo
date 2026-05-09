import AppKit
import ScreenCaptureKit

class MirrorWindowController: NSWindowController, SCStreamOutput {
    private let stream: SCStream
    private let imageView = NSImageView()
    private let ciContext = CIContext()
    
    init(stream: SCStream, title: String) {
        let window = NSWindow(
            contentRect: NSRect(x: 300, y: 300, width: 1000, height: 620),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        window.title = "镜像 - \(title)"
        window.level = .floating
        window.isMovableByWindowBackground = true
        window.backgroundColor = .black
        
        self.stream = stream
        super.init(window: window)
        
        imageView.imageScaling = .scaleProportionallyUpOrDown
        window.contentView = imageView
        
        try? stream.addStreamOutput(self, type: .screen, sampleHandlerQueue: .main)
        try? stream.startCapture()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen, let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pb)
        if let cg = ciContext.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = NSImage(cgImage: cg, size: ciImage.extent.size)
            }
        }
    }
    
    func close() {
        try? stream.stopCapture()
        window?.close()
    }
}