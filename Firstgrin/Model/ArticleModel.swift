//
//  ArticleModel.swift
//  Firstgrin
//
//  Created by Sazza on 7/9/22.
//

import Foundation

// MARK: - Articles
struct ArticleModel:Identifiable, Codable {
    let id = UUID().uuidString
    let sections: [Sections]?
}

// MARK: - Section
struct Sections: Codable {
    let sectionName, id: String?
    let articleItems: [ArticleItem]?

    enum CodingKeys: String, CodingKey {
        case sectionName = "section_name"
        case id
        case articleItems = "article_items"
    }
}

// MARK: - ArticleItem
struct ArticleItem:Identifiable, Codable {
    let id = UUID().uuidString
    let itemThumbnail, itemTitle, itemDescription: String?

    enum CodingKeys: String, CodingKey {
        case itemThumbnail = "item_thumbnail"
        case itemTitle = "item_title"
        case itemDescription = "item_description"
    }
}

