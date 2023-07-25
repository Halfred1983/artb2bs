// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:artb2b/ui/services/app.module.dart' as _i11;
import 'package:artb2b/ui/services/firebase.service.dart' as _i6;
import 'package:auth_service/auth.dart' as _i4;
import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:database_service/database.dart' as _i8;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:firebase_storage/firebase_storage.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i10;
import 'package:storage_service/storage.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule(this);
    gh.factory<_i3.FirebaseAuth>(() => appModule.auth);
    gh.factory<_i4.FirebaseAuthService>(() => appModule.authService);
    gh.factory<_i5.FirebaseFirestore>(() => appModule.store);
    await gh.factoryAsync<_i6.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    gh.factory<_i7.FirebaseStorage>(() => appModule.storage);
    gh.factory<_i8.FirestoreDatabaseService>(() => appModule.databaseService);
    gh.factory<_i9.FirestoreStorageService>(
        () => appModule.firebaseStorageService);
    await gh.factoryAsync<_i10.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    return this;
  }
}

class _$AppModule extends _i11.AppModule {
  _$AppModule(this._getIt);

  final _i1.GetIt _getIt;

  @override
  _i4.FirebaseAuthService get authService => _i4.FirebaseAuthService(
        _getIt<_i3.FirebaseAuth>(),
        _getIt<_i10.SharedPreferences>(),
      );
}
