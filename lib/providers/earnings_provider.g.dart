// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalEarningsHash() => r'0606eb63cf10dcc9825cdcef8f7c4966f76eafbf';

/// See also [totalEarnings].
@ProviderFor(totalEarnings)
final totalEarningsProvider = AutoDisposeProvider<double>.internal(
  totalEarnings,
  name: r'totalEarningsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$totalEarningsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalEarningsRef = AutoDisposeProviderRef<double>;
String _$earningsCalculatorHash() =>
    r'3ab01c7cea25cc442ffe24a5a0b8b57372c3ea1b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [earningsCalculator].
@ProviderFor(earningsCalculator)
const earningsCalculatorProvider = EarningsCalculatorFamily();

/// See also [earningsCalculator].
class EarningsCalculatorFamily extends Family<double> {
  /// See also [earningsCalculator].
  const EarningsCalculatorFamily();

  /// See also [earningsCalculator].
  EarningsCalculatorProvider call(Duration duration) {
    return EarningsCalculatorProvider(duration);
  }

  @override
  EarningsCalculatorProvider getProviderOverride(
    covariant EarningsCalculatorProvider provider,
  ) {
    return call(provider.duration);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'earningsCalculatorProvider';
}

/// See also [earningsCalculator].
class EarningsCalculatorProvider extends AutoDisposeProvider<double> {
  /// See also [earningsCalculator].
  EarningsCalculatorProvider(Duration duration)
    : this._internal(
        (ref) => earningsCalculator(ref as EarningsCalculatorRef, duration),
        from: earningsCalculatorProvider,
        name: r'earningsCalculatorProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$earningsCalculatorHash,
        dependencies: EarningsCalculatorFamily._dependencies,
        allTransitiveDependencies:
            EarningsCalculatorFamily._allTransitiveDependencies,
        duration: duration,
      );

  EarningsCalculatorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.duration,
  }) : super.internal();

  final Duration duration;

  @override
  Override overrideWith(
    double Function(EarningsCalculatorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EarningsCalculatorProvider._internal(
        (ref) => create(ref as EarningsCalculatorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        duration: duration,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _EarningsCalculatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EarningsCalculatorProvider && other.duration == duration;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, duration.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EarningsCalculatorRef on AutoDisposeProviderRef<double> {
  /// The parameter `duration` of this provider.
  Duration get duration;
}

class _EarningsCalculatorProviderElement
    extends AutoDisposeProviderElement<double>
    with EarningsCalculatorRef {
  _EarningsCalculatorProviderElement(super.provider);

  @override
  Duration get duration => (origin as EarningsCalculatorProvider).duration;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
