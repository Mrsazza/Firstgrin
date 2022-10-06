//
//  DoctorsListModel.swift
//  Firstgrin
//
//  Created by Sazza on 3/10/22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct DoctorsList: Codable {
    let doctor: [Doctor]?
}

// MARK: - Doctor
struct Doctor: Identifiable, Codable {
    var id = UUID().uuidString
    let npi, firstName, middleName, lastName: String?
    let age: Int?
    let gender: String?
    let ratingsCount: Int?
    let ratingsAvg: Double?
    let degrees: [String]?
    let specialties: [Specialty]?
    let languages: [String]?
    let educations: [EducationElement]?
    let insurances: [Insurance]?
    let providerTypes: [String]?
    let locations: [Location]?
    let onlineProfiles: [JSONAny]?
    let treatmentsPerformed: [TreatmentsPerformed]?

    enum CodingKeys: String, CodingKey {
        case npi
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case age, gender
        case ratingsCount = "ratings_count"
        case ratingsAvg = "ratings_avg"
        case degrees, specialties, languages, educations, insurances
        case providerTypes = "provider_types"
        case locations
        case onlineProfiles = "online_profiles"
        case treatmentsPerformed = "treatments_performed"
    }
}

// MARK: - EducationElement
struct EducationElement: Codable {
    let education: EducationEducation
    let type: JSONNull?
    let year: Int
}

// MARK: - EducationEducation
struct EducationEducation: Codable {
    let name, uuid: String
}

// MARK: - Insurance
struct Insurance: Codable {
    let uuid, carrierAssociation, carrierBrand, carrierName: String
    let state, planName, planType, metalLevel: String
    let displayName, network: String
    let confidence: Int

    enum CodingKeys: String, CodingKey {
        case uuid
        case carrierAssociation = "carrier_association"
        case carrierBrand = "carrier_brand"
        case carrierName = "carrier_name"
        case state
        case planName = "plan_name"
        case planType = "plan_type"
        case metalLevel = "metal_level"
        case displayName = "display_name"
        case network, confidence
    }
}

// MARK: - Location
struct Location: Codable {
    let uuid: String
    let name: JSONNull?
    let address: String
    let addressDetails: AddressDetails
    let latitude, longitude: Double
    let googleMapsLink: String
    let phoneNumbers: [PhoneNumber]
    let confidence: Int

    enum CodingKeys: String, CodingKey {
        case uuid, name, address
        case addressDetails = "address_details"
        case latitude, longitude
        case googleMapsLink = "google_maps_link"
        case phoneNumbers = "phone_numbers"
        case confidence
    }
}

// MARK: - AddressDetails
struct AddressDetails: Codable {
    let street, addressLine1, addressLine2, city: String
    let state, zip: String

    enum CodingKeys: String, CodingKey {
        case street
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city, state, zip
    }
}

// MARK: - PhoneNumber
struct PhoneNumber: Codable {
    let phone, details: String
}

// MARK: - Specialty
struct Specialty: Codable {
    let uuid, taxonomyCode, boardSpecialty, boardSubSpecialty: String
    let nonMdSpecialty, nonMdSubSpecialty: JSONNull?
    let providerName: String
    let colloquial: JSONNull?
    let taxonomy1, taxonomy2: String
    let taxonomy3: JSONNull?
    let display, providerType: String
    let isPrimary: Bool

    enum CodingKeys: String, CodingKey {
        case uuid
        case taxonomyCode = "taxonomy_code"
        case boardSpecialty = "board_specialty"
        case boardSubSpecialty = "board_sub_specialty"
        case nonMdSpecialty = "non_md_specialty"
        case nonMdSubSpecialty = "non_md_sub_specialty"
        case providerName = "provider_name"
        case colloquial
        case taxonomy1 = "taxonomy_1"
        case taxonomy2 = "taxonomy_2"
        case taxonomy3 = "taxonomy_3"
        case display
        case providerType = "provider_type"
        case isPrimary = "is_primary"
    }
}


// MARK: - TreatmentsPerformed
struct TreatmentsPerformed: Codable {
    let display, uuid: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
