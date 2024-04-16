//
//  ModelClass.swift
//  Assignment_work
//
//  Created by vartika krishna on 16/04/24.
//

import Foundation


struct mainModelName:Decodable {
    let id, title, language: String
    let thumbnail: Thumbnail
    let mediaType: Double
    let coverageURL: URL
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

// MARK: - BackupDetails
struct BackupDetails:Decodable {
    let pdfLink: String
    let screenshotURL: String
}

// MARK: - Thumbnail
struct Thumbnail:Decodable {
    let id: String
    let version: Double
    let domain: String
    let basePath, key: String
    let qualities: [Double]
    let aspectRatio: Double
}
