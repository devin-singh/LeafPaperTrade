//
//  StringExtension.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/28/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

extension String {
  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
}
