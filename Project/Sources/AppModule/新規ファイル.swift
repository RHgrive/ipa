import SwiftUI
import Highlightr

struct IconBadge: View {
    let icon: String
    let title: String
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 36, height: 36)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.black.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Color.accentColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(
            htmlText: .constant("<html><body><h1>Preview</h1></body></html>"),
            fileName: .constant("Preview.html")
        )
    }
}

struct CustomAlert: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
            
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("OK") {
                withAnimation {
                    isShowing = false
                }
            }
            .buttonStyle(PillButtonStyle())
        }
        .padding()
        .frame(width: 260)
        .background(BlurView(style: .systemThickMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isShowing = false
            }
        }
    }
}

struct FileBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        FileBrowserView()
    }
}

struct HighlightrTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var fontSize: CGFloat
    @Binding var theme: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        textView.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let currentText = uiView.text
        if currentText != text {
            uiView.text = text
            highlightText(uiView, skipCursorUpdate: currentText?.count == text.count)
        }
        uiView.font = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }
    
    private func highlightText(_ uiView: UITextView, skipCursorUpdate: Bool = false) {
        let currentText = text
        let selectedRange = uiView.selectedRange
        let contentOffset = uiView.contentOffset
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let highlightr = Highlightr() else { return }
            highlightr.setTheme(to: self.theme)
            highlightr.theme.setCodeFont(UIFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular))
            
            let highlightedText = highlightr.highlight(currentText, as: "html")
            
            DispatchQueue.main.async {
                guard uiView.text == currentText else { return }
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                
                if let highlightedText = highlightedText {
                    uiView.attributedText = highlightedText
                    if !skipCursorUpdate {
                        uiView.selectedRange = selectedRange
                    }
                }
                
                uiView.setContentOffset(contentOffset, animated: false)
                CATransaction.commit()
            }
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: HighlightrTextView
        private var workItem: DispatchWorkItem?
        
        init(_ parent: HighlightrTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            workItem?.cancel()
            let newWorkItem = DispatchWorkItem { [weak self] in
                self?.parent.highlightText(textView)
            }
            workItem = newWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: newWorkItem)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
        }
    }
}
