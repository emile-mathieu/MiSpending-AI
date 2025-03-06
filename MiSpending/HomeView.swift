//
//  HomeView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 17/09/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var activeTab: Tab = .expenses
    @State private var isPopButtonOpen: Bool = false
    @State private var showCameraView: Bool = false
    @State private var showExpenseSaveView: Bool = false
    var body: some View {
            VStack(spacing: 0) {
                TabView(selection: $activeTab) {
                    ExpensesView().setUpTabBar(.expenses)
                    SearchExpensesView().setUpTabBar(.search)
                    AnalyticsView().setUpTabBar(.categories)
                    ProfileView().setUpTabBar(.profile)
                }
                ZStack {
                    CustomBar()
                    if isPopButtonOpen {
                        HStack(spacing: 30) {
                            CameraButtonView(showCameraView: $showCameraView, isPopButtonOpen: $isPopButtonOpen)
                            AddExpenseButtonView(showExpenseSaveView: $showExpenseSaveView, isPopButtonOpen: $isPopButtonOpen)
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.1), value: isPopButtonOpen)
                        .offset(y: isPopButtonOpen ? -50 : 0)
                    }
            }
        }
    }
    
    @ViewBuilder
    func CustomBar() -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                if tab == .addExpense {
                    PopButton(isPopButtonOpen: $isPopButtonOpen)
                } else {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.title2)
                        Text(tab.title)
                            .font(.caption)
                            .textScale(.default)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(activeTab == tab ? .primary : Color.gray.opacity(0.8))
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    .contentShape(.rect)
                    .onTapGesture {
                        activeTab = tab
                        withAnimation {
                            isPopButtonOpen = false
                        }
                    }
                }
            }
        }
        .background(.bar)
    }
}

struct PopButton: View {
    @Binding var isPopButtonOpen: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                isPopButtonOpen.toggle()
            }
        } label: {
            Image(systemName: isPopButtonOpen ? "xmark" : "plus")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Circle().fill(isPopButtonOpen ? Color.red : Color.gray))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct CameraButtonView: View {
    @Binding var showCameraView: Bool
    @Binding var isPopButtonOpen: Bool
    var body: some View {
        Button {
            showCameraView = true
        } label: {
            Image(systemName: "barcode.viewfinder")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.blue))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showCameraView, onDismiss: { withAnimation(.easeInOut(duration: 0.2)) {isPopButtonOpen = false}}) {
            CameraView()
        }
    }
}

struct AddExpenseButtonView: View {
    @Binding var showExpenseSaveView: Bool
    @Binding var isPopButtonOpen: Bool
    var body: some View {
        Button(action: {
            showExpenseSaveView = true
        }) {
            Image(systemName: "pencil.and.list.clipboard")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.green))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showExpenseSaveView, onDismiss: { withAnimation(.easeInOut(duration: 0.2)) {isPopButtonOpen = false}}) {
            ExpenseSaveView()
        }
    }
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return HomeView().modelContainer(container)
}
