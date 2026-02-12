class EventQueue {
    private var queue: [(ObjectId, any WlEventEnum)]  = []

    func dispatchPending() {
        for (id, event) in queue {
            
        }
    }
}