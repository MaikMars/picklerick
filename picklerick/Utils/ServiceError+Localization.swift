//
//  ServiceError+Localization.swift
//  picklerick
//
//  Created by Miki on 21/7/25.
//

import Foundation

extension ServiceError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("error_invalid_url", comment: "")
        case .decodingError:
            return NSLocalizedString("error_decoding", comment: "")
        case .networkError(let error):
            return error.localizedDescription
        case .emptyData:
            return NSLocalizedString("empty_data", comment: "")
        }
    }
}
