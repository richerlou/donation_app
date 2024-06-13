import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:donation_management/core/data/services/application_service.dart';
import 'package:donation_management/core/data/providers/global_provider.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationService.initServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: GlobalProvider.providers,
      child: ScreenUtilInit(
        designSize: const Size(441.4, 774.9),
        builder: (context, child) => MaterialApp(
          title: 'Davao Charitably',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splashScreen,
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
            tabBarTheme: const TabBarTheme(
              indicatorColor: Colors.white,
              labelColor:
                  Colors.white, // Change the color of the selected tab label
              unselectedLabelColor: Color.fromARGB(255, 207, 200,
                  200), // Change the color of the unselected tab label
            ),
          ),
        ),
      ),
    );
  }
}
