//
//  Playable.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import UIKit

protocol Playable {
    var answer: String? { get }
    var imgURL: String? { get }
    
    init(answer: String?, imgURL: String?)
}
