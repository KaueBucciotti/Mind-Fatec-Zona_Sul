import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/psychologist_model.dart';
import '../../widgets/psychologist_card.dart';
import 'filters_screen.dart';

/// -----------------------------------------------------------------------
/// SearchScreen
/// -----------------------------------------------------------------------
/// Tela de busca de psicólogos (imagem 12 do design). Contém campo de
/// busca por texto, chips de modalidade (Todos/Online/Presencial) e a
/// lista de resultados usando o [PsychologistCard] com botão de WhatsApp.
/// -----------------------------------------------------------------------
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _buscaController = TextEditingController();

  // Filtro de modalidade selecionado atualmente (via chips no topo).
  Modalidade? _modalidadeFiltro; // null = "Todos"

  // TODO: substituir por resultado vindo de uma API/repositório com paginação.
  final List<PsychologistModel> _todosOsPsicologos = PsychologistModel.mockList();

  /// Lista filtrada de acordo com o texto buscado e a modalidade escolhida.
  List<PsychologistModel> get _resultados {
    return _todosOsPsicologos.where((p) {
      final termo = _buscaController.text.trim().toLowerCase();
      final combinaTermo = termo.isEmpty ||
          p.nome.toLowerCase().contains(termo) ||
          p.especialidades.any((e) => e.toLowerCase().contains(termo));
      final combinaModalidade = _modalidadeFiltro == null || p.modalidades.contains(_modalidadeFiltro);
      return combinaTermo && combinaModalidade;
    }).toList();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _abrirFiltros() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FiltersScreen()),
    );
    // TODO: ao retornar, aplicar os filtros avançados escolhidos na tela FiltersScreen.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.screenPadding,
                AppConstants.spaceM,
                AppConstants.screenPadding,
                AppConstants.spaceS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampoBusca(),
                  const SizedBox(height: AppConstants.spaceM),
                  _buildChipsModalidade(),
                  const SizedBox(height: AppConstants.spaceS),
                  Text(
                    '${_resultados.length} profissionais encontrados',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _resultados.isEmpty
                  ? _buildEstadoVazio()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppConstants.screenPadding,
                        0,
                        AppConstants.screenPadding,
                        AppConstants.screenPadding,
                      ),
                      itemCount: _resultados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spaceM),
                      itemBuilder: (context, index) {
                        final psicologo = _resultados[index];
                        return PsychologistCard(
                          psicologo: psicologo,
                          showWhatsApp: true,
                          onVerPerfil: () {
                            // TODO: navegar para o perfil detalhado do psicólogo.
                          },
                          onWhatsApp: () {
                            // TODO: abrir conversa no WhatsApp com o profissional.
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoBusca() {
    return TextField(
      controller: _buscaController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Nome, abordagem, especialidade...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
          onPressed: _abrirFiltros,
        ),
      ),
    );
  }

  /// Chips horizontais de filtro rápido por modalidade de atendimento.
  Widget _buildChipsModalidade() {
    return Row(
      children: [
        _ModalidadeChip(
          label: 'Todos',
          selecionado: _modalidadeFiltro == null,
          onTap: () => setState(() => _modalidadeFiltro = null),
        ),
        const SizedBox(width: 8),
        _ModalidadeChip(
          label: 'Online',
          selecionado: _modalidadeFiltro == Modalidade.online,
          onTap: () => setState(() => _modalidadeFiltro = Modalidade.online),
        ),
        const SizedBox(width: 8),
        _ModalidadeChip(
          label: 'Presencial',
          selecionado: _modalidadeFiltro == Modalidade.presencial,
          onTap: () => setState(() => _modalidadeFiltro = Modalidade.presencial),
        ),
      ],
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: AppConstants.spaceM),
            Text('Nenhum psicólogo encontrado', style: AppTextStyles.heading3),
            const SizedBox(height: 4),
            Text(
              'Tente ajustar os termos de busca ou os filtros aplicados.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de seleção de modalidade (Todos / Online / Presencial).
class _ModalidadeChip extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _ModalidadeChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(color: selecionado ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selecionado ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
