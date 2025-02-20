//
//  PrivacyPolicyView.swift
//  Donmani
//
//  Created by 문종식 on 2/17/25.
//

import SwiftUI
struct FeedbackView: View {
    let url = "__REDACTED_FEEDBACK_URL__"
    var body: some View {
        InnerWebView(urlString: url)
    }
}

#Preview {
    FeedbackView()
}

