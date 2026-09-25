import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../widgets/avatar_circle.dart';

/// -----------------------------------------------------------------------
/// AppointmentsScreen
/// -----------------------------------------------------------------------
/// Tela "Minhas consultas" (imagem 8 do design), com abas "Próximas" e
/// "Histórico" controladas por um [TabController].
///
/// Usa [SingleTickerProviderStateMixin] porque o TabController precisa
/// de um "ticker" para sincronizar a animação de troca de abas.
/// -----------------------------------------------------------------------
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // TODO: substituir por dados reais vindos de um repositório/API.
  final List<AppointmentModel> _todasAsConsultas = AppointmentModel.mockList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AppointmentModel> get _proximas => _todasAsConsultas
      .where((c) => c.status == AppointmentStatus.agendada && !c.dataHora.isBefore(DateTime.now().subtract(const Duration(hours: 1))))
      .toList();

  List<AppointmentModel> get _historico => _todasAsConsultas
      .where((c) => c.status != AppointmentStatus.agendada)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Minhas consultas', style: AppTextStyles.heading1.copyWith(fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accent,
          labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Próximas'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildListaConsultas(_proximas, mostrarBotaoEntrar: true),
            _buildListaConsultas(_historico, mostrarBotaoEntrar: false),
          ],
        ),
      ),
    );
  }

  Widget _buildListaConsultas(List<AppointmentModel> consultas, {required bool mostrarBotaoEntrar}) {
    if (consultas.isEmpty) {
      return Center(
        child: Text('Nenhuma consulta por aqui.', style: AppTextStyles.bodySecondary),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      itemCount: consultas.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceM),
      itemBuilder: (context, index) {
        final consulta = consultas[index];
        // O primeiro item da aba "Próximas" ganha destaque (card laranja),
        // igual ao comportamento visto no design.
        final isDestaque = mostrarBotaoEntrar && index == 0 && consulta.isHoje;
        return _AppointmentListItem(consulta: consulta, destaque: isDestaque);
      },
    );
  }
}

/// Item de lista representando uma única consulta (próxima ou passada).
class _AppointmentListItem extends StatelessWidget {
  final AppointmentModel consulta;
  final bool destaque;

  const _AppointmentListItem({required this.consulta, required this.destaque});

  String _formatarData(DateTime data) {
    const diasDaSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    if (consulta.isHoje) return 'Hoje';
    return '${diasDaSemana[data.weekday - 1]}, ${data.day} ${meses[data.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final horario = TimeOfDay.fromDateTime(consulta.dataHora).format(context);
    final corDeFundo = destaque ? AppColors.accent : AppColors.surface;
    final corDeTexto = destaque ? Colors.white : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      decoration: BoxDecoration(
        color: corDeFundo,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: destaque ? null : Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AvatarCircle(iniciais: consulta.psicologo.iniciais, seed: consulta.psicologo.id),
          const SizedBox(width: AppConstants.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consulta.psicologo.nome,
                  style: AppTextStyles.heading3.copyWith(color: corDeTexto),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatarData(consulta.dataHora)} · $horario · Online',
                  style: AppTextStyles.caption.copyWith(
                    color: destaque ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (destaque)
            ElevatedButton(
              onPressed: () {
                // TODO: navegar para a sala de videoconferência.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.accent,
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('Preparar e entrar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            )
          else
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        ],
      ),
    );
  }
}
