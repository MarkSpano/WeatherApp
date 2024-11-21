//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mark Spano on 11/20/24.
//

import SwiftUI

struct DetailCard: View {
    var weather: Weather?
    
    var body: some View {
        HStack {
            VStack {
                Text("Humidity")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 12))

                Text("\(weather?.current?.humidity ?? 0)")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 15))
            }
            
            Spacer()
            
            VStack {
                Text("UV")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 12))

                Text("\(Int(weather?.current?.uvIndex ?? 0))")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 15))
            }
            
            Spacer()
            
            VStack {
                Text("Feels Like")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 12))

                Text("\(Int(weather?.current?.feelsLikeTemperature ?? 0))°")
                    .foregroundColor(Color(red: 0.601, green: 0.601, blue: 0.601))
                    .font(.custom("Poppins", size: 15))
                
           }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(red: 0.945, green: 0.945, blue: 0.945))
        )
    }
}

struct SearchBar: View {
    @ObservedObject var vm: WeatherViewModel
    @State private var loc: String = "Phoenix"
    
    var weather: Weather?
    
    var body: some View {
        TextField("Search location", text: $vm.city)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(red: 0.945, green: 0.945, blue: 0.945))
            )
            .padding()
            .onSubmit {
                vm.reloadView()
            }
    }
}

struct WeatherView: View {
    
    @StateObject var vm = WeatherViewModel()
    
    var body: some View {
        GeometryReader { geom in
            SearchBar(vm: vm)
            
            VStack {
                if let iconString = vm.iconString {
                    AsyncImage(url: URL(string: iconString)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "star")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                    }
                    .frame(width: 246.0, height: 246.0)
                    .padding(.bottom, 0.0)
                }
                
                Text(vm.weather?.location?.name ?? "Unknown location")
                    .font(.custom("Poppins", size: 30))
                    .bold()
                    .padding(.top, 0.0)
                
                Text("\(Int(vm.weather?.current?.temperature ?? 0))°")
                    .font(.custom("Poppins", size: 70))
                    .bold()
                    .padding(.top, 10)
                
                DetailCard(weather: vm.weather)
                    .padding(.init(top: 10, leading: 40, bottom: 10, trailing: 40))
            }
            .padding(.top, 80)
            .task {
                await vm.getWeather()
            }
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    WeatherView()
}
