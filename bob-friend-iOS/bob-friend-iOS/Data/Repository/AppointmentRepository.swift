//
//  AppointmentRepository.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/28.
//

import Foundation

protocol AppointmentRepository {

    func getAllAppointments(page: Int, type: AppointmentGetRequestType, completion: ((Result<AppointmentListModel, Error>) -> Void)?)
    func getSearchAppointments(searchWord: String, selectedTime: (String, String)?, onlyEnterable: Bool, searchType: SearchCategory, page: Int, completion: ((Result<AppointmentListModel, Error>) -> Void)?)
    func getAllAppointmentLocations(completion: ((Result<AppointmentLocationListModel, Error>) -> Void)?)
}

enum AppointmentGetRequestType: String {
    case owned
    case joined
    case available
    case all
    case specific
}

class AppointmentRepositoryImpl: AppointmentRepository {

    let network: Network = Network()

    func getAllAppointments(page: Int = 0, type: AppointmentGetRequestType = .all, completion: ((Result<AppointmentListModel, Error>) -> Void)?) {
        network.getAppointmentListRequest(page: page, type: type) { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let appointments):
                guard let appointments = appointments else {
                    completion(Result.failure(ResponedError.error))
                    return
                }
                completion(Result.success(appointments))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    func getSearchAppointments(searchWord: String, selectedTime: (String, String)?, onlyEnterable: Bool, searchType: SearchCategory, page: Int = 0, completion: ((Result<AppointmentListModel, Error>) -> Void)?) {
        network.getSearchAppointmentListRequest(searchWord: searchWord, selectedTime: selectedTime, onlyEnterable: onlyEnterable, category: searchType, page: page) { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let appointments):
                guard let appointments = appointments else {
                    completion(Result.failure(ResponedError.error))
                    return
                }
                completion(Result.success(appointments))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    func getAllAppointmentLocations(completion: ((Result<AppointmentLocationListModel, Error>) -> Void)?) {

        network.getAllAppointmentLocations { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let locations):
                guard let locations = locations else {
                    completion(.failure(ResponedError.error))
                    return
                }
                completion(.success(locations))

            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
