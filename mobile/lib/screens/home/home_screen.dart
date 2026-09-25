import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../models/psychologist_model.dart';
import '../../widgets/psychologist_card.dart';
import 'widgets/home_header.dart';
import 'widgets/next_session_card.dart';
import 'widgets/quick_stats_row.dart';

/// -----------------------------------------------------------------------
/// HomeScreen
/// -----------------------------------------------------------------------
/// Tela inicial (dashboard) do paciente — imagens 6 e 7 do design.
/// Mostra: saudação + humor do dia, busca rápida, próxima sessão,
/// psicólogos recomendados, banner de planos e estatísticas rápidas.
///
/// Esta tela é composta por vários widgets pequenos (em widgets/) para
/// manter o `build` legível e permitir reaproveitar cada bloco em
/// outras telas futuramente.
/// -----------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _humorSelecionado;

  // TODO: substituir dados mockados por dados vindos de um repositório/API.
  final List<AppointmentModel> _consultas = AppointmentModel.mockList();
  final List<PsychologistModel> _recomendados = PsychologistModel.mockList();

  @override
  Widget build(BuildContext context) {
    // Pega apenas a próxima consulta futura (a primeira da lista mockada).
    final proximaConsulta = _consultas.isNotEmpty ? _consultas.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeHeader(
              nomeUsuario: 'João',
              humorSelecionado: _humorSelecionado,
              onHumorSelecionado: (humor) => setState(() => _humorSelecionado = humor),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBarraDeBusca(context),
                  const SizedBox(height: AppConstants.spaceL),

                  if (proximaConsulta != null) ...[
                    _buildTituloSecao('Próxima sessão', onVerTodas: () {}),
                    const SizedBox(height: AppConstants.spaceS),
                    NextSessionCard(
                      consulta: proximaConsulta,
                      onEntrarNaSala: () {
                        // TODO: navegar para a sala de videoconferência.
                      },
                    ),
                    const SizedBox(height: AppConstants.spaceL),
                  ],

                  _buildTituloSecao('Recomendados', onVerTodas: () {}),
                  const SizedBox(height: AppConstants.spaceS),
                  ..._recomendados.map(
                    (psicologo) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spaceM),
                      child: PsychologistCard(
                        psicologo: psicologo,
                        onVerPerfil: () {
                          // TODO: navegar para a tela de perfil do psicólogo.
                        },
                      ),
                    ),
                  ),

                  _buildBannerPlanos(),
                  const SizedBox(height: AppConstants.spaceL),

                  QuickStatsRow.home(sessoes: 12, meses: 4, percentualPresenca: 98),
                  const SizedBox(height: AppConstants.spaceL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraDeBusca(BuildContext context) {
    return TextField(
      readOnly: true, // Ao tocar, leva para a tela de busca completa.
      onTap: () {
        // TODO: mudar para a aba de busca via callback do MainNavigationScreen.
      },
      decoration: InputDecoration(
        hintText: 'Buscar psicólogos...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune_rounded, color: AppColors.textSecondary),
          onPressed: () {
            // TODO: abrir tela de filtros.
          },
        ),
      ),
    );
  }

  Widget _buildTituloSecao(String titulo, {required VoidCallback onVerTodas}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: AppTextStyles.heading2),
        GestureDetector(
          onTap: onVerTodas,
          child: Text('Ver todas', style: AppTextStyles.link),
        ),
      ],
    );
  }

  /// Banner promocional de planos exibido no fim do feed da Home.
  Widget _buildBannerPlanos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spaceM),
      margin: const EdgeInsets.only(bottom: AppConstants.spaceL),
      decoration: BoxDecoration(
        color: AppColors.backgroundMint,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CONHEÇA NOSSOS PLANOS', style: AppTextStyles.inputLabel.copyWith(color: AppColors.primary)),
          const SizedBox(height: 4),
          Text('A partir de R\$ 50/mês', style: AppTextStyles.heading2),
          const SizedBox(height: 2),
          Text('Sessões ilimitadas com valores reduzidos', style: AppTextStyles.bodySecondary),
          const SizedBox(height: AppConstants.spaceM),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: navegar para a tela de planos.
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Ver planos'),
            ),
          ),
        ],
      ),
    );
  }
}
