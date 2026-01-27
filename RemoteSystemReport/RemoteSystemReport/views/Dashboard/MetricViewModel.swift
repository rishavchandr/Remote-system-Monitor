//
//  MetricViewModel.swift
//  RemoteSystemReport
//
//  Created by Rishav chandra on 24/01/26.
//

import Foundation
import Combine


@MainActor
final class MetricViewModel: ObservableObject{
    @Published var metrics: [Metric] = []
    @Published var isLoading = false
    private var timer: Timer?
    @Published var selectedDate: Date? = nil
    @Published var errorMessage: String?
    
    private let dateFormatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func fetch(deviceId: String,for date: Date? = nil){
        
        if(metrics.isEmpty){isLoading = true}
        
        if let date = date {
            self.selectedDate = date
        }
        
        let startDate: Date
        let endDate: Date
        
        var calender = Calendar.current
        calender.timeZone = TimeZone(secondsFromGMT: 0)!
        
        if let  dateToFetch = selectedDate {
            startDate = calender.startOfDay(for: dateToFetch)
            endDate = calender.date(byAdding: .day, value: 1, to: startDate)!.addingTimeInterval(-1)
        } else {
            endDate = Date()
            startDate = calender.date(byAdding: .hour, value: -24, to: endDate)!
        }
        
        let query =
        [
            URLQueryItem(name: "from", value: dateFormatter.string(from: startDate)),
            URLQueryItem(name: "to", value: dateFormatter.string(from: endDate)),
            URLQueryItem(name: "bucket", value: "60")
        ]
        
        ApiClient.shared.request(
            path: "/metrics/\(deviceId)",
            query: query) { (result: Result<MetricResponse,Error>) in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let response):
                        self.metrics = response.data
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    func startPolling(deviceId: String){
        stopPolling()
        
        let selectedDeviceId = deviceId
        timer = Timer.scheduledTimer(withTimeInterval: 30.0 , repeats: true){ _ in
            Task { @MainActor in
                let selectedDateForLoop = self.selectedDate
                self.fetch(deviceId: selectedDeviceId,for: selectedDateForLoop)
            }
        }
    }
    
    func stopPolling(){
        timer?.invalidate()
        timer = nil
    }
    
    func clearErrorMessage(){
        self.errorMessage = nil
    }
}
