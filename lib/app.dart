import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_template_firebase/common/info/info_listene.dart';
import 'package:login_template_firebase/common/widgets/custom_loading_indicator.dart';
import 'package:login_template_firebase/cubits/auth_cubit.dart';
import 'package:login_template_firebase/features/login/domain/cubits/user_cubit.dart';
import 'package:login_template_firebase/pages/base_scaffold/base_scaffold.dart';
import 'package:login_template_firebase/pages/login/login_page.dart';

import 'common/configuration/injection.dart';
import 'common/flavors/flavors.dart';
import 'common/theme/theme.dart';
import 'cubits/base_scaffold/base_scaffold_cubit.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      theme: CustomTheme.lightTheme,
      home: _flavorBanner(
        child: const MyApp(),
        show: kDebugMode,
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              child: child,
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                letterSpacing: 1.0,
              ),
              textDirection: TextDirection.ltr,
            )
          : Container(
              child: child,
            );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<AuthCubit>(),
        ),
        BlocProvider(
          create: (BuildContext context) => BaseScaffoldCubit(),
        ),
      ],
      child: InfoListener(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPassed) {
              locator<UserCubit>().isNewUser();
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CustomLoadingIndicator();
            }
            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoggedIn) {
                  return const BaseScaffold();
                }
                return const LoginPage();
              },
            );
          },
        ),
      ),
    );
  }
}
