//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    func addSubscribers(){
//        dataService.$allCoins.sink{
//            [weak self] (returnedCoins) in
//            self?.allCoins = returnedCoins
//        }.store(in: &cancellables)
        
        
//        this below function works for both filtering of coins and allcoins too so we dont require the above subscriber
        $searchText.combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins).sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }.store(in: &cancellables)
           
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
  
            guard !text.isEmpty else {
                return coins
            }
            let lowercasedText = text.lowercased()
            return coins.filter { (coin) -> Bool in
                return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
            }
    }
}
