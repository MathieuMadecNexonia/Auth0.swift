import Foundation
import Quick
import Nimble

@testable import Auth0

class TransactionStoreSpec: QuickSpec {

    override func spec() {

        var storage: TransactionStore!
        var transaction: SpyTransaction!

        beforeEach {
            storage = TransactionStore()
            transaction = SpyTransaction()
        }

        describe("storage") {

            it("should store transaction") {
                storage.store(transaction)
            }

            it("should cancel current transaction") {
                storage.store(transaction)
                storage.store(SpyTransaction())
                expect(transaction.isCancelled) == true
            }

            it("should clear current transaction") {
                storage.store(transaction)
                storage.clear()
                expect(storage.current).to(beNil())
            }

        }

        describe("cancel") {

            it("should be noop when there is no current transaction") {
                transaction.cancel()
            }

            it("should cancel current transaction") {
                storage.store(transaction)
                storage.cancel()
                expect(transaction.isCancelled) == true
            }

        }

        describe("resume") {

            let url = URL(string: "https://auth0.com")!

            beforeEach {
                storage.store(transaction)
                transaction.isResumed = true
            }

            it("should resume current transaction") {
                expect(storage.resume(url)) == true
            }

            it("should return false when there is no current transaction") {
                storage.cancel()
                expect(storage.resume(url)) == false
            }

        }

    }

}
