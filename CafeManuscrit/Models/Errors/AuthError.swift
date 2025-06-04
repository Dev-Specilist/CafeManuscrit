//
//  AuthError.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/4/25.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case networkError
    case invalidCredentials
    case keychainError
    case noRefreshToken
    case tokenRefreshFailed
    case userNotFound
    case dataError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "네트워크 연결을 확인해주세요"
        case .invalidCredentials:
            return "로그인 정보가 올바르지 않습니다"
        case .keychainError:
            return "보안 저장소 오류가 발생했습니다"
        case .noRefreshToken:
            return "인증 토큰이 없습니다"
        case .tokenRefreshFailed:
            return "토큰 갱신에 실패했습니다"
        case .userNotFound:
            return "사용자 정보를 찾을 수 없습니다"
        case .dataError:
            return "데이터 처리 중 오류가 발생했습니다"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkError:
            return "서버와의 연결에 실패했습니다"
        case .invalidCredentials:
            return "제공된 인증 정보가 유효하지 않습니다"
        case .keychainError:
            return "기기의 보안 저장소에 접근할 수 없습니다"
        case .noRefreshToken:
            return "저장된 인증 토큰을 찾을 수 없습니다"
        case .tokenRefreshFailed:
            return "새로운 인증 토큰을 받아올 수 없습니다"
        case .userNotFound:
            return "해당 사용자의 데이터를 찾을 수 없습니다"
        case .dataError:
            return "로컬 데이터베이스 처리 중 문제가 발생했습니다"
        case .unknownError:
            return "예상하지 못한 오류가 발생했습니다"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "인터넷 연결을 확인하고 다시 시도해주세요"
        case .invalidCredentials:
            return "다시 로그인해주세요"
        case .keychainError:
            return "앱을 재시작하고 다시 시도해주세요"
        case .noRefreshToken:
            return "다시 로그인해주세요"
        case .tokenRefreshFailed:
            return "다시 로그인해주세요"
        case .userNotFound:
            return "다시 로그인하거나 새 계정을 만들어주세요"
        case .dataError:
            return "앱을 재시작하고 다시 시도해주세요"
        case .unknownError:
            return "문제가 지속되면 고객센터에 문의해주세요"
        }
    }
}
