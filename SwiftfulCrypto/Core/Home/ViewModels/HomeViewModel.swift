//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "title", value: "value", percentageChange: 12),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value", percentageChange: -1),
        StatisticModel(title: "title", value: "value", percentageChange: 3),
        ]
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var favoriteCoinsData: [CoinModel] = []
    @Published var searchText: String = ""

    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    func toggleFavorite(for coin: CoinModel){
        if let index = allCoins.firstIndex(where:{ $0.id == coin.id }){
            allCoins[index].fav.toggle()
            if(allCoins[index].fav){
                favoriteCoinsData.append(allCoins[index])
            } else {
                favoriteCoinsData.removeAll(where: {$0.id == coin.id})
            }
        }
    }
    func addSubscribers(){
//        dataService.$allCoins.sink{
//            [weak self] (returnedCoins) in
//            self?.allCoins = returnedCoins
//        }.store(in: &cancellables)
        
        
//        this below function works for both filtering of coins and allcoins too so we dont require the above subscriber
        $searchText.combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins).sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }.store(in: &cancellables)
        
        
//        updated marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
            self?.statistics = returnedStats
                print("data changed")
//                print(returnedStats)
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
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}
