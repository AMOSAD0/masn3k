import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masn3k/features/activities/data/datasources/activity_local_data_source.dart';
import 'package:masn3k/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:masn3k/features/activities/domin/repositories/activity_repository.dart';
import 'package:masn3k/features/production/data/production_local_data_source.dart';
import 'package:masn3k/features/production/data/repositories/production_repositry_impl.dart';
import 'package:masn3k/features/production/domain/repository/production_repository.dart';
import 'package:masn3k/features/production/presentation/bloc/bloc_machien/machien_bloc.dart';
import 'package:masn3k/features/production/presentation/bloc/bloc_machien/machien_event.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'db/database_helper.dart';
import 'features/inventory/data/datasources/inventory_local_data_source.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/repositories/inventory_repository.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'widgets/dashboard_page.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} => $change');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;
  // final ProductionLocalDataSource data;

  const MyApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<InventoryRepository>(
          create: (context) =>
              InventoryRepositoryImpl(InventoryLocalDataSource(databaseHelper)),
        ),
        RepositoryProvider<DashboardRepository>(
          create: (context) =>
              DashboardRepositoryImpl(DashboardLocalDataSource(databaseHelper)),
        ),
        RepositoryProvider<ActivityRepository>(
          create: (context) =>
              ActivityRepositoryImpl(ActivityLocalDataSource(databaseHelper)),
        ),
        RepositoryProvider<ProductionRepository>(
          create: (context) => ProductionRepositryImpl(
            ProductionLocalDataSource(databaseHelper),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InventoryBloc>(
            create: (context) => InventoryBloc(
              context.read<InventoryRepository>(),
              context.read<ActivityRepository>(),
            ),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) =>
                DashboardBloc(context.read<DashboardRepository>()),
          ),
          BlocProvider<MachienBloc>(
            create: (context) =>
                MachienBloc(context.read<ProductionRepository>())
                  ..add(LoadMachiens()),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // RTL Support
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // Home
          home: const DashboardPage(),
        ),
      ),
    );
  }
}
