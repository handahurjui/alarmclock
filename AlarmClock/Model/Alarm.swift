//
//  Alarm.swift
//  AlarmClock
//
//  Created by andah on 03/07/2018.
//  Copyright © 2018 andah. All rights reserved.
//

import Foundation

struct AlarmResponse : Codable {
    let alarms: [Alarm]
    
    static func parseAlarms(fromJSON data:Data?) -> [Alarm]? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
      
        do {
            try decoder.decode(AlarmResponse.self, from: data)
        } catch  {
            print("Error parsing response : \(error.localizedDescription)")
        }
        
        return nil
    }
}

class Alarm : NSObject, Codable {
    var id: Int
    var label : String
    var hour : Int
    var minutes: Int
    var enabled: Bool?
    var token: String
    
    override init(){
        self.id = 0
        self.label = "Alarm"
        self.hour = 0
        self.minutes = 0
        self.enabled = true
        self.token = ""
    }
    init(id: Int, label: String, hour: Int, minutes: Int, enabled: Bool, token: String){
        self.id = id
        self.label = label
        self.hour = hour
        self.minutes = minutes
        self.enabled = enabled
        self.token = token
    }
    
//    private enum CodingKeys : String, CodingKey {
//        case id
//        case label
//        case hour
//        case minutes
//        case enabled
//    }
    
   
    
}
//extension Alarm: Decodable {
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        label = try container.decode(String.self, forKey: .label)
//        hour = try container.decode(Int.self, forKey: .hour)
//        minutes = try container.decode(Int.self, forKey: .minutes)
//        do {
//            self.enabled = (try container.decodeIfPresent(Bool.self, forKey: .enabled))!
//        } catch DecodingError.typeMismatch {
//            // There was something for the "enabled" key, but it wasn't a boolean value. Try a string.
//            if let string = try container.decodeIfPresent(String.self, forKey: .enabled) {
//                // Can check for "parent" specifically if you want.
//                self.enabled = false
//            }
//        }
//    }
//}
//
//extension Alarm: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(label, forKey: .label)
//        try container.encode(hour, forKey: .hour)
//        try container.encode(minutes, forKey: .minutes)
//        try container.encode(enabled, forKey: .enabled)
//    }
//}
