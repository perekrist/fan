//
//  PlaceView.swift
//  Naz
//
//  Created by Кристина Перегудова on 22.08.2020.
//  Copyright © 2020 Кристина Перегудова. All rights reserved.
//

import SwiftUI
import SVProgressHUD

struct PlaceView: View {
    @State var sector_id: Int
    
    @ObservedObject var networkService = Places()
    @ObservedObject var reserveTicket = ReserveTicket()
    
    @State var sector: String
    @State private var isShowing = false
    
    @State var row = 0
    @State var place = 0
    
    @State var showConfirmation = false
    
    @State var places: [Place] = []
    
    var body: some View {
        ZStack {
            ZStack {
                Colors.grey.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Доступные места в " + sector)
                            .bold()
                            .padding()
                            .font(.system(size: 30))
                            .foregroundColor(Colors.blue)
                        
                        Spacer()
                        
                        Button(action: {
                            SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: UIScreen.main.bounds.width/2, vertical: UIScreen.main.bounds.height/2))
                            SVProgressHUD.show()
                            self.networkService.getPlaces(event_id: 90, sector_id: self.sector_id, completion: {
                                self.places = self.networkService.places
                                SVProgressHUD.dismiss()
                            })
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .padding()
                                .foregroundColor(Colors.blue)
                                .font(.system(size: 40))
                        })
                    }
                    
                    List(self.places, id: \.self) { place in
                        HStack {
                            Text("Ряд \(place.row)")
                                .padding()
                            Text("Место \(place.place)")
                                .padding()
                            Spacer()
                            Button(action: {
                                self.row = place.row
                                self.place = place.place
                                self.showConfirmation.toggle()
                            }) {
                                Text("Купить")
                                    .foregroundColor(Colors.blue)
                            }.padding()
                                .background(Colors.yellow)
                                .cornerRadius(20)
                                .padding()
                        }
                    }
                }
            }
            if showConfirmation {
                ZStack {
                    Colors.grey.edgesIgnoringSafeArea(.all).opacity(0.5)
                    VStack {
                        Text("Забронировать место \(self.row), ряд: \(self.place) в \(self.sector)")
                            .font(.system(size: 20))
                            .foregroundColor(Colors.blue)
                        Divider()
                        HStack {
                            Button(action: {
                                self.showConfirmation = false
                            }) {
                                Text("Нет")
                                    .font(.system(size: 30))
                                    .foregroundColor(Colors.blue)
                            }.padding()
                            Divider().padding()
                            Button(action: {
                                self.reserveTicket.reserve(event_id: 90, sector_id: self.sector_id, row: self.row, place: self.place) {
                                    self.showConfirmation = false
                                }
                            }) {
                                Text("ДА")
                                    .font(.system(size: 30))
                                    .foregroundColor(Colors.blue)
                            }.padding()
                        }
                    }.padding()
                        .cornerRadius(20)
                        .background(Colors.grey)
                        .frame(width: UIScreen.main.bounds.width*(2/3), height: UIScreen.main.bounds.height*(1/5))
                    
                }
            }
        }
    }
}
