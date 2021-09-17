//
//  InputField.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct InputField: View {
    
    var label:String
    @Binding var value:String
    var securedTextField:Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .modifier(DetailText())
                .padding(.leading, 8)
            Group {
                if securedTextField {
                    SecureField("", text: $value)
                } else {
                    TextField("", text: $value)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .modifier(DetailText(color: .tBlack))
            .padding(.all, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.tSand, lineWidth: 1)
            )
        }
    }
}

struct InputField_Previews: PreviewProvider {
    
    @State static var value:String = "Test"
    
    static var previews: some View {
        InputField(label: "Demo", value: $value)
            .padding(.all, 16)
    }
}
