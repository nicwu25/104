//
//  JobResponse.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/11.
//

import Foundation

// MARK: - JobResponse
struct JobResponse: Codable {
    let data: JobData
    let status, code: String
    let success: Bool
    let err: Err?

    enum CodingKeys: String, CodingKey {
        case data = "DATA"
        case status = "STATUS"
        case code = "CODE"
        case success = "SUCCESS"
        case err = "ERR"
    }
}

// MARK: - JobData
struct JobData: Codable, Hashable {
    let recordCount, pageCount, page, pageSize: String
    let query: String
    let ad: AdList?
    let list: [Job]

    enum CodingKeys: String, CodingKey {
        case recordCount = "RECORD_COUNT"
        case pageCount = "PAGE_COUNT"
        case page = "PAGE"
        case pageSize = "PAGE_SIZE"
        case query = "QUERY"
        case ad = "AD"
        case list = "LIST"
    }
}

// MARK: - Ad
struct AdList: Codable, Hashable {
    let page, pageSize, pageCount, recordCount: String
    let index: [Int]
    let list: [Ad]

    enum CodingKeys: String, CodingKey {
        case page = "PAGE"
        case pageSize = "PAGE_SIZE"
        case pageCount = "PAGE_COUNT"
        case recordCount = "RECORD_COUNT"
        case index = "INDEX"
        case list = "LIST"
    }
}

// MARK: - AdList
struct Ad: Codable, Hashable {
    let id, image, source: String
    let viewAd, clickAd, clickNcc: String
    let words: [String]
    let ui: String
    let action: String
    let param: String
    let tag: String
    let isValidated: Bool

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case image = "IMAGE"
        case source = "SOURCE"
        case viewAd = "VIEW_AD"
        case clickAd = "CLICK_AD"
        case clickNcc = "CLICK_NCC"
        case words = "WORDS"
        case ui = "UI"
        case action = "ACTION"
        case param = "PARAM"
        case tag = "TAG"
        case isValidated = "IS_VALIDATED"
    }
}

// MARK: - JobList
struct Job: Codable, Hashable {
    let otherJobLink, otherJob, otherJobTitle: String
    let canSave, canExclude: String
    let metroNearby: String
    let metroDistance: Int
    let saved, applied, source, appearDateUTC, salary, period: String
    let jobExperience, jobAddrNoDescript: String
    let jobOn, jobno, custno, name, job: String

    enum CodingKeys: String, CodingKey {
        case otherJobLink = "OTHER_JOB_LINK"
        case otherJob = "OTHER_JOB"
        case otherJobTitle = "OTHER_JOB_TITLE"
        case canSave = "CAN_SAVE"
        case canExclude = "CAN_EXCLUDE"
        case metroNearby = "METRO_NEARBY"
        case metroDistance = "METRO_DISTANCE"
        case saved = "SAVED"
        case applied = "APPLIED"
        case source = "SOURCE"
        case appearDateUTC = "APPEAR_DATE_UTC"
        case salary = "SALARY"
        case period = "PERIOD"
        case jobExperience = "JOB_EXPERIENCE"
        case jobAddrNoDescript = "JOB_ADDR_NO_DESCRIPT"
        case jobOn = "JOB_ON"
        case jobno = "JOBNO"
        case custno = "CUSTNO"
        case name = "NAME"
        case job = "JOB"
    }
}

struct Err: Codable {
    let errCode, errMsg, errDetail, errAction: String
    let errActionParam, errNo: String

    enum CodingKeys: String, CodingKey {
        case errCode = "ERR_CODE"
        case errMsg = "ERR_MSG"
        case errDetail = "ERR_DETAIL"
        case errAction = "ERR_ACTION"
        case errActionParam = "ERR_ACTION_PARAM"
        case errNo = "ERR_NO"
    }
}
