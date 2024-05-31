//
//  UserReportsViewController.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import UIKit
import DGCharts

class UserReportsViewController: UIViewController {

    
    @IBOutlet weak var popularSectorChartView: BarChartView!
    @IBOutlet weak var popularJobChartView: BarChartView!
    @IBOutlet weak var activeCompanyChartView: BarChartView!
    @IBOutlet weak var avarageSalaryBySectorChartView: BarChartView!
    
    var chartPopularSectors : [PopularSector] = []
    var chartPopularJobs : [PopularJob] = []
    var chartActiveCompaies : [ActiveCompany] = []
    var chartAverageSalaryBySector : [AverageSalaryBySector] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            self.getAllChartData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Bu view controller'dan çıkıldığında navigation barı tekrar göster
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setChartData() {
        // Popüler sektörler için veri girişleri ve sektör isimleri
        var popularSectorEntries: [BarChartDataEntry] = []
        var popularSectorNames: [String] = []
        for (index, sector) in chartPopularSectors.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(sector.totalJobAdvertisements ?? 0))
            popularSectorEntries.append(dataEntry)
            popularSectorNames.append(sector.Sector?.name ?? "")
        }
        
        // Popüler işler için veri girişleri ve iş isimleri
        var popularJobEntries: [BarChartDataEntry] = []
        var popularJobNames: [String] = []
        for (index, job) in chartPopularJobs.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(job.totalJobApplications ?? 0))
            popularJobEntries.append(dataEntry)
            popularJobNames.append(job.job?.job?.name ?? "")
        }
        
        // Aktif şirketler için veri girişleri ve şirket isimleri
        var activeCompanyEntries: [BarChartDataEntry] = []
        var activeCompanyNames: [String] = []
        for (index, company) in chartActiveCompaies.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(company.totalJobAdvertisements ?? 0))
            activeCompanyEntries.append(dataEntry)
            activeCompanyNames.append(company.companyDetail?.company?.name ?? "")
        }
        
        // Sektörlere göre ortalama maaşlar için veri girişleri ve sektör isimleri
        var averageSalaryEntries: [BarChartDataEntry] = []
        var averageSalarySectorNames: [String] = []
        for (index, sector) in chartAverageSalaryBySector.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(sector.averageSalary ?? 0))
            averageSalaryEntries.append(dataEntry)
            averageSalarySectorNames.append(sector.sector?.name ?? "")
        }
        
        // Popüler sektörler için grafik oluştur
        let popularSectorDataSet = BarChartDataSet(entries: popularSectorEntries, label: "Popüler Sektörler")
        popularSectorDataSet.colors = ChartColorTemplates.material()
        let popularSectorData = BarChartData(dataSet: popularSectorDataSet)
        popularSectorChartView.data = popularSectorData
        popularSectorChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: popularSectorNames)
        popularSectorChartView.xAxis.granularity = 1
        popularSectorChartView.xAxis.labelPosition = .topInside
        popularSectorChartView.xAxis.labelRotationAngle = -90
        popularSectorChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // Popüler işler için grafik oluştur
        let popularJobDataSet = BarChartDataSet(entries: popularJobEntries, label: "Popüler İşler")
        popularJobDataSet.colors = ChartColorTemplates.material()
        let popularJobData = BarChartData(dataSet: popularJobDataSet)
        popularJobChartView.data = popularJobData
        popularJobChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: popularJobNames)
        popularJobChartView.xAxis.granularity = 1
        popularJobChartView.xAxis.labelPosition = .topInside
        popularJobChartView.xAxis.labelRotationAngle = -90
        popularJobChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // Aktif şirketler için grafik oluştur
        let activeCompanyDataSet = BarChartDataSet(entries: activeCompanyEntries, label: "Aktif Şirketler")
        activeCompanyDataSet.colors = ChartColorTemplates.material()
        let activeCompanyData = BarChartData(dataSet: activeCompanyDataSet)
        activeCompanyChartView.data = activeCompanyData
        activeCompanyChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: activeCompanyNames)
        activeCompanyChartView.xAxis.granularity = 1
        activeCompanyChartView.xAxis.labelPosition = .topInside
        activeCompanyChartView.xAxis.labelRotationAngle = -90
        activeCompanyChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // Sektörlere göre ortalama maaşlar için grafik oluştur
        let averageSalaryDataSet = BarChartDataSet(entries: averageSalaryEntries, label: "Ortalama Maaşlar")
        averageSalaryDataSet.colors = ChartColorTemplates.material()
        let averageSalaryData = BarChartData(dataSet: averageSalaryDataSet)
        avarageSalaryBySectorChartView.data = averageSalaryData
        avarageSalaryBySectorChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: averageSalarySectorNames)
        avarageSalaryBySectorChartView.xAxis.granularity = 1
        avarageSalaryBySectorChartView.xAxis.labelPosition = .topInside
        avarageSalaryBySectorChartView.xAxis.labelRotationAngle = -90
        avarageSalaryBySectorChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    
    func getAllChartData(){
        Task{
            self.chartPopularSectors = try await AnalysisService().getPopularSectors()
            self.chartPopularSectors = Array(self.chartPopularSectors.sorted(by: {
                ($0.totalJobApplications ?? 0) > ($1.totalJobApplications ?? 0)
            }).prefix(5))
            
            self.chartPopularJobs = try await AnalysisService().getPopularJobs()
            self.chartPopularJobs = Array(self.chartPopularJobs.sorted(by: {
                ($0.totalJobApplications ?? 0) > ($1.totalJobApplications ?? 0)
            }).prefix(5))
            
            self.chartActiveCompaies = try await AnalysisService().getActiveCompanies()
            self.chartActiveCompaies = Array(self.chartActiveCompaies.sorted(by: {
                ($0.totalJobAdvertisements ?? 0) > ($1.totalJobAdvertisements ?? 0)
            }).prefix(5))
            
            self.chartAverageSalaryBySector = try await AnalysisService().getAverageSalariesBySector()
            self.chartAverageSalaryBySector = Array(self.chartAverageSalaryBySector.sorted(by: {
                ($0.averageSalary ?? 0) > ($1.averageSalary ?? 0)
            }).prefix(5))
            
            DispatchQueue.main.async {
                self.setChartData()
            }
            
        }
    }

}
