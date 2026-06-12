//
//  WebView.swift
//  Donmani
//
//  Created by 문종식 on 2/18/25.
//

import SwiftUI
import WebKit
import Domain

struct InnerWebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: url))
    }
}

private struct WebSheetModifier: ViewModifier {
    @Binding var urlString: String?

    func body(content: Content) -> some View {
        content.sheet(
            isPresented: Binding(
                get: { urlString != nil },
                set: { isPresented in
                    if !isPresented {
                        urlString = nil
                    }
                }
            )
        ) {
            if let urlString {
                InnerWebView(urlString: urlString)
            }
        }
    }
}

extension View {
    func webSheet(url: Binding<String?>) -> some View {
        modifier(WebSheetModifier(urlString: url))
    }
}
