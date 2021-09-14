//
//  DispatchQueue_extension.swift
//  Tempo
//
//  Created by Romain Penchenat on 14/09/2021.
//

import Dispatch
import SwiftUI

extension DispatchQueue {
    
    func asyncWithAnimation(execute work:@escaping () -> Void) {
        self.async {
            withAnimation {
                work()
            }
        }
    }
    
}
