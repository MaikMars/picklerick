//
//  InfoRowView.swift
//  picklerick
//
//  Created by Miki on 20/7/25.
//

import SwiftUI

struct InfoRowView: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.semibold)
            Text(value.capitalized)
            Spacer()
        }
        .font(.body)
        .padding(.horizontal)
    }
}

#Preview {
    InfoRowView(label: "label", value: "value")
}
