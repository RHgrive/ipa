import SwiftUI
import WebKit
import Highlightr

struct CardButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct NewFileOptionsView: View {
    @Binding var isPresented: Bool
    let onCreate: (String) -> Void
    
    let templates = [
        ("空のHTML", "<!DOCTYPE html>\n<html>\n<head>\n<title>New Document</title>\n<meta charset=\"utf-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n</head>\n<body>\n\n</body>\n</html>"),
        ("基本構造", "<!DOCTYPE html>\n<html>\n<head>\n<title>Document</title>\n<style>\nbody { font-family: Arial, sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }\n</style>\n</head>\n<body>\n<h1>Hello World</h1>\n<p>This is a new document.</p>\n</body>\n</html>"),
        ("レスポンシブ", "<!DOCTYPE html>\n<html>\n<head>\n<title>Responsive Page</title>\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<style>\n.container { width: 100%; max-width: 1200px; margin: 0 auto; padding: 20px; }\n@media (max-width: 768px) { .container { padding: 10px; } }\n</style>\n</head>\n<body>\n<div class=\"container\">\n<h1>Responsive Design</h1>\n</div>\n</body>\n</html>")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.vertical, 8)
            
            Text("テンプレートを選択")
                .font(.headline)
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(templates, id: \.0) { template in
                        Button(action: {
                            isPresented = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onCreate(template.1)
                            }
                        }) {
                            HStack {
                                Image(systemName: "doc.fill")
                                    .foregroundColor(.blue)
                                Text(template.0)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            Button("キャンセル") {
                withAnimation(.spring()) {
                    isPresented = false
                }
            }
            .foregroundColor(.secondary)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(BlurView(style: .systemThickMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: -5)
        .padding(.horizontal, 16)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 100 {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            }
        )
    }
}

struct SampleFileOptionsView: View {
    @Binding var isPresented: Bool
    let onSelect: (String) -> Void
    
    let samples = [
        ("基本ページ", "<!DOCTYPE html>\n<html>\n<head>\n<title>Sample Page</title>\n<style>\nbody { font-family: Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; }\nheader { background: #f0f0f0; padding: 20px; margin-bottom: 20px; }\n</style>\n</head>\n<body>\n<header>\n<h1>Welcome</h1>\n<p>This is a sample page</p>\n</header>\n<main>\n<section>\n<h2>Section Title</h2>\n<p>Sample content goes here.</p>\n</section>\n</main>\n</body>\n</html>"),
        ("フォーム", "<!DOCTYPE html>\n<html>\n<head>\n<title>Form Sample</title>\n<style>\nform { max-width: 500px; margin: 20px auto; }\nlabel { display: block; margin-bottom: 5px; }\ninput, textarea { width: 100%; padding: 8px; margin-bottom: 15px; border: 1px solid #ddd; }\n</style>\n</head>\n<body>\n<form>\n<h2>Contact Us</h2>\n<label for=\"name\">Name:</label>\n<input type=\"text\" id=\"name\" name=\"name\">\n\n<label for=\"email\">Email:</label>\n<input type=\"email\" id=\"email\" name=\"email\">\n\n<label for=\"message\">Message:</label>\n<textarea id=\"message\" name=\"message\" rows=\"4\"></textarea>\n\n<button type=\"submit\">Submit</button>\n</form>\n</body>\n</html>"),
        ("グリッドレイアウト", "<!DOCTYPE html>\n<html>\n<head>\n<title>Grid Layout</title>\n<style>\n.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; padding: 20px; }\n.item { background: #f0f0f0; padding: 20px; border-radius: 8px; }\n</style>\n</head>\n<body>\n<div class=\"grid\">\n<div class=\"item\">Item 1</div>\n<div class=\"item\">Item 2</div>\n<div class=\"item\">Item 3</div>\n<div class=\"item\">Item 4</div>\n</div>\n</body>\n</html>")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.vertical, 8)
            
