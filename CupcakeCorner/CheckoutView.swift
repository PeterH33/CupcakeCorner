//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Peter Hartnett on 2/11/22.
//
//NOTE This section includes first instance of using URLSession

import SwiftUI



struct CheckoutView: View {
    @ObservedObject var order: Order
    
    //for showing an alert States
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var connectionFailMessage = ""
    @State private var showingConnectionFailAlert = false
    
    func placeOrder() async{
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")! //this site is good for testing network sends
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST" //Comment this line out to test for theoretical netowkr fails
        
        do{
            let(data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch{
            print("Checkout failed.")
            connectionFailMessage = "Order has failed, check your connection."
            showingConnectionFailAlert = true
            
        }
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is: \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    
                    Task {
                        await placeOrder()
                    }
                    
                }
                    .padding()
                
            }
            
            
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        //These alerts are handy and I should get the syntax down for them.
        .alert("Thank you", isPresented: $showingConfirmation){
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
        .alert("Error", isPresented: $showingConnectionFailAlert){
            Button("OK"){}
        } message: {
            Text(connectionFailMessage)
        }
        
        
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
