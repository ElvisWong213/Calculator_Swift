//
//  HistoryListView.swift
//  Calculator
//
//  Created by Elvis on 03/08/2023.
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var basicCalculatorViewModel: BasicCalculatorViewModel
    @StateObject var historyListViewModel = HistoryListViewModel()
    
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .brightness(-0.1)
                .ignoresSafeArea()
            if historyListViewModel.results.isEmpty {
                VStack {
                    Spacer()
                    Text("Use calculator to add record")
                        .font(.title3)
                    Spacer()
                    Image(systemName: "arrow.down")
                        .font(.title)
                    Spacer()
                }
                .foregroundColor(.white)
            } else {
                List {
                    ForEach(historyListViewModel.results, id: \.self) { result in
                        VStack(alignment: .trailing, spacing: 10) {
                            Text(result.equation ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                            Text(result.answer ?? "")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                        }
                        .onTapGesture {
                            switch basicCalculatorViewModel.equation.last {
                            case "+", "-", "×", "÷":
                                basicCalculatorViewModel.equation.append(result.answer ?? "")
                            default:
                                basicCalculatorViewModel.equation = result.answer ?? ""
                            }
                        }
                    }
                    .onDelete(perform: { index in
                        historyListViewModel.removeResults(offsets: index)
                        historyListViewModel.fetchResults()
                    })
                    .listRowBackground(
                        Color("BackgroundColor")
                            .brightness(-0.1)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .trailing)
                    .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("Records")
        .toolbarBackground(Color("BackgroundColor"))
        .toolbarBackground(.visible)
        .toolbarColorScheme(.dark)
        .toolbar(content: {
            ToolbarItem {
                Button("Remove all") {
                    historyListViewModel.removeAllResults()
                    historyListViewModel.fetchResults()
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .onAppear() {
            historyListViewModel.fetchResults()
        }
        .onChange(of: basicCalculatorViewModel.finish) { _ in
            historyListViewModel.fetchResults()
        }
        .refreshable {
            historyListViewModel.fetchResults()
        }
    }
        
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
            .environmentObject(BasicCalculatorViewModel())
    }
}