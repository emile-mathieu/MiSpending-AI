//
//  HomeView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 17/09/2024.
//

import SwiftUI

struct HomeView: View {
    @State var activeTab: Tab = .expenses
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab){
                ExpensesView().setUpTabBar(.expenses)
                CameraView().setUpTabBar(.addExpense)
                ProfileView().setUpTabBar(.profile)
            }
            CustomBar()
        }
    }
    @ViewBuilder
    func CustomBar() -> some View {
        HStack(alignment: .center, spacing: 0){
            ForEach(Tab.allCases, id: \.self) { tab in
                VStack(spacing: 4){
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                    Text(tab.title)
                        .font(.caption)
                        .textScale(.default)
                }.frame(maxWidth: .infinity)
                    .foregroundStyle(activeTab == tab ? .primary : Color.gray.opacity(0.8))
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .contentShape(.rect)
                    .onTapGesture {
                        activeTab = tab
                    }
            }
        }
        .background(.bar)
    }
}

#Preview {
    HomeView()
}

extension View {
    @ViewBuilder
    func setUpTabBar(_ tabBar: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tabBar)
            .toolbar(.hidden, for: .tabBar)
    }
}
