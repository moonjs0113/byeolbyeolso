//
//  Reward.swift
//  Donmani
//
//  Created by 문종식 on 5/18/25.
//

public struct Reward: Hashable {
    public enum ResourceType {
        case thumbnail
        case image
        case json
        case mp3
    }
    
    public let id: Int
    public let name: String
    public let imageUrl: String?
    public let jsonUrl: String?
    public let soundUrl: String?
    public let thumbnailUrl: String?
    public let category: RewardItemCategory
    public let newAcquiredFlag: Bool
    public let hidden: Bool
    public var hiddenRead: Bool = false
    public let resourceType: ResourceType
    
    public init(
        id: Int,
        name: String,
        imageUrl: String?,
        jsonUrl: String?,
        soundUrl: String?,
        thumbnailUrl: String?,
        category: RewardItemCategory,
        newAcquiredFlag: Bool,
        hidden: Bool,
        hiddenRead: Bool = false,
        resourceType: ResourceType
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.jsonUrl = jsonUrl
        self.soundUrl = soundUrl
        self.thumbnailUrl = thumbnailUrl
        self.category = category
        self.newAcquiredFlag = newAcquiredFlag
        self.hidden = hidden
        self.hiddenRead = hiddenRead
        self.resourceType = resourceType
    }
    
    public var key: String {
        "\(id)-\(category)"
    }
    
    public static let previewData: [Reward] = [
        Reward(id: 11, name: "하늘위 산책로 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .background,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 24, name: "구슬 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .bottle,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 29, name: "속삭이는 별빛", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_whispering_starlight", thumbnailUrl: nil, category: .sound,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 13, name: "소원의 유성", imageUrl: "lottie_reward_effect_wishing_meteor",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .effect,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 19, name: "달베개", imageUrl: "lottie_reward_decoration_moon_pillow",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
    ]
    
    public static let previewAllData: [Reward] = [
        Reward(id: 1, name: "기본 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .background,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 10, name: "보랏빛 오로라 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .background,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 9, name: "별이 흐르는 바다 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .background,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 11, name: "하늘위 산책로 배경", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .background,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        
        Reward(id: 4, name: "기본 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .bottle,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 24, name: "구슬 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .bottle,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        Reward(id: 25, name: "몽글 별통이", imageUrl: nil,
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .bottle,
               newAcquiredFlag: false, hidden: false, resourceType: .image),
        
        Reward(id: 5, name: "기본 배경음악", imageUrl: nil,
               jsonUrl: nil, soundUrl: "", thumbnailUrl: nil, category: .sound,
               newAcquiredFlag: false, hidden: false, resourceType: .mp3),
        Reward(id: 28, name: "별사탕의 하루", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_stardrop_day", thumbnailUrl: nil, category: .sound,
               newAcquiredFlag: false, hidden: false, resourceType: .mp3),
        Reward(id: 29, name: "속삭이는 별빛", imageUrl: nil,
               jsonUrl: nil, soundUrl: "reward_sound_whispering_starlight", thumbnailUrl: nil, category: .sound,
               newAcquiredFlag: false, hidden: false, resourceType: .mp3),
        
        Reward(id: 2, name: "기본 효과", imageUrl: nil,
               jsonUrl: nil, soundUrl: "", thumbnailUrl: nil, category: .effect,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 14, name: "하트잔잔", imageUrl: "lottie_reward_effect_heart_ripple",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .effect,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 12, name: "둥실둥실 방울", imageUrl: "lottie_reward_effect_floating_bubble",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .effect,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 13, name: "소원의 유성", imageUrl: "lottie_reward_effect_wishing_meteor",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .effect,
               newAcquiredFlag: false, hidden: false, resourceType: .json),

        Reward(id: 3, name: "기본 장식", imageUrl: "",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 23, name: "토비의 우주바캉스", imageUrl: "lottie",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 22, name: "토비호", imageUrl: "lottie_reward_decoration_toby_ship",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 21, name: "몽글몽글 열기구", imageUrl: "lottie_reward_decoration_fuzzy_balloon",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 19, name: "달베개", imageUrl: "lottie_reward_decoration_moon_pillow",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
        Reward(id: 20, name: "둥둥배", imageUrl: "lottie_reward_decoration_floating_boat",
               jsonUrl: nil, soundUrl: nil, thumbnailUrl: nil, category: .decoration,
               newAcquiredFlag: false, hidden: false, resourceType: .json),
    ]
}
