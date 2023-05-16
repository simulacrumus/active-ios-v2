//
//  CategoryGridItemView.swift
//  Active
//
//  Created by Emrah on 2022-12-13.
//

import SwiftUI

struct CategoryGridItemView: View {
    let category:Category
    var body: some View {
        NavigationLink(destination: {
            CategoryView(category: category)
                .navigationTitle(category.title)
                .navigationBarTitleDisplayMode(.large)
            }){
                VStack{
                    HStack{
                        Text(category.title)
                            .font(.body)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Image(systemName: Category.getCategoryImage(for: category.id))
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(height: 100)
                .background(Color.ottawaColorAdjusted)
                .cornerRadius(5)
            }
    }
}

struct CategoryGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryGridItemView(category: Category.sample())
    }
}
