//
//  ColorPalette.swift
//  DesignSystem
//
//  Created by 문종식 on 5/17/26.
//

import SwiftUI

public enum ColorPalette {
    public enum Semantic {
        public static let accessoryButton = Color("accessory_button", bundle: .designSystem)
        public static let backgroundTop = Color("background_top", bundle: .designSystem)
        public static let backgroundBottom = Color("background_bottom", bundle: .designSystem)
        public static let textGuide = Color("text_guide", bundle: .designSystem)
        public static let noticeDot = Color("notice_dot", bundle: .designSystem)
        public static let empty = Color("empty", bundle: .designSystem)
        public static let mainToolTipBackground = Color("main_tool_tip_background", bundle: .designSystem)
        public static let dailyFortuneBackground = Color("daily_fortune_background", bundle: .designSystem)
    }
    
    public enum Primary {
        public static let deepBlue10 = Color("deep_blue_10", bundle: .designSystem)
        public static let deepBlue20 = Color("deep_blue_20", bundle: .designSystem)
        public static let deepBlue30 = Color("deep_blue_30", bundle: .designSystem)
        public static let deepBlue40 = Color("deep_blue_40", bundle: .designSystem)
        public static let deepBlue50 = Color("deep_blue_50", bundle: .designSystem)
        public static let deepBlue60 = Color("deep_blue_60", bundle: .designSystem)
        public static let deepBlue70 = Color("deep_blue_70", bundle: .designSystem)
        public static let deepBlue80 = Color("deep_blue_80", bundle: .designSystem)
        public static let deepBlue90 = Color("deep_blue_90", bundle: .designSystem)
        public static let deepBlue95 = Color("deep_blue_95", bundle: .designSystem)
        public static let deepBlue99 = Color("deep_blue_99", bundle: .designSystem)
    }
    
    public enum Secondary {
        public static let purpleBlue10 = Color("purple_blue_10", bundle: .designSystem)
        public static let purpleBlue20 = Color("purple_blue_20", bundle: .designSystem)
        public static let purpleBlue30 = Color("purple_blue_30", bundle: .designSystem)
        public static let purpleBlue40 = Color("purple_blue_40", bundle: .designSystem)
        public static let purpleBlue50 = Color("purple_blue_50", bundle: .designSystem)
        public static let purpleBlue60 = Color("purple_blue_60", bundle: .designSystem)
        public static let purpleBlue70 = Color("purple_blue_70", bundle: .designSystem)
        public static let purpleBlue80 = Color("purple_blue_80", bundle: .designSystem)
        public static let purpleBlue90 = Color("purple_blue_90", bundle: .designSystem)
        public static let purpleBlue95 = Color("purple_blue_95", bundle: .designSystem)
        public static let purpleBlue99 = Color("purple_blue_99", bundle: .designSystem)
    }
    
    public enum Neutral {
        public static let gray10 = Color("gray_10", bundle: .designSystem)
        public static let gray20 = Color("gray_20", bundle: .designSystem)
        public static let gray30 = Color("gray_30", bundle: .designSystem)
        public static let gray40 = Color("gray_40", bundle: .designSystem)
        public static let gray50 = Color("gray_50", bundle: .designSystem)
        public static let gray60 = Color("gray_60", bundle: .designSystem)
        public static let gray70 = Color("gray_70", bundle: .designSystem)
        public static let gray80 = Color("gray_80", bundle: .designSystem)
        public static let gray90 = Color("gray_90", bundle: .designSystem)
        public static let gray95 = Color("gray_95", bundle: .designSystem)
        public static let gray99 = Color("gray_99", bundle: .designSystem)
    }
    
    public enum Category {
        public static let addiction = Color("addiction", bundle: .designSystem)
        public static let affection = Color("affection", bundle: .designSystem)
        public static let boastfulness = Color("boastfulness", bundle: .designSystem)
        public static let dignity = Color("dignity", bundle: .designSystem)
        public static let energy = Color("energy", bundle: .designSystem)
        public static let flex = Color("flex", bundle: .designSystem)
        public static let greed = Color("greed", bundle: .designSystem)
        public static let growth = Color("growth", bundle: .designSystem)
        public static let habit = Color("habit", bundle: .designSystem)
        public static let happiness = Color("happiness", bundle: .designSystem)
        public static let healing = Color("healing", bundle: .designSystem)
        public static let health = Color("health", bundle: .designSystem)
        public static let impulse = Color("impulse", bundle: .designSystem)
        public static let laziness = Color("laziness", bundle: .designSystem)
        public static let meaninglessness = Color("meaninglessness", bundle: .designSystem)
        public static let miss = Color("miss", bundle: .designSystem)
        public static let none = Color("none", bundle: .designSystem)
        public static let overfrugality = Color("overfrugality", bundle: .designSystem)
        public static let saving = Color("saving", bundle: .designSystem)
    }
    
    public static func color(named name: String) -> Color {
        Color(name, bundle: .designSystem)
    }
}
