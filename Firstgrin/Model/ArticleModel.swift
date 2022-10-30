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
    let articleItems: [ArticleItem]?
    let id, sectionName: String

    enum CodingKeys: String, CodingKey {
        case articleItems = "article_items"
        case id
        case sectionName = "section_name"
    }
}

// MARK: - ArticleItem
struct ArticleItem: Codable,Identifiable {
    var id = UUID().uuidString
    let articleSections: [ArticleSection]
    let itemThumbnail, itemTitle: String?

    enum CodingKeys: String, CodingKey {
        case articleSections = "article_sections"
        case itemThumbnail = "item_thumbnail"
        case itemTitle = "item_title"
    }
}

// MARK: - ArticleSection
struct ArticleSection: Codable, Identifiable {
    var id = UUID().uuidString
    let articleSectionText: [ArticleSectionText]
    let articleSectionHeader: String?
    let articleSectionImage: String?

    enum CodingKeys: String, CodingKey {
        case articleSectionText = "article_section_text"
        case articleSectionHeader = "article_section_header"
        case articleSectionImage = "article_section_image"
    }
}

// MARK: - ArticleSectionText
struct ArticleSectionText: Codable, Identifiable {
    var id = UUID().uuidString
    let sectionText: String

    enum CodingKeys: String, CodingKey {
        case sectionText = "section_text"
    }
}

