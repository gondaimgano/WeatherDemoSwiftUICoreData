//
//  ContentView.swift
//  WeatherDemoSwiftUICoreData
//
//  Created by Gondai Mgano on 29/4/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weather:WeatherManager = WeatherManager()
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading,spacing: 12) {
                HeaderView(weather: weather)
                Spacer()
                MinMaxView(weather: weather)
                Divider()
                    .padding(.horizontal, 20.0)
                
                ScrollView(showsIndicators:false) {
                    ForecastView(weather: weather)
                }
                .padding(.horizontal, 20.0)
                
               
                }
            .navigationBarTitle("")
            .navigationBarHidden(true)
                
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HeaderView: View {
   @ObservedObject var weather:WeatherManager
    var body: some View {
        GeometryReader{geo in
            ZStack(alignment:.center) {
             
                if self.weather.currentWeather != nil {
                    Image(self.weather.currentWeather!.desc!.contains("rain") ? "sea_rainy":self.weather.currentWeather!.desc!.contains("cloud") ?"sea_cloudy":"sea_sunny").resizable().scaledToFill().frame(width: geo.size.width, height: geo.size.height*0.20, alignment: .center).animation(.easeIn)
                }
                
                VStack (alignment:.center,spacing: 4){
                    
                    Text("\(Int(self.weather.currentWeather?.temp ?? 0.0)) \u{00B0}").font(.title).fontWeight(.bold)
                    
                    
                    Text(self.weather.currentWeather?.desc ?? "").animation(.spring())
                    Text(self.weather.isConnected ?"" :self.weather.errorMessage).font(self.weather.isConnected ? .largeTitle : .footnote).animation(.easeIn)
                    
                    
                }
                Button(action: {
                                 self.weather.locationManager.startUpdatingLocation()
                             }) {
                                Image(systemName: "arrow.clockwise.circle.fill").scaleEffect(2.0)
                             }.position(x: geo.size.width*0.93, y: geo.size.height*0.1)
            }.foregroundColor(.white)
            
            
        }
    }
}

struct MinMaxView: View {
  @ObservedObject  var weather:WeatherManager
    var body: some View {
        HStack(spacing: 12.0){
            
            VStack(alignment: .leading) {
                Text("min")
                Text("\(Int(weather.currentWeather?.tempMin ?? 0.0)) \u{00B0}")
            }
            Spacer()
            VStack(alignment: .center) {
                Text("current")
                Text("\(Int(weather.currentWeather?.temp ?? 0.0) ) \u{00B0}")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("max")
                Text("\(Int(weather.currentWeather?.tempMax ?? 0.0)) \u{00B0}")
            }
        }
        .padding(.horizontal, 20.0)
    }
}

struct ForecastView: View {
   @ObservedObject var weather:WeatherManager
    var body: some View {
        ForEach(weather.dataList,id: \.dt){
            item in
            HStack(alignment:.firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text("\(item.dt.toDay())")
                    Text("\(item.dt.toTime())").font(.caption)
                }
                Spacer()
                
                if item.desc!.lowercased().contains("cloud") {
                    Image("partlysunny").renderingMode(.template).scaledToFill()
                }
                if item.desc!.lowercased().contains("rain") {
                    Image("rain").renderingMode(.template).scaledToFill()
                    
                }
                if item.desc!.lowercased().contains("clear")||item.desc!.lowercased().contains("sun") {
                    Image("clear").renderingMode(.template).scaledToFill()
                    
                }
                Spacer()
                Text("\(Int(item.temp)) \u{00B0}")
            }
            
        }
    }
}
