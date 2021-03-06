//
//  UserRepository.swift
//  CommitGenerator
//
//  Created by JongHo Park on 2022/03/14.
//

import Foundation
import Combine

// MARK: - User Repository 프로토콜
protocol UserRepository {
    func getUser() -> AnyPublisher<Loadable<User>, Never>
    func requestAccessToken(with code: String) -> AnyPublisher<Loadable<User>, Never>
    func deviceflow() -> AnyPublisher<Loadable<DeviceflowResult>, Never>
}
// MARK: - User Repository 인스턴스
final class DefaultUserRepository {
    private let githubService: GithubServiceProtocol
    
    static let shared: DefaultUserRepository = DefaultUserRepository()
    
    init(githubService: GithubServiceProtocol = GithubService.shared) {
        self.githubService = githubService
    }
}
// MARK: - 프로토콜 구현부
extension DefaultUserRepository: UserRepository {
    func getUser() -> AnyPublisher<Loadable<User>, Never> {
        return githubService.getUser()
    }
    
    func requestAccessToken(with code: String) -> AnyPublisher<Loadable<User>, Never> {
        #if os(iOS)
        return githubService.requestAccessToken(with: code)
        #endif
        #if os(macOS)
        return githubService.requestAccessTokenWithDeviceflow(with: code)
        #endif
    }
    
    func deviceflow() -> AnyPublisher<Loadable<DeviceflowResult>, Never> {
        return GithubService.API.deviceflow.request(baseURL: Const.URL.GITHUB_AUTHENTICATE_BASE_URL)
            .publishDecodable(type: DeviceflowResult.self)
            .value()
            .map {
                Loadable.success(data: $0)
            }
            .catch { (error) -> AnyPublisher<Loadable<DeviceflowResult>, Never> in
                Just(Loadable.error(error: error)).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
