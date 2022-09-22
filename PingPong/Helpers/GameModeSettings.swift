//
//  GameModeSettings.swift
//  PingPong
//
//  Created by Мария Хатунцева on 22.09.2022.
//

import Foundation

enum speedLevel {
    case low
    case high
}
enum enemyLevel {
    case slowRider
    case topPlayer
}

var currentSpeedLevel = speedLevel.low
var currentEnemyLevel = enemyLevel.slowRider
