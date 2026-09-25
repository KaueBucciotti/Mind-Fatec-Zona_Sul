import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// -----------------------------------------------------------------------
/// LoginScreen
/// -----------------------------------------------------------------------
/// Tela de login (imagem 4 do design). Permite entrar com e-mail/senha
/// ou via Google, e navegar para o cadastro.
/// -----------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey do formulário: permite validar todos os campos de uma vez.
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _isLoading = false;
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  /// Simula a chamada de login. Em produção, aqui entraria a chamada
  /// real ao backend/serviço de autenticação (ex: Firebase Auth, API REST).
  Future<void> _handleLogin() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    setState(() => _isLoading = true);

    // TODO: substituir pela chamada real ao serviço de autenticação.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe seu e-mail';
    final emailValido = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(valor);
    if (!emailValido) return 'E-mail inválido';
    return null;
  }

  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe sua senha';
    if (valor.length < 6) return 'Senha muito curta';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spaceXL),
                _buildLogo(),
                const SizedBox(height: AppConstants.spaceL),
                Text('Bem-vindo de volta', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text('Faça login para continuar', style: AppTextStyles.bodySecondary),
                const SizedBox(height: AppConstants.spaceL),

                AppTextField(
                  label: 'E-mail',
                  hint: 'joao@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarEmail,
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Senha',
                  hint: '••••••••',
                  controller: _senhaController,
                  obscureText: !_senhaVisivel,
                  validator: _validarSenha,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: implementar fluxo de recuperação de senha.
                    },
                    child: Text('Esqueci minha senha', style: AppTextStyles.link),
                  ),
                ),

                const SizedBox(height: AppConstants.spaceS),
                PrimaryButton(
                  label: 'Entrar',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: AppConstants.spaceL),
                _buildDivisorOu(),
                const SizedBox(height: AppConstants.spaceL),

                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: implementar login social com Google.
                  },
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                  label: const Text('Continuar com Google'),
                ),

                const SizedBox(height: AppConstants.spaceXL),
                _buildRodapeCadastro(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        const Icon(Icons.spa_rounded, color: AppColors.primary, size: 22),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.appName, style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
            Text(AppConstants.appTagline, style: AppTextStyles.caption.copyWith(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  Widget _buildDivisorOu() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
          child: Text('ou', style: AppTextStyles.bodySecondary),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildRodapeCadastro() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text('Não tem conta? ', style: AppTextStyles.bodySecondary),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
            child: Text(
              'Criar agora',
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
