//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import SwiftUI

struct CoinRowView: View {
    @ObservedObject var vm: HomeViewModel
    let coin: CoinModel
    let showHoldingsColumn: Bool
    @State var showAlert: Bool = false
    
    var body: some View {
        
            HStack(spacing: 0){
                leftColumn
                //            coin.fav == true ? "star.fill" : "star"
                Image(systemName: coin.fav ? "star.fill" : "star")
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        showAlert.toggle()
//                        vm.toggleFavorite(for: coin)
                    }.alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(coin.fav ? "Remove to Favorites" : "Add from Favorites"),
                            primaryButton: .destructive(Text("Cancel")),
                            secondaryButton: .default(
                                Text(coin.fav ? "Remove": "Add"),
                                action: {
                                    vm.toggleFavorite(for: coin)
                                }
                            )
                        )
                    }
                
                if(showHoldingsColumn){
                    centerColumn
                }


                Spacer()
                rightColumn
            }
            .font(.subheadline)
            
        
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
            CoinRowView(vm:dev.homeVM, coin: dev.coin, showHoldingsColumn: false).previewLayout(.sizeThatFits)
//            CoinRowView(coin:dev.coin, showHoldingsColumn: true).previewLayout(.sizeThatFits)
//                .preferredColorScheme(.dark)
    }
}

extension CoinRowView {
    private var leftColumn : some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var centerColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    private var rightColumn: some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .bold()
                .foregroundColor(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
