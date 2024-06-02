//
//  GuessWho.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import UIKit

struct GuessWho: Playable {
    let answer: String?
    let imgURL: String?
    
    init(
        answer: String?,
        imgURL: String?
    ) {
        self.answer = answer
        self.imgURL = imgURL
    }
}

