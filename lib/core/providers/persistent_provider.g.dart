// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersistentNotifier)
const persistentProvider = PersistentNotifierProvider._();

final class PersistentNotifierProvider
    extends $NotifierProvider<PersistentNotifier, AsyncValue<CartModel>> {
  const PersistentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'persistentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$persistentNotifierHash();

  @$internal
  @override
  PersistentNotifier create() => PersistentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CartModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CartModel>>(value),
    );
  }
}

String _$persistentNotifierHash() =>
    r'6afee15fe49d48808b5ab89af05da78a88c76fe0';

abstract class _$PersistentNotifier extends $Notifier<AsyncValue<CartModel>> {
  AsyncValue<CartModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CartModel>, AsyncValue<CartModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CartModel>, AsyncValue<CartModel>>,
              AsyncValue<CartModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
