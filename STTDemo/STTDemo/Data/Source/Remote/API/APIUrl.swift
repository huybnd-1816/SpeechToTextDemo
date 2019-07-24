//
//  APIUrl.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


enum Urls {
    static let basePath = "https://speech.googleapis.com/v1p1beta1/"
}

enum UrlTypes {
    static let recognize = "speech:recognize"
    static let longRunningRecognize = "speech:longrunningrecognize" //longer than 1 minute
}
