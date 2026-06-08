//
//  DLottieView.swift
//  DesignSystem
//
//  Created by 문종식 on 6/2/25.
//

import SwiftUI
import Lottie

public struct DLottieView: UIViewRepresentable {
    public typealias UIViewType = UIView
    
    let name: String?
    let loopMode: LottieLoopMode
    let data: Data?
    
    public init(name: String, loopMode: LottieLoopMode) {
        self.name = name
        self.loopMode = loopMode
        self.data = nil
    }
    
    public init(data: Data, loopMode: LottieLoopMode) {
        self.name = nil
        self.loopMode = loopMode
        self.data = data
    }

    final class AnimationViewContainer: UIView {
        let animationView = LottieAnimationView()
    }

    public func makeUIView(context: Context) -> UIView {
        let container = AnimationViewContainer()
        var animation: LottieAnimation!
        
        if let name {
            let fileManager = FileManager.default
            let fileName = "\(name).json"
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: destinationURL.path) {
                animation = LottieAnimation.filepath(destinationURL.path)
            } else {
                animation = LottieAnimation.named(name, bundle: .designSystem)
            }
        }
        if let data {
            animation = try? LottieAnimation.from(data: data)
        }
        if let animation {
            container.animationView.animation = animation
        }
        container.animationView.loopMode = loopMode
        container.animationView.contentMode = .scaleAspectFill
        container.animationView.backgroundBehavior = .pauseAndRestore
        container.animationView.play()

        container.animationView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(container.animationView)
        NSLayoutConstraint.activate([
            container.animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            container.animationView.topAnchor.constraint(equalTo: container.topAnchor),
            container.animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        guard let uiView = uiView as? AnimationViewContainer else { return }
        
        var animation: LottieAnimation!
        if let name {
            let fileManager = FileManager.default
            let fileName = "\(name).json"
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: destinationURL.path) {
                animation = LottieAnimation.filepath(destinationURL.path)
            } else {
                animation = LottieAnimation.named(name, bundle: .designSystem)
            }
        }
        if let data {
            animation = try? LottieAnimation.from(data: data)
        }
        if animation == nil {
            return
        }
        uiView.animationView.animation = animation
        uiView.animationView.loopMode = loopMode
        uiView.animationView.play()
    }
}