            Text("サンプルを選択")
                .font(.headline)
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(samples, id: \.0) { sample in
                        Button(action: {
                            isPresented = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSelect(sample.1)
                            }
                        }) {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundColor(.yellow)
                                Text(sample.0)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            
            Button("キャンセル") {
                withAnimation(.spring()) {
                    isPresented = false
                }
            }
            .foregroundColor(.secondary)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(BlurView(style: .systemThickMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: -5)
        .padding(.horizontal, 16)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 100 {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            }
        )
    }
}

struct FileBrowserView: View {
    @State private var selectedFileContent: String = ""
    @State private var currentFileName: String = "Untitled"
    @State private var navigationPath = NavigationPath()
    @State private var isShowingNewFileOptions = false
    @State private var isShowingSampleOptions = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGray6), Color(.systemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text.fill.viewfinder")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.accentColor)
                            .symbolEffect(.pulse)
                        
                        Text("CodeEditor Pro")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("HTMLエディタ & プレビュー")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        CardButton(
                            icon: "plus.square.fill",
                            title: "新規ファイルを作成",
                            subtitle: "空のHTMLファイルから開始",
                            color: .blue,
                            action: {
                                withAnimation(.spring()) {
                                    isShowingNewFileOptions.toggle()
                                }
                            }
                        )
                        
                        CardButton(
                            icon: "folder.fill",
                            title: "サンプルを開く",
                            subtitle: "テンプレートから開始",
                            color: .green,
                            action: {
                                withAnimation(.spring()) {
                                    isShowingSampleOptions.toggle()
                                }
                            }
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        // 高速
                        IconBadge(icon: "bolt.fill", 
                                  title: "高速",
                                  gradient: [.yellow, .orange])
                        
                        IconBadge(icon: "eye.fill", 
                                  title: "リアルタイム",
                                  gradient: [.blue, .teal])
                        
                        IconBadge(icon: "slider.horizontal.3", 
                                  title: "カスタマイズ",
                                  gradient: [.purple, .indigo])
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    Text("v1.0.0")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
                
                if isShowingNewFileOptions {
                    NewFileOptionsView(
                        isPresented: $isShowingNewFileOptions,
                        onCreate: { template in
                            createNewFile(template: template)
                            currentFileName = "New File"
                            navigationPath.append("EditorView")
                        }
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .zIndex(1)
                }
                
                if isShowingSampleOptions {
                    SampleFileOptionsView(
                        isPresented: $isShowingSampleOptions,
                        onSelect: { sample in
                            openSampleFile(sample: sample)
                            currentFileName = "Sample"
                            navigationPath.append("EditorView")
                        }
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .zIndex(1)
                }
            }
            .navigationDestination(for: String.self) { _ in
                EditorView(htmlText: $selectedFileContent, fileName: $currentFileName)
            }
        }
        .tint(.indigo)
    }
    
    private func createNewFile(template: String) {
        selectedFileContent = template
    }
    
    private func openSampleFile(sample: String) {
        selectedFileContent = sample
    }
}

struct FeatureBadge: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

struct EditorView: View {
    @Binding var htmlText: String
    @Binding var fileName: String
    @State private var editorWidth: CGFloat = UIScreen.main.bounds.width / 2
    @State private var isDragging = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showFileActions = false
    @State private var showSettings = false
    @State private var fontSize: CGFloat = 14
    @State private var theme: String = "xcode"
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ヘッダー部分
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(fileName)
                            .font(.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                        
                        Text("HTML")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: { showFileActions.toggle() }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentColor)
                                .padding(8)
                        }
                        
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                                .padding(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(BlurView(style: .systemMaterial))
                .overlay(Divider(), alignment: .bottom)
                
                GeometryReader { geometry in
                    HStack(alignment: .top, spacing: 0) {
                        HighlightrTextView(
                            text: $htmlText,
                            fontSize: $fontSize,
                            theme: $theme
                        )
                        .frame(width: editorWidth)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 1)
                                .padding(.trailing, -1),
                            alignment: .trailing
                        )
                        
                        ZStack {
                            Rectangle()
                                .fill(isDragging ? Color.accentColor.opacity(0.1) : Color.clear)
                                .frame(width: 16)
                                .contentShape(Rectangle())
                            
                            Capsule()
                                .fill(isDragging ? Color.accentColor : Color.gray.opacity(0.5))
                                .frame(width: 3, height: 60)
                                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    let newWidth = editorWidth + value.translation.width
                                    editorWidth = min(max(newWidth, 200), geometry.size.width - 200)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        isDragging = false
                                    }
                                }
                        )
                        
                        WebView(html: htmlText)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                    .padding(.bottom, keyboardHeight) // キーボードの高さ分を余白として調整
                }
                
                // フッター
                HStack {
                    Text("HTML")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("UTF-8 \(htmlText.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .frame(height: 25)
                .background(Color(.systemGray6))
            }
            
            // オーバーレイメニューたち
            if showFileActions {
                FileActionMenu(
                    onSave: saveFile,
                    onShare: shareFile,
                    onClose: { showFileActions = false }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .zIndex(1)
            }
            
            if showSettings {
                SettingsMenu(
                    fontSize: $fontSize,
                    theme: $theme,
                    onClose: { showSettings = false }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .zIndex(1)
            }
            
            if showAlert {
                CustomAlert(message: alertMessage, isShowing: $showAlert)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    .zIndex(2)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = keyboardFrame.height / 100
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = 0
            }
        }
    }


    
    private func saveFile() {
        showFileActions = false
        alertMessage = "ファイルを保存しました"
        withAnimation {
            showAlert = true
        }
    }
    
    private func shareFile() {
        showFileActions = false
        alertMessage = "共有オプションを表示"
        withAnimation {
            showAlert = true
        }
    }
}

struct WebView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        webView.scrollView.backgroundColor = .systemBackground
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

struct FileActionMenu: View {
    let onSave: () -> Void
    let onShare: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                onSave()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down.fill")
                        .foregroundColor(.blue)
                    Text("保存")
                    Spacer()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: {
                onShare()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up.fill")
                        .foregroundColor(.green)
                    Text("共有")
                    Spacer()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Button(action: onClose) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                    Text("キャンセル")
                    Spacer()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .frame(width: 220)
        .background(BlurView(style: .systemThickMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .contentShape(Rectangle())
        .onTapGesture {
            onClose()
        }
    }
}

struct SettingsMenu: View {
    @Binding var fontSize: CGFloat
    @Binding var theme: String
    let onClose: () -> Void
    
    let themes = ["xcode", "atom-one-light", "github", "monokai", "solarized-dark"]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("設定")
                    .font(.headline)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("フォントサイズ: \(Int(fontSize))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Slider(value: $fontSize, in: 10...24, step: 1) {
                    Text("Font Size")
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("テーマ")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(themes, id: \.self) { themeName in
                            Button(action: {
                                theme = themeName
                            }) {
                                Text(themeName.capitalized.replacingOccurrences(of: "-", with: " "))
                                    .font(.caption)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(theme == themeName ? Color.accentColor : Color(.secondarySystemBackground))
                                    .foregroundColor(theme == themeName ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            
            Button("閉じる") {
                onClose()
            }
            .buttonStyle(PillButtonStyle())
            .padding(.top, 8)
        }
        .padding()
        .frame(width: 280)
        .background(BlurView(style: .systemThickMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

