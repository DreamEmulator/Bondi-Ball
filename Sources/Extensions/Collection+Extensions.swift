//
//  Collection+Extensions.swift
//  Bondi Ball
//
//  Created by Sebastiaan Hols on 06/02/2023.
//  Copyright © 2023 Dream Emulator. All rights reserved.
//

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
