//
//  FiltersView.swift
//  picklerick
//
//  Created by Miki on 17/7/25.
//

import SwiftUI

struct FiltersView: View {
    var onApply: () -> Void
    
    @Binding var isPresented: Bool
    @Binding var seachType: String
    @Binding var filters: [String: String]
    
    @State private var searchStatus: String = "name"
    @State private var selectedStatus: String = "alive"
    @State private var genderStatus: String = "female"
    @State private var isStatusFilterSelected: Bool = true
    @State private var isGenderFilterSelected: Bool = true
    
    private let searchOptions = ["name", "spiece", "type"]
    private let statusOptions = ["alive", "dead", "unknown"]
    private let genderOptions = ["female", "male", "genderless", "unknown"]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Label("Search by :", systemImage: "magnifyingglass")
                .labelStyle(.titleOnly)
                .padding(.horizontal)
                .padding(.bottom, 4)
            
            Picker("Search Type", selection: $searchStatus) {
                ForEach(searchOptions, id: \.self) { status in
                    Text(status.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom)

            Toggle("Status", isOn: $isStatusFilterSelected)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .padding(.horizontal)
                .frame(width: 150)
            
            Picker("Status", selection: $selectedStatus) {
                ForEach(statusOptions, id: \.self) { status in
                    Text(status.capitalized)
                }
            }
            .disabled(!isStatusFilterSelected)
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer().frame(height: 6)
            
            Toggle("Gender", isOn: $isGenderFilterSelected)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .padding(.horizontal)
                .frame(width: 150)
            
            Picker("Gender", selection: $genderStatus) {
                ForEach(genderOptions, id: \.self) { status in
                    Text(status.capitalized)
                }
            }
            .disabled(!isGenderFilterSelected)
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer().frame(height: 6)
            HStack {
                Spacer()
                Button("Aplicar filtros") {
                    var appliedFilters: [String: String] = [:]
                    seachType = searchStatus
                    if isStatusFilterSelected { appliedFilters["status"] = selectedStatus }
                    if isGenderFilterSelected { appliedFilters["gender"] = genderStatus }
                    filters = appliedFilters
                    onApply()
                    withAnimation { isPresented = false }
                }
                .padding()
            }
           
        }
        .onAppear {
            searchStatus = seachType
            if let status = filters["status"] {
                selectedStatus = status
                isStatusFilterSelected = true
            } else {
                isStatusFilterSelected = false
            }
            if let gender = filters["gender"] {
                genderStatus = gender
                isGenderFilterSelected = true
            } else {
                isGenderFilterSelected = false
            }
        }
    }
}

#Preview {
    FiltersView(
        onApply: {},
        isPresented: .constant(true),
        seachType: .constant("name"),
        filters: .constant(["status": "alive", "gender": "female"])
    )
}
