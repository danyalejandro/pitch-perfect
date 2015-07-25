//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Dany Cabrera Vargas on 25/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(url:NSURL) {
        title = url.lastPathComponent
        filePathURL = url
    }
}
