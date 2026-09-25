import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import '../home/widgets/quick_stats_row.dart';

/// -----------------------------------------------------------------------
/// ProfileScreen
/// -----------------------------------------------------------------------
/// Tela de perfil do usuário (imagem 10 do design). Mostra dados básicos,
/// estatísticas, atalhos (editar perfil, pagamentos, consultas,
/// favoritos) e configurações (notificações, privacidade, ajuda).
/// -----------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: substituir pelo usuário real vindo da sessão autenticada.
  final UserModel _usuario = UserModel.mock();

  bool _notificacoesAtivas = true;

  Future<void> _confirmarSairDaConta() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmou == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          children: [
            _buildCabecalhoUsuario(),
            const SizedBox(height: AppConstants.spaceL),
            QuickStatsRow.home(
              sessoes: _usuario.totalSessoes,
              meses: _usuario.mesesDeJornada,
              percentualPresenca: _usuario.totalPsicologos, // Reaproveitando estrutura; ver nota abaixo.
            ),
            const SizedBox(height: AppConstants.spaceL),
            _buildSecaoAtalhos(),
            const SizedBox(height: AppConstants.spaceL),
            _buildSecaoConfiguracoes(),
            const SizedBox(height: AppConstants.spaceL),
            _buildBotaoSair(),
          ],
        ),
      ),
    );
  }

  /// Cartão verde no topo com foto/inicial, nome, e-mail e plano atual.
  Widget _buildCabecalhoUsuario() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceL),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white24,
            child: Text(
              _usuario.inicial,
              style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: AppConstants.spaceS),
          Text(_usuario.nome, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
          const SizedBox(height: 2),
          Text(_usuario.email, style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70)),
          const SizedBox(height: AppConstants.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            ),
            child: Text(
              _usuario.plano,
              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoAtalhos() {
    return _SettingsGroup(
      itens: [
        _SettingsItemData(icon: Icons.edit_rounded, label: 'Editar perfil', onTap: () {}),
        _SettingsItemData(icon: Icons.credit_card_rounded, label: 'Meu plano e pagamentos', onTap: () {}),
        _SettingsItemData(icon: Icons.calendar_today_rounded, label: 'Minhas consultas', onTap: () {}),
        _SettingsItemData(icon: Icons.favorite_border_rounded, label: 'Psicólogos favoritos', onTap: () {}),
      ],
    );
  }

  Widget _buildSecaoConfiguracoes() {
    return _SettingsGroup(
      itens: [
        _SettingsItemData(
          icon: Icons.notifications_none_rounded,
          label: 'Notificações',
          trailing: Switch(
            value: _notificacoesAtivas,
            activeColor: AppColors.accent,
            onChanged: (valor) => setState(() => _notificacoesAtivas = valor),
          ),
        ),
        _SettingsItemData(icon: Icons.lock_outline_rounded, label: 'Privacidade e segurança', onTap: () {}),
        _SettingsItemData(icon: Icons.help_outline_rounded, label: 'Ajuda e suporte', onTap: () {}),
      ],
    );
  }

  Widget _buildBotaoSair() {
    return TextButton.icon(
      onPressed: _confirmarSairDaConta,
      icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
      label: const Text('Sair da conta', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
    );
  }
}

/// Estrutura de um item da lista de configurações/atalhos.
class _SettingsItemData {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsItemData({required this.icon, required this.label, this.onTap, this.trailing});
}

/// Agrupamento visual (card branco arredondado) de itens de configuração,
/// separados por divisores — reaproveitado nas seções "Atalhos" e
/// "Configurações" do perfil.
class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItemData> itens;
  const _SettingsGroup({required this.itens});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(itens.length, (index) {
          final item = itens[index];
          final isUltimo = index == itens.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: AppColors.textPrimary),
                title: Text(item.label, style: AppTextStyles.body),
                trailing: item.trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                onTap: item.onTap,
              ),
              if (!isUltimo) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }
}
