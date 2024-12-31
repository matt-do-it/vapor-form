//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: stargate.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// The gPRC service to interact with a Stargate coordinator.
///
/// Usage: instantiate `Stargate_StargateClient`, then call methods of this protocol to make API calls.
internal protocol Stargate_StargateClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Stargate_StargateClientInterceptorFactoryProtocol? { get }

  func executeQuery(
    _ request: Stargate_Query,
    callOptions: CallOptions?
  ) -> UnaryCall<Stargate_Query, Stargate_Response>

  func executeBatch(
    _ request: Stargate_Batch,
    callOptions: CallOptions?
  ) -> UnaryCall<Stargate_Batch, Stargate_Response>
}

extension Stargate_StargateClientProtocol {
  internal var serviceName: String {
    return "stargate.Stargate"
  }

  /// Executes a single CQL query.
  ///
  /// - Parameters:
  ///   - request: Request to send to ExecuteQuery.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func executeQuery(
    _ request: Stargate_Query,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Stargate_Query, Stargate_Response> {
    return self.makeUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeQuery.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteQueryInterceptors() ?? []
    )
  }

  /// Executes a batch of CQL queries.
  ///
  /// - Parameters:
  ///   - request: Request to send to ExecuteBatch.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func executeBatch(
    _ request: Stargate_Batch,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Stargate_Batch, Stargate_Response> {
    return self.makeUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeBatch.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteBatchInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Stargate_StargateClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Stargate_StargateNIOClient")
internal final class Stargate_StargateClient: Stargate_StargateClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Stargate_StargateClientInterceptorFactoryProtocol?
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  internal var interceptors: Stargate_StargateClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the stargate.Stargate service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Stargate_StargateClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

internal struct Stargate_StargateNIOClient: Stargate_StargateClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Stargate_StargateClientInterceptorFactoryProtocol?

  /// Creates a client for the stargate.Stargate service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Stargate_StargateClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// The gPRC service to interact with a Stargate coordinator.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol Stargate_StargateAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Stargate_StargateClientInterceptorFactoryProtocol? { get }

  func makeExecuteQueryCall(
    _ request: Stargate_Query,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Stargate_Query, Stargate_Response>

  func makeExecuteBatchCall(
    _ request: Stargate_Batch,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Stargate_Batch, Stargate_Response>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Stargate_StargateAsyncClientProtocol {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return Stargate_StargateClientMetadata.serviceDescriptor
  }

  internal var interceptors: Stargate_StargateClientInterceptorFactoryProtocol? {
    return nil
  }

  internal func makeExecuteQueryCall(
    _ request: Stargate_Query,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Stargate_Query, Stargate_Response> {
    return self.makeAsyncUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeQuery.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteQueryInterceptors() ?? []
    )
  }

  internal func makeExecuteBatchCall(
    _ request: Stargate_Batch,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Stargate_Batch, Stargate_Response> {
    return self.makeAsyncUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeBatch.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteBatchInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Stargate_StargateAsyncClientProtocol {
  internal func executeQuery(
    _ request: Stargate_Query,
    callOptions: CallOptions? = nil
  ) async throws -> Stargate_Response {
    return try await self.performAsyncUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeQuery.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteQueryInterceptors() ?? []
    )
  }

  internal func executeBatch(
    _ request: Stargate_Batch,
    callOptions: CallOptions? = nil
  ) async throws -> Stargate_Response {
    return try await self.performAsyncUnaryCall(
      path: Stargate_StargateClientMetadata.Methods.executeBatch.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeExecuteBatchInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal struct Stargate_StargateAsyncClient: Stargate_StargateAsyncClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Stargate_StargateClientInterceptorFactoryProtocol?

  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Stargate_StargateClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

internal protocol Stargate_StargateClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'executeQuery'.
  func makeExecuteQueryInterceptors() -> [ClientInterceptor<Stargate_Query, Stargate_Response>]

  /// - Returns: Interceptors to use when invoking 'executeBatch'.
  func makeExecuteBatchInterceptors() -> [ClientInterceptor<Stargate_Batch, Stargate_Response>]
}

internal enum Stargate_StargateClientMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Stargate",
    fullName: "stargate.Stargate",
    methods: [
      Stargate_StargateClientMetadata.Methods.executeQuery,
      Stargate_StargateClientMetadata.Methods.executeBatch,
    ]
  )

  internal enum Methods {
    internal static let executeQuery = GRPCMethodDescriptor(
      name: "ExecuteQuery",
      path: "/stargate.Stargate/ExecuteQuery",
      type: GRPCCallType.unary
    )

    internal static let executeBatch = GRPCMethodDescriptor(
      name: "ExecuteBatch",
      path: "/stargate.Stargate/ExecuteBatch",
      type: GRPCCallType.unary
    )
  }
}

/// The gPRC service to interact with a Stargate coordinator.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Stargate_StargateProvider: CallHandlerProvider {
  var interceptors: Stargate_StargateServerInterceptorFactoryProtocol? { get }

  /// Executes a single CQL query.
  func executeQuery(request: Stargate_Query, context: StatusOnlyCallContext) -> EventLoopFuture<Stargate_Response>

  /// Executes a batch of CQL queries.
  func executeBatch(request: Stargate_Batch, context: StatusOnlyCallContext) -> EventLoopFuture<Stargate_Response>
}

extension Stargate_StargateProvider {
  internal var serviceName: Substring {
    return Stargate_StargateServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "ExecuteQuery":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Stargate_Query>(),
        responseSerializer: ProtobufSerializer<Stargate_Response>(),
        interceptors: self.interceptors?.makeExecuteQueryInterceptors() ?? [],
        userFunction: self.executeQuery(request:context:)
      )

    case "ExecuteBatch":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Stargate_Batch>(),
        responseSerializer: ProtobufSerializer<Stargate_Response>(),
        interceptors: self.interceptors?.makeExecuteBatchInterceptors() ?? [],
        userFunction: self.executeBatch(request:context:)
      )

    default:
      return nil
    }
  }
}

