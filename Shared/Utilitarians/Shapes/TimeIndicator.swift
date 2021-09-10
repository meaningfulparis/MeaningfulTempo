//
//  TimeIndicator.swift
//  Tempo
//
//  Created by Romain Penchenat on 09/09/2021.
//

import SwiftUI

struct TimeIndicator: View {
    
    enum Kind {
        case horizontal, vertical, detail
    }
    
    init(_ kind:Kind) {
        self.kind = kind
    }
    
    private var kind:Kind
    
    var body: some View {
        Rectangle()
            .fill(kind == .detail ? Color.tSand : Color.tSoil)
            .frame(width: kind == .horizontal ? 6 : 2, height: kind == .horizontal ? 2 : 6)
    }
}

struct TimeIndicator_Previews: PreviewProvider {
    static var previews: some View {
        TimeIndicator(.horizontal)
    }
}
