import Foundation
import UIKit


protocol PrimeGenerator {
    func primesUpTo(max: UInt) -> [UInt]
}

// Prime sieve from the interwebs
class FunctionalSieve: PrimeGenerator {
    func primesUpTo(max: UInt) -> [UInt] {
        var primes: [UInt] = []
        for n in 2...max {
            var isPrime = true
            for prime in primes {
                if n % prime == 0 {
                    isPrime = false
                    break
                }
            }
            if isPrime { primes.append(n) }
        }
        return [1] + primes
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
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.primes = FunctionalSieve().primesUpTo(5000)
            dispatch_async(dispatch_get_main_queue()) {
                self.didFinishGeneratingPrimes?()
            }
        }
    }
}