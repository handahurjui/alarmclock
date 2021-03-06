//
//  NetworkClient.swift
//  AlarmClock
//
//  Created by andah on 03/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import Foundation


class NetworkClient {
    
    private static let baseURL = "http://red.maxcode.net"
    private static let token = "90db17bb-693a-409f-b229-28147e7990fa"
    
    private enum ResourcePath: CustomStringConvertible {
        case Get
        case Create
        case Update
        case Delete
        
        var description: String {
            switch self {
            case .Get:
                return "/api/clocks"
            case .Create:
                return "/api/clocks"
            case .Update:
                return "/api/clocks"
            case .Delete:
                return "/api/clocks"
            }
        }
    }
    
    typealias AlarmsResults = ([Alarm]?, String) -> ()
    typealias AlarmResult = (Alarm, String) -> ()
    var alarms: [Alarm] = []
    var errorMessage = ""
    
    lazy var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func getAlarms(completion: @escaping AlarmsResults){
        
        
        let urlString = NetworkClient.baseURL + ResourcePath.Get.description
    
        guard var url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["x-token":NetworkClient.token,
                                       "Content-Type":"application/json"]
        
        dataTask =  defaultSession.dataTask(with: request) { (data, response, error) in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else {
                if let data = data ,
                let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateAlarmResult(data)
                    DispatchQueue.main.async {
                        completion(self.alarms,self.errorMessage)
                    }
                }
            }
        }
        dataTask?.resume()
    }
    func updateAlarmResult(_ data: Data) {
        alarms.removeAll()
        do {
            alarms = try decoder.decode([Alarm].self, from: data)
        } catch let decoderError as NSError {
            errorMessage += "Decoder error: \(decoderError.localizedDescription)"
            return
        }
    }
    func getAlarm(id: Int, completion: @escaping AlarmResult){
        
        
        let urlString = NetworkClient.baseURL + ResourcePath.Get.description + "/\(id)"
        
        guard var url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["x-token":NetworkClient.token,
                                       "Content-Type":"application/json"]
        
        dataTask =  defaultSession.dataTask(with: request) { (data, response, error) in
            defer { self.dataTask = nil }
            let alarm : Alarm?
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else {
                if let data = data ,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    do {
                        alarm = try self.decoder.decode(Alarm.self, from: data)
                    } catch let decoderError as NSError {
                        self.errorMessage += "Decoder error: \(decoderError.localizedDescription)"
                        return
                    }
                    DispatchQueue.main.async {
                        completion(alarm!,self.errorMessage)
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    func addAlarm(alarm: Alarm){
        
        
        let urlString = NetworkClient.baseURL + ResourcePath.Create.description
        guard var url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["x-token": NetworkClient.token,
                                       "Content-Type":"application/json"]
        do {
            request.httpBody = try encoder.encode(alarm)
        } catch let encodeError as NSError {
            print("Encoder error: \(encodeError.localizedDescription)\n")
            
        }
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                self?.errorMessage += "DataTask error: \(error.localizedDescription) \n"
            } else {
                if let data = data , let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let  alarm = try self?.decoder.decode(Alarm.self, from: data)
                        print("Alarm from POST result id: \(alarm?.id)")
                    } catch let decoderError as NSError {
                        self?.errorMessage += "Decoder error: \(decoderError.localizedDescription)"
                        return
                    }
                }
            }
        })
        dataTask?.resume()
    }
    func editAlarm(alarm: Alarm){
        
        
        let urlString = NetworkClient.baseURL + ResourcePath.Update.description + "/\(alarm.id)"
        guard var url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = ["x-token": NetworkClient.token,
                                       "Content-Type":"application/json"]
        do {
            request.httpBody = try encoder.encode(alarm)
        } catch let encodeError as NSError {
            print("Encoder error: \(encodeError.localizedDescription)\n")
         
        }
        dataTask = defaultSession.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                self?.errorMessage += "DataTask error: \(error.localizedDescription) \n"
            } else {
                if let data = data , let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let  alarm = try self?.decoder.decode(Alarm.self, from: data)
                        print("Alarm from PUT result id: \(alarm?.id)")
                    } catch let decoderError as NSError {
                        self?.errorMessage += "Decoder error: \(decoderError.localizedDescription)"
                        return
                    }
                }
            }
        })
        dataTask?.resume()
    }
    func deleteAlarm(id: Int){
       
        
        let urlString = NetworkClient.baseURL + ResourcePath.Delete.description + "/\(id)"
        guard var url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = ["x-token": NetworkClient.token]
        dataTask = defaultSession.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                self?.errorMessage += "DataTask error: \(error.localizedDescription) \n"
            } else {
                if let data = data , let response = response as? HTTPURLResponse, response.statusCode == 204 {
                     print("Alarm from DELETE resut id: \(id)")
                }
            }
        })
        dataTask?.resume()
    }
}
