//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Peter Hartnett on 2/11/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip Code", text: $order.zip)
            }
            
            Section{
                NavigationLink{
                        CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }.disabled(!order.hasValidAddress) //This disabled seems to work on either the navigation link or the section itself, I do not see any difference, but I bet that it would knock out everything in the section if applied there.
            }
            
            
        }//End form
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
