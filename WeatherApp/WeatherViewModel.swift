//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mark Spano on 11/20/24.
//

import UIKit

extension Data {
    var prettyPrintedJSONString: NSString {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "nil" }
        
        return prettyPrintedString
    }
}

struct Weather: Decodable {
    let current: CurrentWeather?
    let location: GeoLocation?
}

struct Condition: Decodable {
    let code: Int?
    let text: String?
    let icon: String?
}

struct GeoLocation: Decodable {
    let name: String?
    let region: String?
    let country: String?
}

struct CurrentWeather: Decodable {
    let temperature: Double?
    let condition: Condition?
    let humidity: Int?
    let uvIndex: Double?
    let feelsLikeTemperature: Double?
    //let lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp_f"
        case condition = "condition"
        case humidity = "humidity"
        case uvIndex = "uv"
        case feelsLikeTemperature = "feelslike_f"
        //case lastUpdated = "last_updated"
    }
}

class WeatherViewModel: ObservableObject {
    
    @Published var weather: Weather?
    @Published var city = "Phoenix"
    
    var iconString: String?
    
    let token = "c127503f4e5b4029b05233045242011"
    
    func reloadView() {
        Task {
            await getWeather()
        }
    }

    @MainActor func getWeather() async {
        await getWeather(from: city, completion: nil)
    }
    
    @MainActor func getWeather(from city: String, completion: ((Result<Weather, Error>) -> Void)?) async {
        
        let urlString = "https://api.weatherapi.com/v1/current.json"

        let url = URL(string: urlString + "?key=\(token)&q=\(city)&aqi=no")
        let task = URLSession.shared.dataTask(with: url!) { [self] (data, response, error) in
            if let error = error {
                completion?(.failure(error))
                return
            }
            
            do {
                print(data?.prettyPrintedJSONString)
                
                weather = try JSONDecoder().decode(Weather.self, from: data!)
                if let iconValue = weather?.current?.condition?.icon {
                    iconString = "https:" + iconValue
                } else {
                    iconString = nil
                }
                completion?(.success(weather!))
            } catch {
                completion?(.failure(error))
            }
        }
        task.resume()
    }
}


