//
//  HardcodedConversationsList.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

func getHardcodedOnlineConversationList() -> [ConversationCellModel] {
    
    let date = Date(timeIntervalSinceNow: -86400)
    let hour: Double = 3600
    
    return [
        ConversationCellModel(
            name: "Alexander",
            message: "Hi there!",
            date: Date(timeInterval: -hour, since: date),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Ekaterina",
            message: "",
            date: Date(timeInterval: hour * 2, since: date),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Tatiana",
            message: "Ячейку, а не контроллер",
            date: Date(timeInterval: -hour * 8 - 180, since: date),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Natalya",
            message: "https://youtu.be/zvcj6iCc4tk?t=1364",
            date: Date(timeInterval: 8 * hour, since: date),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Дмитрий",
            message: "",
            date: Date(timeInterval: 12 * hour, since: date),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Nikita",
            message: "Hi! Everything ok?",
            date: Date(timeIntervalSinceNow: -39),
            isOnline: true,
            hasUnreadedMessages: true),
        ConversationCellModel(
            name: "Настя",
            message: "",
            date: date,
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Ильдар",
            message: "Привет! Чё как?",
            date: Date(timeIntervalSinceNow: -836),
            isOnline: true,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Ilya",
            message: "Shit happens...",
            date: Date(timeIntervalSinceNow: -10),
            isOnline: true,
            hasUnreadedMessages: true),
        ConversationCellModel(
            name: "Ekaterina",
            message: "Homework checked",
            date: Date(timeIntervalSinceNow: -5),
            isOnline: true,
            hasUnreadedMessages: true),
    ]
}

func getHardcodedOfflineConversationList() -> [ConversationCellModel] {
    
    let date = Date(timeIntervalSinceNow: -86400)
    let hour: Double = 3600
    
    return [
        ConversationCellModel(
            name: "Сергей",
            message: "Готов к выходным? Может на Селигер?",
            date: Date(timeInterval: -hour, since: date),
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Андрей",
            message: "Я вернулся из Чебоксар вчера.",
            date: Date(timeInterval: hour * 2, since: date),
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Владимир",
            message: "Новые рисунки в VK видел?",
            date: Date(timeInterval: -hour * 8 - 180, since: date),
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Natalya",
            message: "Привет! Как выходные провёл?",
            date: Date(timeInterval: 8 * hour, since: date),
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Дмитрий",
            message: "Ок, встречаемся у Зар, сбегаем десятку.",
            date: Date(timeInterval: 12 * hour, since: date),
            isOnline: false,
            hasUnreadedMessages: true),
        ConversationCellModel(
            name: "Женя",
            message: "Дим, заедешь на Майендорф за документами?",
            date: Date(timeIntervalSinceNow: -39),
            isOnline: false,
            hasUnreadedMessages: true),
        ConversationCellModel(
            name: "Настя",
            message: "Сейчас занята, отвечу позже",
            date: date,
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Олег",
            message: "Я на новую работу перешёл, поэтому не актуально",
            date: Date(timeIntervalSinceNow: -836),
            isOnline: false,
            hasUnreadedMessages: false),
        ConversationCellModel(
            name: "Ilya",
            message: "Да! Я там же в Архангельском живу.",
            date: Date(timeIntervalSinceNow: -10),
            isOnline: false,
            hasUnreadedMessages: true),
        ConversationCellModel(
            name: "Ekaterina",
            message: "Зимой планирую прилететь в Москву, на НГ.",
            date: Date(timeIntervalSinceNow: -5),
            isOnline: false,
            hasUnreadedMessages: true),
    ]
}