/// The gPRC service to interact with a Stargate coordinator.
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol Stargate_StargateAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Stargate_StargateServerInterceptorFactoryProtocol? { get }

  /// Executes a single CQL query.
  func executeQuery(
    request: Stargate_Query,
    context: GRPCAsyncServerCallContext
  ) async throws -> Stargate_Response

  /// Executes a batch of CQL queries.
  func executeBatch(
    request: Stargate_Batch,
    context: GRPCAsyncServerCallContext
  ) async throws -> Stargate_Response
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Stargate_StargateAsyncProvider {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return Stargate_StargateServerMetadata.serviceDescriptor
  }

  internal var serviceName: Substring {
    return Stargate_StargateServerMetadata.serviceDescriptor.fullName[...]
  }

  internal var interceptors: Stargate_StargateServerInterceptorFactoryProtocol? {
    return nil
  }

  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "ExecuteQuery":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Stargate_Query>(),
        responseSerializer: ProtobufSerializer<Stargate_Response>(),
        interceptors: self.interceptors?.makeExecuteQueryInterceptors() ?? [],
        wrapping: { try await self.executeQuery(request: $0, context: $1) }
      )

    case "ExecuteBatch":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Stargate_Batch>(),
        responseSerializer: ProtobufSerializer<Stargate_Response>(),
        interceptors: self.interceptors?.makeExecuteBatchInterceptors() ?? [],
        wrapping: { try await self.executeBatch(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

internal protocol Stargate_StargateServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'executeQuery'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeExecuteQueryInterceptors() -> [ServerInterceptor<Stargate_Query, Stargate_Response>]

  /// - Returns: Interceptors to use when handling 'executeBatch'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeExecuteBatchInterceptors() -> [ServerInterceptor<Stargate_Batch, Stargate_Response>]
}

internal enum Stargate_StargateServerMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Stargate",
    fullName: "stargate.Stargate",
    methods: [
      Stargate_StargateServerMetadata.Methods.executeQuery,
      Stargate_StargateServerMetadata.Methods.executeBatch,
    ]
  )

  internal enum Methods {
    internal static let executeQuery = GRPCMethodDescriptor(
      name: "ExecuteQuery",
      path: "/stargate.Stargate/ExecuteQuery",
      type: GRPCCallType.unary
    )

    internal static let executeBatch = GRPCMethodDescriptor(
      name: "ExecuteBatch",
      path: "/stargate.Stargate/ExecuteBatch",
      type: GRPCCallType.unary
    )
  }
}
