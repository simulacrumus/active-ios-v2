//
//  ActivityLocationView.swift
//  Active
//
//  Created by Emrah on 2023-04-17.
//

import SwiftUI
import MapKit

struct FacilityLocationView: View {
    @State var ETA:String = String()
    let facility:Facility
    var body: some View {
        Button{
            openFacilityInMaps(facility: facility)
        }label: {
            VStack {
                HStack{
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                    Text(facility.address.street)
                        .font(.subheadline)
                        .foregroundColor(Color.accentColor)
                    Spacer()
                    if ETA.isEmpty{
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Image(systemName: "car.fill")
                            .font(.subheadline)
                            .foregroundColor(Color.accentColor)
                        Text(ETA)
                            .font(.subheadline)
                            .foregroundColor(Color.accentColor)
                    }
                }
                MapDirectionView(destinationLocation: Location(lat: facility.latitude, lng: facility.longitude, title: facility.title), ETA: $ETA)
                    .cornerRadius(10)
                    .frame(height: 200)
            }
        }
    }
}

private func openFacilityInMaps(facility:Facility){
    let regionDistance:CLLocationDistance = 500
    let coordinates = CLLocationCoordinate2DMake(facility.latitude, facility.longitude)
    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = facility.title
    mapItem.openInMaps(launchOptions: options)
}

struct FacilityLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FacilityLocationView(facility: Facility.sample())
    }
}
