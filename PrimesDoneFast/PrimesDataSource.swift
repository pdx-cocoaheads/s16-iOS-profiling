import Foundation
import UIKit


protocol PrimeGenerator {
    func primesUpTo(max: UInt) -> [UInt]
}

// Prime sieve from the interwebs
class FunctionalSieve: PrimeGenerator {
    func primesUpTo(max: UInt) -> [UInt] {
        return [1] + sieve(Array(2...max))
    }

    /// @param numbers must be an array of sequential numbers, not smaller than 2
    private func sieve(numbers: [UInt]) -> [UInt] {
        if numbers.isEmpty { return [] }
        let p = numbers[0]
        assert(p > 1, "numbers must start at 2 or higher")
        let rest = numbers[1..<numbers.count]
        return [p] + sieve(rest.filter { $0 % p > 0 })
    }

}

class PrimesDataSource: NSObject, UITableViewDataSource {
    var primes = [UInt]()
    var didFinishGeneratingPrimes: (() -> ())?

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrimeCell", forIndexPath: indexPath)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        cell.textLabel?.text = "\(primes[indexPath.row])"
        cell.detailTextLabel?.text = formatter.stringFromDate(NSDate())
        return cell
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        return
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return primes.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func refresh() {
        self.primes = FunctionalSieve().primesUpTo(50000)
        self.didFinishGeneratingPrimes?()
    }
}