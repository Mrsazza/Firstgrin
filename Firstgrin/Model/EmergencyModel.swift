//
//  EmergencyModel.swift
//  Firstgrin
//
//  Created by Sazza on 25/10/22.
//

import Foundation

// MARK: - Emergency
struct EmergencyModel: Codable {
    let emergencyRow: [EmergencyRow]?

    enum CodingKeys: String, CodingKey {
        case emergencyRow = "emergency_row"
    }
}

// MARK: - EmergencyRow
struct EmergencyRow: Codable, Identifiable {
    var id = UUID().uuidString
    let emergencyRowTitle: String?
    let emergencySection: [EmergencySection]?

    enum CodingKeys: String, CodingKey {
        case emergencyRowTitle = "emergency_row_title"
        case emergencySection = "emergency_section"
    }
}


// MARK: - EmergencySection
struct EmergencySection: Codable, Identifiable {
    var id = UUID().uuidString
    let emergencySectionTitle, emergencySectionImage, emergencySectionMessage: String?
    let emergencyArticles: [ArticleItem]?

    enum CodingKeys: String, CodingKey {
        case emergencySectionTitle = "emergency_section_title"
        case emergencySectionImage = "emergency_section_image"
        case emergencySectionMessage = "emergency_section_message"
        case emergencyArticles = "emergency_articles"
    }
}

//// MARK: - EmergencyArticle
//struct EmergencyArticle: Codable {
//    let articleSections: [ArticleSection]
//    let itemThumbnail, itemTitle: String
//
//    enum CodingKeys: String, CodingKey {
//        case articleSections = "article_sections"
//        case itemThumbnail = "item_thumbnail"
//        case itemTitle = "item_title"
//    }
//}
//
//// MARK: - ArticleSection
//struct ArticleSection: Codable {
//    let articleSectionText: [ArticleSectionText]
//    let articleSectionHeader, articleSectionImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case articleSectionText = "article_section_text"
//        case articleSectionHeader = "article_section_header"
//        case articleSectionImage = "article_section_image"
//    }
//}
//
//// MARK: - ArticleSectionText
//struct ArticleSectionText: Codable {
//    let sectionText: String
//
//    enum CodingKeys: String, CodingKey {
//        case sectionText = "section_text"
//    }
//}
