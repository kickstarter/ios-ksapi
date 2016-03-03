import protocol ReactiveCocoa.SignalProducerType
import struct ReactiveCocoa.SignalProducer
import protocol ReactiveCocoa.OptionalType

internal extension SignalProducerType where Value: ReactiveCocoa.OptionalType {

  /// When a `nil` value is emitted this signal will fail with `error`. The returned
  /// signal will also now emit the unwrapped values.
  @warn_unused_result(message="Did you forget to call `start` on the producer?")
  internal func failOnNil(error: Error) -> SignalProducer<Value.Wrapped, Error> {
    return producer
      .flatMap(.Concat) { (value) -> SignalProducer<Value.Wrapped, Error> in
        if let value = value.optional {
          return SignalProducer<Value.Wrapped, Error>(value: value)
        } else {
          return SignalProducer<Value.Wrapped, Error>(error: error)
        }
    }
  }
}
