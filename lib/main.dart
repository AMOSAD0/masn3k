import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database;

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<InventoryRepository>(
          create:
              (context) => InventoryRepositoryImpl(
                InventoryLocalDataSource(databaseHelper),
              ),
        ),
        RepositoryProvider<DashboardRepository>(
          create:
              (context) => DashboardRepositoryImpl(
                DashboardLocalDataSource(databaseHelper),
              ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InventoryBloc>(
            create:
                (context) => InventoryBloc(context.read<InventoryRepository>()),
          ),
          BlocProvider<DashboardBloc>(
            create:
                (context) => DashboardBloc(context.read<DashboardRepository>()),
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
