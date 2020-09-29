//
//  HardcodedConversationData.swift
//  T-Chat
//
//  Created by Дмитрий on 29.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import Foundation

func getHardcodedConversationData() -> [MessageCellModel] {
    return [
        MessageCellModel(
            text: "Привет!",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Здоров!",
            isIncomingMessage: true),
        MessageCellModel(
            text: "Как на счёт побегать в Крылатском?",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Я десятку планирую сгонять",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Давай! Отличная идея)",
            isIncomingMessage: true),
        MessageCellModel(
            text: "Хорошо, тогда я собираюсь и выхожу!",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Телефон с собой не беру",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Встречаемся у Зар",
            isIncomingMessage: false),
        MessageCellModel(
            text: "Ок",
            isIncomingMessage: true)
    ]
}
