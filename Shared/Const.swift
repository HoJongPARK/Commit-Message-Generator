//
//  Const.swift
//  CommitGenerator
//
//  Created by 박종호 on 2022/02/28.
//

import Foundation

struct Const {

}

extension Const {
    struct URL {
        static let GITHUB_AUTHORIZE: String = "/oauth/authorize"
        static let GITHUB_ACCESS_TOKEN: String = "/oauth/access_token"
        static let GITHUB_AUTHENTICATE_BASE_URL: String = "https://github.com/login"
        static let URL_TYPE: String = "commitgenerator://"
        static let GITHUB_ISSUE: String = "/issues"
        static let GITHUB_USER: String = "/user"
        static let GITHUB_BASE_URL: String = "https://api.github.com"
        static let GITHUB_DEVICE_FLOW: String = "/device/code"
    }
}

extension Const {
    struct GitHub {
        static let CLIEND_ID: String = "5694f3a7b70d36a21953"
        static let CLIENT_SECRET: String = "3ea9b462a5bcc08c75e6664e43929c58a9738d3a"
    }
}

extension Const {
    struct Setting {
        static let AUTO_CLOSE: String = "autoClose"
        static let OPENING_AT_LOGIN: String = "openingAtLogin"
    }
}
