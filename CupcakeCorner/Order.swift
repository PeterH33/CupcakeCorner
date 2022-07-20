//
//  Order.swift
//  CupcakeCorner
//
//  Created by Peter Hartnett on 2/11/22.
//

import SwiftUI

class Order: ObservableObject, Codable{
    //************ Codable Conformance ***********************
    //Step one Add Coking Key enum with cases for everything that needs to be codable
    enum CodingKeys: CodingKey{
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }//The case names mirror the names of the variables to encode and decode
    //Step two, write encode(to: ) method that makes a container and writes all properties
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    //Last step, make an initializer that decodes
    required init(from decoder: Decoder) throws { //this line actually auto fills from req being typed following the above
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    //NOTE: For a challenge it is recommended changing this to a struct and then wrapping it in a class to pass things around like in the last program. I do not really care for that logic in this case, but you can skip this codable conformance above when doing things that way. This requires a bunch of rewriting, but it is easier, refer back to the habit builder app for the way to do this and consider wrapping structs in classes in the future for handling data that has to be shared how a class is shared.
    //****************** Codable conformance ends ****************
    
    //adding that required init above for codable conformance kills the default initializer, you need to remake it like this
    init() {} // simple line to say that you can make an empty instance of the class that uses all of the defaults.
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 0
    
    @Published var specialRequestEnabled = false {
        didSet{ //This will toggle over the dependent states to false as well whenever special requests is turned off, reasonable logic. Very neat implementation to track when something happens like this.
            if specialRequestEnabled == false{
                extraFrosting = false
                addSprinkles = false}
        }
    }
    
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (zip.trimmingCharacters(in: .whitespacesAndNewlines).count < 5){
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += (Double(type)/2)
        
        if extraFrosting { cost += Double(quantity) }
        if addSprinkles { cost += Double(quantity) / 2}
        
        return cost
    }
}
