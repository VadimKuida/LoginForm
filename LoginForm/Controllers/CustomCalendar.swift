//
//  CustomCalendar.swift
//  LoginForm
//
//  Created by Вадим Куйда on 22.04.2021.
//

import Foundation
import Koyomi


class CalendarCustom: UIViewController {
    

    let segmentCalendare = UISegmentedControl(items: ["One","Two","Three"])
    fileprivate let invalidPeriodLength = 90
    var koyomi = Koyomi(frame: CGRect(x: 0, y : 0, width: 0, height: 0), sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
    var  selectDate: Date!
    let today = Date()
    let todayTo = Date() + 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.alpha = 1
        
        
        
        koyomi.frame = CGRect(x: 10, y : 60, width: view.frame.width-40, height: view.frame.height/1.5 - 80)
        koyomi.calendarDelegate = self
        koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        koyomi.weeks = ( "Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб")
        koyomi.style = .standard
        koyomi.dayPosition = .topCenter
        koyomi.selectionMode = .sequence(style: .background)
        koyomi.selectedStyleColor = UIColor(red: 71/255, green: 142/255, blue: 204/255, alpha: 0.9)

        segmentCalendare.frame  = CGRect(x: 5, y: 5, width: 300, height: 20)
        segmentCalendare.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentCalendare)
//        koyomi.display(in: .next)
        view.addSubview(koyomi)
 
        

    }
    
    
    
    
    
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        let month: MonthType = {
            switch sender.selectedSegmentIndex {
            case 0:  return .previous
            case 1:  return .current
            default: return .next
            }
        }()
        koyomi.display(in: month)
        koyomi.select(date: today, to: todayTo)
           }
    
        


}


extension CalendarCustom: KoyomiDelegate{
    
    
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        selectDate = date
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        print( dateString)
    }
    

    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        if length > invalidPeriodLength {
            print("More than \(invalidPeriodLength) days are invalid period.")
            return false
        }
        return true
    }
    
}


