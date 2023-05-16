//
//  FacilityContactView.swift
//  Active
//
//  Created by Emrah on 2023-04-18.
//

import SwiftUI

struct FacilityContactView: View {
    
    let facility:Facility
    
    var body: some View {
        VStack{
            HStack{
                Text(NSLocalizedString("contact", comment: ""))
                    .foregroundColor(Color.secondaryText)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            HStack{
                Link( destination: URL(string: "mailto:\(facility.email)")!){
                    Image(systemName: "envelope")
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                    Text(facility.email)
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                }
                Spacer()
            }.padding(.vertical, 1)
            HStack{
                Link( destination: URL(string: "tel:\(facility.phone)")!){
                    Image(systemName: "phone")
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                    Text(facility.phone)
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                }
                Spacer()
            }.padding(.vertical, 1)
            HStack{
                Link(destination: URL(string: facility.url)!){
                    Image(systemName: "globe")
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                    Text("ottawa.ca")
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                }
                Spacer()
            }.padding(.vertical, 1)
        }
    }
}

struct FacilityContactView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityContactView(facility: Facility.sample())
    }
}
