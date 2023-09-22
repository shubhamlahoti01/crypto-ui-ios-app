//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showFavorite: Bool = false
    
    var body: some View {
        
        ZStack{
//            background layer
            Color.theme.background.ignoresSafeArea()
            
//            content layer
            VStack{
               
                homeHeader
                HomeStatsView(vm: vm, showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                if showFavorite {
                    favoriteCoins.transition(.move(edge: .leading))
                } else if !showPortfolio {
                    allCoinsList.transition(.move(edge: .leading))
                } else if showPortfolio {
                    portfolioCoinsList.transition(.move(edge: .trailing))
                }
                
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(vm: dev.homeVM)
                .navigationBarHidden(true)
        }
    }
}

extension HomeView {
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : showFavorite ? "star" : "star.fill")
                .animation(.none)
                .background(
                CircleButtonAnimationView(animate: $showPortfolio)
                ).onTapGesture {
                    if(!showPortfolio){
                        showFavorite.toggle()
                    }
                }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : showFavorite ? "Favorites" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    private var favoriteCoins: some View {
        List {
            ForEach(vm.favoriteCoinsData){
                coin in
                CoinRowView(vm:vm,coin:coin,showHoldingsColumn: false)
                    .listRowInsets(.init(top:10, leading:0, bottom: 10, trailing: 10))
            }
        }.listStyle(PlainListStyle())
        
    }
    private var allCoinsList: some View {
        List{
            ForEach(vm.allCoins) {
                coin in
                    CoinRowView(vm:vm,coin:coin,showHoldingsColumn: false)
                        .listRowInsets(.init(top:10, leading:0, bottom: 10, trailing: 10))
                
            }
            
        }
        .listStyle(PlainListStyle())
    }
    private var portfolioCoinsList: some View {
        List{
            ForEach(vm.portfolioCoins) {
                coin in
              
                    
                    CoinRowView(vm:vm, coin:coin,showHoldingsColumn: true)
                        .listRowInsets(.init(top:10, leading:0, bottom: 10, trailing: 10))
                
            }
        }
        .listStyle(PlainListStyle())
    }
    private var columnTitles: some View {
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }.font(.caption).foregroundColor(Color.theme.secondaryText)
            .padding(.horizontal)
        
    }
}
