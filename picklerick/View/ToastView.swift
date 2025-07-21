//
//  ToastView.swift
//  picklerick
//
//  Created by Miki on 21/7/25.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(.red)
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(.horizontal, 20)
    }
}

#Preview {
    ToastView(message: "Error message")
}
