//
//  BaseViewModel.swift
//  picklerick
//
//  Created by Miki on 21/7/25.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var toastMessage: String? = nil
    @Published var isLoading = false
    
    init(toastMessage: String? = nil, isLoading: Bool = false) {
        self.toastMessage = toastMessage
        self.isLoading = isLoading
    }
    
    internal func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.toastMessage = nil
        }
    }
    
    internal func handleError(_ error: Error) {
        if let serviceError = error as? ServiceError {
            showToast(serviceError.localizedDescription)
        } else {
            showToast(error.localizedDescription)
        }
    }
}
