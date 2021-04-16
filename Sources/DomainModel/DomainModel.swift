struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String  // USD, GBP, EUR, CAN
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ currencyType: String) -> Money {
        var finalAmount = Money.convertToUSD(Double(self.amount), self.currency)
        switch currencyType {
            case "GBP":
                finalAmount *= 0.5
            case "EUR":
                finalAmount *= 1.5
            case "CAN":
                finalAmount *= 1.25
            default:
                break
        }
        finalAmount.round()
        return Money(amount: Int(finalAmount), currency: currencyType)
    }
    
    static func convertToUSD(_ amount: Double, _ currency: String) -> Double {
        var usdCurrency : Double = amount
        switch currency {
            case "GBP":
                usdCurrency *= 2.0
            case "EUR":
                usdCurrency *= 2.0/3.0
            case "CAN":
                usdCurrency *= 4.0/5.0
            default:
                break
        }
        usdCurrency.round()
        return usdCurrency
    }
    
    func add(_ m1: Money) -> Money {
        let currentCurrency = m1.currency;
        let m2 = self.convert(currentCurrency)
        return Money(amount: m2.amount + m1.amount, currency: currentCurrency)
    }
        
    func subtract(_ m1: Money) -> Money {
        let currentCurrency = m1.currency;
        let m2 = self.convert(currentCurrency)
        return Money(amount: m2.amount - m1.amount, currency: currentCurrency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String // describing the name of the job
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {  // two types of job types
        case Hourly(Double)
        case Salary(UInt)
    }

    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
            case .Salary (let salary):
                return Int(salary)
            case .Hourly (let hourlyWage):
                return Int(hourlyWage * Double(hours))
        }
    }
    
    func raise(byAmount: Double) { // raise by value amount > 1
        switch self.type {
            case .Salary (let salary):
                let newAmount = UInt(Double(salary) + byAmount)
                self.type = JobType.Salary(newAmount)
            case .Hourly (let hourlywage):
                self.type = JobType.Hourly(hourlywage + byAmount)
        }
    }
    
    func raise(byPercent: Double) {  // raise by percentage 0 - 1.0
        switch self.type {
            case .Salary (let salary):
                let increaseAmount = Double(salary) * byPercent
                self.type = JobType.Salary(UInt(Double(salary) + increaseAmount))
            case .Hourly (let hourlyWage):
                let increaseAmount = Double(hourlyWage * byPercent)
                self.type = JobType.Hourly(hourlyWage + increaseAmount)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet { // called after setting new value
            if (age < 16) {  // if age < 16 cannot have a job
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 18) {  // if age < 18 cannot have spouse
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String {
        return String("[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.title) spouse:\(self.spouse?.toString())]")
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: Array<Person>
    
    init(spouse1: Person, spouse2: Person) {
        self.members = []
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members.count == 2) {
            if ((members[0].age > 21 || members[1].age > 21)) {
                members.append(child)
                return true
            }
        }
        return false
    }
        
    func householdIncome() -> Int {
        var total = 0;
        for member in members {
            total += member.job?.calculateIncome(2000) ?? 0
        }
        return total
    }
}
