//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
//    "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=30&page=1&sparkline=true&price_change_percentage=24h"
    
    private func getCoins(){
        guard let url = URL(string: "https://shubhamlahoti01.github.io/starwars-json-api/crypto.json") else { return }
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self , decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue:{ [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
