//
//  LoadingView.swift
//  Active
//
//  Created by Emrah on 2023-04-20.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity)
                .padding(1)
            Text(NSLocalizedString("loading", comment: "").uppercased())
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
