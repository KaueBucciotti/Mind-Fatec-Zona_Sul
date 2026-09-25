import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

/// -----------------------------------------------------------------------
/// SignupScreen
/// -----------------------------------------------------------------------
/// Tela de criação de conta (imagem 5 do design). Coleta nome, e-mail,
/// telefone, senha e o tipo de conta (Paciente ou Psicólogo).
/// -----------------------------------------------------------------------
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // Papel selecionado (Paciente por padrão, como no design).
  UserRole _roleSelecionado = UserRole.paciente;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _handleCriarConta() async {
    final formularioValido = _formKey.currentState?.validate() ?? false;
    if (!formularioValido) return;

    setState(() => _isLoading = true);

    // TODO: substituir pela chamada real de criação de conta na API.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  String? _validarObrigatorio(String? valor, String mensagem) {
    if (valor == null || valor.trim().isEmpty) return mensagem;
    return null;
  }

  String? _validarConfirmacaoSenha(String? valor) {
    if (valor != _senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Criar conta', style: AppTextStyles.heading3),
            Text('Comece sua jornada', style: AppTextStyles.caption),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Nome completo',
                  hint: 'João Silva',
                  controller: _nomeController,
                  validator: (v) => _validarObrigatorio(v, 'Informe seu nome'),
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'E-mail',
                  hint: 'joao@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => _validarObrigatorio(v, 'Informe seu e-mail'),
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Telefone',
                  hint: '(11) 99999-9999',
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) => _validarObrigatorio(v, 'Informe seu telefone'),
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Senha',
                  hint: 'Mín. 8 caracteres',
                  controller: _senhaController,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 8) return 'Mínimo de 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spaceM),

                AppTextField(
                  label: 'Confirmar senha',
                  hint: 'Repita a senha',
                  controller: _confirmarSenhaController,
                  obscureText: true,
                  validator: _validarConfirmacaoSenha,
                ),
                const SizedBox(height: AppConstants.spaceM),

                Text('SOU UM', style: AppTextStyles.inputLabel),
                const SizedBox(height: 8),
                _buildSeletorDeRole(),

                const SizedBox(height: AppConstants.spaceL),
                PrimaryButton(
                  label: 'Criar conta',
                  isLoading: _isLoading,
                  onPressed: _handleCriarConta,
                  backgroundColor: AppColors.primary,
                ),

                const SizedBox(height: AppConstants.spaceM),
                _buildTextoTermos(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Seletor "Paciente" / "Psicólogo" (segmented control customizado).
  Widget _buildSeletorDeRole() {
    return Row(
      children: [
        Expanded(child: _RoleOption(
          label: 'Paciente',
          selecionado: _roleSelecionado == UserRole.paciente,
          onTap: () => setState(() => _roleSelecionado = UserRole.paciente),
        )),
        const SizedBox(width: AppConstants.spaceS),
        Expanded(child: _RoleOption(
          label: 'Psicólogo',
          selecionado: _roleSelecionado == UserRole.psicologo,
          onTap: () => setState(() => _roleSelecionado = UserRole.psicologo),
        )),
      ],
    );
  }

  Widget _buildTextoTermos() {
    return Center(
      child: Text(
        'Ao criar conta você concorda com os Termos de Uso e Privacidade.',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption,
      ),
    );
  }
}

/// Botão de seleção usado no seletor "Paciente / Psicólogo".
class _RoleOption extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: selecionado ? AppColors.accent : AppColors.border,
            width: selecionado ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selecionado ? AppColors.accent : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
