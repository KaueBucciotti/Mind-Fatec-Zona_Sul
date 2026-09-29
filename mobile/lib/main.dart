import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

/// -----------------------------------------------------------------------
/// main
/// -----------------------------------------------------------------------
/// Ponto de entrada da aplicação. Mantido enxuto de propósito: toda a
/// configuração de tema fica em `core/theme` e todas as rotas em
/// `core/routes`, para que este arquivo não precise ser alterado com
/// frequência conforme o app cresce.
/// -----------------------------------------------------------------------
void main() {
  runApp(const MindApp());
}

/// Widget raiz do aplicativo Mind.
class MindApp extends StatelessWidget {
  const MindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // A tela inicial é o onboarding; após concluído, o usuário segue
      // para login/cadastro e, então, para a navegação principal (tabs).
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
    );
  }
}
