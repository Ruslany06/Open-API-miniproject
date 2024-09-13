//
//  ViewController.swift
//  Open API
//
//  Created by Ruslan Yelguldinov on 11.08.2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import DGCharts

class ChartsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarChart()
        setDataCharts()
//        fethingAllIncomeData()
    
        if let cikCode = cikCode {
            fethingAllIncomeData(cikCode: cikCode)
        } else {
            print("No CIK code provided")
        }
        
        let netIncomeData = NetIncomeLoss()
        let grossProfitData = GrossProfit()
        let operatingIncomeData = OperatingIncomeLoss()
        
        // Установка данных в лейблы
        setData(netIncomeData: netIncomeData, grossProfitData: grossProfitData, operatingIncomeData: operatingIncomeData)
    }

    var netIncomeLossArray: [NetIncomeLoss] = []
    var grossProfitArray: [GrossProfit] = []
    var operatingIncomeLossArray: [OperatingIncomeLoss] = []

    var barChartView1: BarChartView!
    var barChartView2: BarChartView!
    var barChartView3: BarChartView!
    
    @IBOutlet weak var netIncomeLossChartView: UIView!
    @IBOutlet weak var grossProfitChartView: UIView!
    @IBOutlet weak var operatingIncomeLossChartView: UIView!
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var mainTotalLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var descriptionLabel3: UILabel!
    
    var cikCode: String?

    // MARK: Set data
    func setupBarChart() {
        barChartView1 = BarChartView()
        barChartView2 = BarChartView()
        barChartView3 = BarChartView()
        
        barChartView1.frame = CGRect(x: 0, y: 0, width: self.netIncomeLossChartView.frame.size.width, height: self.netIncomeLossChartView.frame.size.height)
        barChartView2.frame = CGRect(x: 0, y: 0, width: self.grossProfitChartView.frame.size.width, height: self.grossProfitChartView.frame.size.height)
        barChartView3.frame = CGRect(x: 0, y: 0, width: self.operatingIncomeLossChartView.frame.size.width, height: self.operatingIncomeLossChartView.frame.size.height)
        
        self.netIncomeLossChartView.addSubview(barChartView1)
        self.grossProfitChartView.addSubview(barChartView2)
        self.operatingIncomeLossChartView.addSubview(barChartView3)
    }
    
    func setData(netIncomeData: NetIncomeLoss, grossProfitData: GrossProfit, operatingIncomeData: OperatingIncomeLoss) {
        
        mainTotalLabel.text = netIncomeData.entityName
        titleLabel1.text = netIncomeData.title
        titleLabel2.text = grossProfitData.title
        titleLabel3.text = operatingIncomeData.title
        
        descriptionLabel1.text = netIncomeData.description
        descriptionLabel2.text = grossProfitData.description
        descriptionLabel3.text = operatingIncomeData.description
    }
    
    func setDataCharts() {
        // Замените это на ваш код для получения данных
        let dateArray = ["2006", "2007", "2008", "2009", "2010"]
        let valueArray: [Double] = [3496000000, 3000000000, 2800000000, 4000000000, 2500000000]
        
        // Преобразование данных в ChartDataEntry
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<valueArray.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: valueArray[i])
            dataEntries.append(dataEntry)
        }
        
        // Создание и настройка DataSet
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Net Income (Loss)")
        chartDataSet.colors = [NSUIColor.blue] // Цвет столбцов
        
        // Создание и настройка Data
        let chartData1 = BarChartData(dataSet: chartDataSet)
        barChartView1.data = chartData1
        let chartData2 = BarChartData(dataSet: chartDataSet)
        barChartView2.data = chartData2
        let chartData3 = BarChartData(dataSet: chartDataSet)
        barChartView3.data = chartData3
        
        // Настройка отображения графика
        barChartView1.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
        barChartView1.xAxis.granularity = 1
        barChartView1.xAxis.labelPosition = .bottom
        barChartView1.leftAxis.axisMinimum = 0
        barChartView1.rightAxis.enabled = false
        
        barChartView2.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
        barChartView2.xAxis.granularity = 1
        barChartView2.xAxis.labelPosition = .bottom
        barChartView2.leftAxis.axisMinimum = 0
        barChartView2.rightAxis.enabled = false
        
        barChartView3.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
        barChartView3.xAxis.granularity = 1
        barChartView3.xAxis.labelPosition = .bottom
        barChartView3.leftAxis.axisMinimum = 0
        barChartView3.rightAxis.enabled = false
        
    }

    // MARK: Update charts's data
    func updateChart(with data: NetIncomeLoss, for chartView: BarChartView) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        let yearlyData = data.yearlyValues
        let sortedData = yearlyData.sorted(by: { $0.key < $1.key })
        
        // Формируем массив записей для графика
        for (year, value) in sortedData {
            let dataEntry = BarChartDataEntry(x: Double(year), y: value) // x - года, y - значения
            
            dataEntries.append(dataEntry)
        }
        
        // Создаём набор данных для графика
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Income Data")
        chartDataSet.colors = [NSUIColor.blue]
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // Устанавливаем данные для графика
        chartView.data = chartData
        
        // Устанавливаем форматтер оси X
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 0)
        chartView.xAxis.granularity = 1  // Показываем все года
        chartView.xAxis.labelPosition = .bottom
        
        chartView.leftAxis.axisMinimum = 0  // Минимальное значение оси Y
        chartView.rightAxis.enabled = false
    }
    func updateChart(with data: GrossProfit, for chartView: BarChartView) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        let yearlyData = data.yearlyValues
        let sortedData = yearlyData.sorted(by: { $0.key < $1.key })
        
        // Формируем массив записей для графика
        for (year, value) in sortedData {
            let dataEntry = BarChartDataEntry(x: Double(year), y: value) // x - года, y - значения
            
            dataEntries.append(dataEntry)
        }
        
        // Создаём набор данных для графика
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Gross Profit Data")
        chartDataSet.colors = [NSUIColor.green]
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // Устанавливаем данные для графика
        chartView.data = chartData
        
        // Устанавливаем форматтер оси X
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 0)
        chartView.xAxis.granularity = 1  // Показываем все года
        chartView.xAxis.labelPosition = .bottom
        
        chartView.leftAxis.axisMinimum = 0  // Минимальное значение оси Y
        chartView.rightAxis.enabled = false
    }
    func updateChart(with data: OperatingIncomeLoss, for chartView: BarChartView) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        let yearlyData = data.yearlyValues
        let sortedData = yearlyData.sorted(by: { $0.key < $1.key })
        
        // Формируем массив записей для графика
        for (year, value) in sortedData {
            let dataEntry = BarChartDataEntry(x: Double(year), y: value) // x - года, y - значения
            
            dataEntries.append(dataEntry)
        }
        
        // Создаём набор данных для графика
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Operating Income Loss Data")
        chartDataSet.colors = [NSUIColor.red]
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // Устанавливаем данные для графика
        chartView.data = chartData
        
        // Устанавливаем форматтер оси X
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 0)
        chartView.xAxis.granularity = 1  // Показываем все года
        chartView.xAxis.labelPosition = .bottom
        
        chartView.leftAxis.axisMinimum = 0  // Минимальное значение оси Y
        chartView.rightAxis.enabled = false
    }
    
    // MARK: Fetching API data
    func fethingAllIncomeData(cikCode: String) {
        let netIncomeURL = "https://data.sec.gov/api/xbrl/companyconcept/CIK\(cikCode)/us-gaap/NetIncomeLoss.json"
        let grossProfitURL = "https://data.sec.gov/api/xbrl/companyconcept/CIK\(cikCode)/us-gaap/GrossProfit.json"
        let operatingIncomeURL = "https://data.sec.gov/api/xbrl/companyconcept/CIK\(cikCode)/us-gaap/OperatingIncomeLoss.json"
        
        let dispatchGroup = DispatchGroup()
        
        var netIncomeData: NetIncomeLoss?
        var grossProfitData: GrossProfit?
        var operatingIncomeData: OperatingIncomeLoss?
        
        // Fetch Net Income Loss Data
        dispatchGroup.enter()
        AF.request(netIncomeURL).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                netIncomeData = NetIncomeLoss(json: json)
                print("Net Income Data fetched successfully")
            case .failure(let error):
                print("Error fetching Net Income data: \(error)")
            }
            dispatchGroup.leave()
        }
        
        // Fetch Gross Profit Data
        dispatchGroup.enter()
        AF.request(grossProfitURL).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                grossProfitData = GrossProfit(json: json)
                print("Gross Profit Data fetched successfully")
            case .failure(let error):
                print("Error fetching Gross Profit data: \(error)")
            }
            dispatchGroup.leave()
        }
        
        // Fetch Operating Income Loss Data
        dispatchGroup.enter()
        AF.request(operatingIncomeURL).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                operatingIncomeData = OperatingIncomeLoss(json: json)
                print("Operating Income Data fetched successfully")
            case .failure(let error):
                print("Error fetching Operating Income data: \(error)")
            }
            dispatchGroup.leave()
        }
        
        // This will be called when all requests are completed
        dispatchGroup.notify(queue: .main) {
            if let netIncomeData = netIncomeData,
               let grossProfitData = grossProfitData,
               let operatingIncomeData = operatingIncomeData {
                
                // Update the charts
                self.updateChart(with: netIncomeData, for: self.barChartView1)
                self.updateChart(with: grossProfitData, for: self.barChartView2)
                self.updateChart(with: operatingIncomeData, for: self.barChartView3)
                
                // Set data to labels
                self.setData(netIncomeData: netIncomeData, grossProfitData: grossProfitData, operatingIncomeData: operatingIncomeData)
            } else {
                print("Failed to fetch some or all data")
            }
        }
    }
    
    
    
}


